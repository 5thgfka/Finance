/*
 * nao.cpp
 *
 *  Created on: 2016.1.3
 *      Author: ekse
 */

#include "nao.h"
#include <bb/data/JsonDataAccess>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QWaitCondition>

using namespace bb::data;
using namespace bb::cascades;

const QString hs_pre = "http://web.juhe.cn:8080/finance/stock/hs";

static QString assetPath(const QString& assetName)
{
    return QDir::currentPath() + "/app/native/assets/" + assetName;
}

Nao::Nao(QObject* parent): QObject(parent), m_model(new GroupDataModel(this)), m_keyItemList(new GroupDataModel(this))
{
    QString assetpath = assetPath("stocks.json");
    mAccessManager = new QNetworkAccessManager(this);
    //qDebug() << "assetpath:" << assetpath ;
    QVariantMap home_stock;
    QFile jsonFile(assetpath);
    loadJsonData(jsonFile);
}


void Nao::loadJsonData(QFile& jsonFile)
{
    if (!jsonFile.open(QFile::ReadOnly)) {
        const QString msg = tr("Failed to open JSON file: %1").arg(jsonFile.fileName());
        qDebug() << "msg:" << msg ;
        setJsonData (QString());
        return;
    }
    const QString doc = QString::fromUtf8(jsonFile.readAll());
    //qDebug() << "loadJsonData:" << doc ;
    setJsonData(doc);
}

void Nao::setJsonData(const QString& data)
{
    //qDebug() << "setJsonData:" << data ;
    if (mJsonData == data)
        return;
    mJsonData = data;
    //qDebug() << "mJsonData:" << mJsonData ;
}


void Nao::getRateOfSpecifiy(const QString& code)
{

    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    QString path = hs_pre + "?gid=" + code + "&type=&key=";
    reply = mAccessManager->get(QNetworkRequest(QUrl(path)));
    bool connectResult = connect(reply, SIGNAL(finished()), this, SLOT(onHomeGetReply()));
    Q_ASSERT(connectResult);
}


void Nao::getKeyItems(){

    getRateOfSpecifiy("sh000001");
    getRateOfSpecifiy("sz399001");
    getRateOfSpecifiy("sz399006");

}


QString Nao::getdata()
{
    JsonDataAccess jda;
    QVariant qtData = jda.loadFromBuffer(mJsonData);
    QVariantMap qtmap = qtData.toList()[0].toMap();
    QVariantList stocklist = qtmap["bookmark"].toMap()["HS"].toList();

    foreach(QVariant stock, stocklist){
        // The network parameters; used for accessing a file from the Internet
        QNetworkReply *mReply;
        QString stockStr = stock.toString();
        QString path = hs_pre + "?gid=" + stockStr + "&type=&key=";
        qDebug() << "Loading path:" << path ;
        // Connect to the reply finished signal to httpFinsihed() Slot function.
        mReply = mAccessManager->get(QNetworkRequest(QUrl(path)));
        bool connectResult = connect(mReply, SIGNAL(finished()), this, SLOT(onGetReply()));
        connect(mReply, SIGNAL(error(QNetworkReply::NetworkError)), this,
                SLOT(onErrorOcurred(QNetworkReply::NetworkError)));
        Q_ASSERT(connectResult);
    }
    return m_t;
}

void Nao::onHomeGetReply()
{
    qDebug() << "onHomeGetReply";
    QNetworkReply* mReply = qobject_cast<QNetworkReply*>(sender());
    QByteArray buffer(mReply->readAll());
//    QString buff = (QString) mReply->readAll();
    qDebug() << QString::fromUtf8(buffer);
    emit returned(true, QString::fromUtf8(buffer));
    disconnect(mReply);
    mReply->deleteLater();
}

void Nao::onErrorOcurred(QNetworkReply::NetworkError error)
{
    qDebug() << error;
    emit returned(false, QString(error));
}

void Nao::onGetReply()
{
    QNetworkReply* mReply = qobject_cast<QNetworkReply*>(sender());

    JsonDataAccess jda;
    QVariant fundDataFromServer;
    int httpStatus = -1; // controls the final behavior of this function

    if (mReply->error() == QNetworkReply::NoError) {
        // Load the data using the reply QIODevice.
        QByteArray buff = mReply->readAll();
        fundDataFromServer = jda.loadFromBuffer(buff);

        if (jda.hasError()) {
            bb::data::DataAccessError error = jda.error();
            qDebug() << "JSON loading error:" << error.errorType() << " : " << error.errorMessage();
            httpStatus = -2;
        } else {
            httpStatus = 200;
        }
    } else {
        // An error occurred, try to get the http status code and reason
        QVariant statusCode = mReply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
        QString reason = mReply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();

        if (statusCode.isValid()) {
            httpStatus = statusCode.toInt();
        }

        qDebug() << "Network request to " << mReply->request().url().toString()
                << " failed with http status " << httpStatus << " " << reason;
    }
    Q_ASSERT(httpStatus);
    // Now behave
    switch (httpStatus) {
        case 200: {
            // We modify our data to get closer to what a server might actually deliver.
            QVariantMap entry;
            QVariantMap map = fundDataFromServer.toMap();

            QVariantMap result = map["result"].toList()[0].toMap();
            //qDebug() << "Loading result:" << result;

            QVariantMap data = result["data"].toMap();
            QString nowPri = data["nowPri"].toString();
            QString yestodEndPri = data["yestodEndPri"].toString();

            QVariantMap dapandata = result["dapandata"].toMap();
            QString name = dapandata["name"].toString();
            QString nowPic = dapandata["nowPic"].toString();
            QString dot = dapandata["dot"].toString();
            QString rate = dapandata["rate"].toString();

            QVariantMap goPictures = result["gopicture"].toMap();
            QString minurl = goPictures["minurl"].toString();
            QString dayurl = goPictures["dayurl"].toString();
            QString weekurl = goPictures["weekurl"].toString();
            QString monthurl = goPictures["monthurl"].toString();

            entry["name"] = name;
            entry["nowPic"] = nowPic;
            entry["dot"] = dot;
            entry["rate"] = rate;

            entry["minurl"] = minurl;
            entry["dayurl"] = dayurl;
            entry["weekurl"] = weekurl;
            entry["monthurl"] = monthurl;

            entry["nowPri"] = nowPri;
            entry["yestodEndPri"] = yestodEndPri;

            m_model->insert(entry);
        }
            break;
        case 404:
            break;
        case 503:
            break;
        case -2:
            break;
        case 500:
        default:
            // The server crapped out, if we don't have any entries let the user know an error occurred, otherwise just stop fetching
            break;
    }

    // The reply is not needed now so we call deleteLater() function since we are in a slot.
    disconnect(mReply);
    mReply->deleteLater();
}


bb::cascades::GroupDataModel* Nao::model() const
{
    return m_model;
}


bb::cascades::GroupDataModel* Nao::keyItemList() const
{
    return m_keyItemList;
}



