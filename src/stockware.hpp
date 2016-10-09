/*
 * stockware.hpp
 *
 *  Created on: 2016年10月9日
 *      Author: ekse
 */

#ifndef STOCKWARE_HPP_
#define STOCKWARE_HPP_


#include <QtCore/QObject>
#include <bb/data/JsonDataAccess>
#include <bb/cascades/GroupDataModel>
#include <bb/cascades/QListDataModel>


class Stockware: public QObject
{
public:
    Stockware(QObject* parent=0);
    // Database
    bool initDataWare();
};



#endif /* STOCKWARE_HPP_ */
