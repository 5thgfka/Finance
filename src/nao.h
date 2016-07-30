/*
 * nao.h
 *
 *  Created on: 2016.1.3
 *      Author: ekse
 */

#ifndef NAO_H_
#define NAO_H_


#include <QtCore/QObject>
#include <bb/data/JsonDataAccess>
#include <bb/cascades/GroupDataModel>
#include <bb/cascades/QListDataModel>

#include <QtNetwork/QNetworkReply>

class Nao: public QObject
{
    Q_OBJECT
    // The model that provides the filtered list of contacts
    Q_PROPERTY(bb::cascades::GroupDataModel *model READ model CONSTANT);
    Q_PROPERTY(bb::cascades::GroupDataModel *keyItemList READ keyItemList CONSTANT);
public:
    Nao(QObject* parent=0);
    void setJsonData(const QString& data);
    void loadJsonData(QFile& jsonFile);
    void getRateOfSpecifiy(const QString& code);

    Q_SIGNAL void returned(bool success,QString resp);

public Q_SLOTS:
    QString getdata();
    void getKeyItems();

private slots:
    /**
     * This Slot function is called when the network request to the
     * "weather service" is complete.
     */
    void onGetReply();
    void onHomeGetReply();
    void onErrorOcurred(QNetworkReply::NetworkError error);

private:
    QString m_t;
    QString mJsonData;
    QString mShData;
    QString mSzData;
    QString mCyData;

    QNetworkAccessManager *mAccessManager;
    // The accessor methods of the properties
    bb::cascades::GroupDataModel* model() const;
    bb::cascades::GroupDataModel* keyItemList() const;
    // The property values
    bb::cascades::GroupDataModel* m_model;
    bb::cascades::GroupDataModel* m_keyItemList;
};


#endif /* NAO_H_ */
