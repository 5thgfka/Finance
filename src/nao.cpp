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
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
            SLOT(onErrorOcurred(QNetworkReply::NetworkError)));
    Q_ASSERT(connectResult);
}


void Nao::getKeyItems(){

    getRateOfSpecifiy("sh000001");
    getRateOfSpecifiy("sz399001");
    getRateOfSpecifiy("sz399006");

}


void Nao::getdata()
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
        Q_ASSERT(connectResult);
    }
}

void Nao::onHomeGetReply()
{
    qDebug() << "onHomeGetReply";
    QNetworkReply* mReply = qobject_cast<QNetworkReply*>(sender());
    QByteArray buffer(mReply->readAll());
//    QString buff = (QString) mReply->readAll();
    qDebug() << QString::fromUtf8(buffer);
    emit keyReturned(true, QString::fromUtf8(buffer));
    disconnect(mReply);
    mReply->deleteLater();
}

void Nao::onErrorOcurred(QNetworkReply::NetworkError error)
{
    qDebug() << error;
    emit keyReturned(false, QString(error));
}

void Nao::onGetReply()
{
    qDebug() << "onGetReply";
    QNetworkReply* mReply = qobject_cast<QNetworkReply*>(sender());
    QByteArray buffer(mReply->readAll());
//    QString buff = (QString) mReply->readAll();
    qDebug() << QString::fromUtf8(buffer);
    emit starReturned(true, QString::fromUtf8(buffer));
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



