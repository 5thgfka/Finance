/*
 * stockware.cpp
 *
 *  Created on: 2016年10月9日
 *      Author: ekse
 */

#include "stockware.hpp"
#include <bb/data/SqlDataAccess>
#include <bb/data/DataAccessError>
#include <QtSql/QtSql>

using namespace bb::data;
using namespace bb::cascades;

const QString DB_PATH = "./data/bbFinance.db";

bool Stockware::initDataWare(){
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName(DB_PATH);
    return false;
}
