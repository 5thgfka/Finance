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
#include <bb/data/SqlDataAccess>
#include <bb/data/DataAccessError>
#include <QtSql/QtSql>

using namespace bb::data;
using namespace bb::cascades;

const QString hs_pre = "http://web.juhe.cn:8080/finance/stock/hs";
const QString DB_PATH = "./data/bbFinance.db";
SqlDataAccess *sqlda = new SqlDataAccess(DB_PATH);

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

bool Nao::initDatabase(){
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName(DB_PATH);

    const QString createSQL_bookmark = "CREATE TABLE IF NOT EXISTS bookmark "
                              "  (id INTEGER PRIMARY KEY AUTOINCREMENT, "
                              "  type VARCHAR, "
                              "  gid VARCHAR);";
    sqlda->execute(createSQL_bookmark);
    if(!sqlda->hasError()) {
        qDebug() << "Table created.";
    } else {
        const DataAccessError error = sqlda->error();
        qDebug() << error.errorMessage();
        return false;
    }
    const QString createSQL_home = "CREATE TABLE IF NOT EXISTS home "
                                      "  (id INTEGER PRIMARY KEY AUTOINCREMENT, "
                                      "  name VARCHAR, "
                                      "  gid VARCHAR);";
    sqlda->execute(createSQL_home);
    if(!sqlda->hasError()) {
        qDebug() << "Table created.";
    } else {
        const DataAccessError error = sqlda->error();
        qDebug() << error.errorMessage();
        return false;
    }

    return true;
}

bool Nao::initTableData() {
    // bookmark
    const QString sqlQuery_bookmark = "SELECT gid FROM bookmark";
    QVariant result = sqlda->execute(sqlQuery_bookmark);
    QVariantList list = result.value<QVariantList>();
    int recordsRead = 0;
    recordsRead = list.size();
    if(recordsRead == 0){
        sqlda->execute("INSERT INTO bookmark (type, gid) VALUES ('HS', 'sz002310')");
        sqlda->execute("INSERT INTO bookmark (type, gid) VALUES ('HS', 'sh601111')");
        sqlda->execute("INSERT INTO bookmark (type, gid) VALUES ('HS', 'sh601985')");
    }
    // home
    const QString sqlQuery_home = "SELECT gid FROM bookmark";
    result = sqlda->execute(sqlQuery_home);
    list = result.value<QVariantList>();
    recordsRead = list.size();
    if(recordsRead == 0){
        sqlda->execute("INSERT INTO home (name, gid) VALUES ('sh', 'sh000001')");
        sqlda->execute("INSERT INTO home (name, gid) VALUES ('sz', 'sz399001')");
        sqlda->execute("INSERT INTO home (name, gid) VALUES ('cy', 'sz399006')");
    }

    return true;
}

bool Nao::insertRecord(const QString &table, const QString &key, const QString &type){
    sqlda->execute("INSERT INTO " + table + " (type, gid) VALUES ('" + type + "', '"+key+"')");
    return true;
}

bool Nao::deleteRecord(const QString &table, const QString &key){
    sqlda->execute("DELETE FROM " + table + " WHERE gid='" + key + "'");
    return true;
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
    jsonFile.close();
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
    const QString sqlQuery = "SELECT gid FROM home";
    QVariant result = sqlda->execute(sqlQuery);
    QVariantList list = result.value<QVariantList>();
    int recordsRead = 0;
    recordsRead = list.size();
    for(int i = 0; i < recordsRead; i++) {
        QVariantMap map = list.at(i).value<QVariantMap>();
        QString gid = map["gid"].toString();
        getRateOfSpecifiy(gid);
    }
//    getRateOfSpecifiy("sh000001");
//    getRateOfSpecifiy("sz399001");
//    getRateOfSpecifiy("sz399006");

}


void Nao::getdata()
{
//    JsonDataAccess jda;
//    QVariant qtData = jda.loadFromBuffer(mJsonData);
//    QVariantMap qtmap = qtData.toList()[0].toMap();
//    QVariantList stocklist = qtmap["bookmark"].toMap()["HS"].toList();
    const QString sqlQuery = "SELECT gid FROM bookmark";
    QVariant result = sqlda->execute(sqlQuery);
    QVariantList list = result.value<QVariantList>();
    int recordsRead = 0;
    recordsRead = list.size();

    for(int i = 0; i < recordsRead; i++) {
        QVariantMap map = list.at(i).value<QVariantMap>();
        QString stockStr = map["gid"].toString();
        // The network parameters; used for accessing a file from the Internet
        QNetworkReply *mReply;
//        QString stockStr = stock.toString();
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

void Nao::starStock(QString gid, QString place, bool status){
    qDebug() << "starStock 0";
    JsonDataAccess jda;
    QVariant qtData = jda.loadFromBuffer(mJsonData);
    qDebug() << qtData;
    QVariantMap qtmap = qtData.toList()[0].toMap();
    qDebug() << mJsonData;
    qDebug() << "starStock 1";
    if(status == false){
        qDebug() << "starStock 2";
        qDebug() << place;
        qDebug() << gid;
        qtData.toList()[0].toMap()["bookmark"].toMap()[place].toList().removeOne(gid);
    }
    else{
        qtData.toList()[0].toMap()["bookmark"].toMap()[place].toList().append(gid);
    }
    QString assetpath = assetPath("stocks.json");
    mAccessManager = new QNetworkAccessManager(this);
    qDebug() << qtData;
    QFile jsonFile(assetpath);
    JsonDataAccess jda_write(&jsonFile);
    jda_write.save(qtData, &jsonFile);
//    jsonFile.open(QIODevice::ReadWrite);
//    jsonFile.write(qtData.toByteArray());
//    qDebug() << qtData.toByteArray();
    jsonFile.close();
}

bb::cascades::GroupDataModel* Nao::model() const
{
    return m_model;
}

bb::cascades::GroupDataModel* Nao::keyItemList() const
{
    return m_keyItemList;
}



