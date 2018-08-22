//
//  UserinfoDataHelper.swift
//  HQSQLite-Swift
//
//  Created by HaiQuan on 2018/8/21.
//  Copyright © 2018年 HaiQuan. All rights reserved.
//

import Foundation
import SQLite

class UserinfoDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "t_userinfo"
    
    static let userID = Expression<Int>("userID")
    static let name = Expression<String>("name")
    static let icon = Expression<UIImage>("icon")

    
    static let table = Table(TABLE_NAME)
    
    typealias T = UserInfoModel
    
    static func createTable() throws {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        do {
            _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(userID)
                t.column(name)
                t.column(icon)
            })
        } catch _ {
            throw DataAccessError.datastoreConnectionError
        }
    }
    
    static func insert(item: T) throws -> Int {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        
        let insert = table.insert(userID <- item.userID, name <- item.name, icon <- item.icon)
        do {
            let rowId = try DB.run(insert)
            guard rowId >= 0 else {
                throw DataAccessError.insertError
            }
            return Int(rowId)
        } catch _ {
            throw DataAccessError.insertError
        }
    }
    
    static func update(item: T) throws -> Bool {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }

        let query = table.filter(item.userID == userID)

        if try DB.run(query.update(userID <- item.userID, name <- item.name, icon <- item.icon)) > 0 {
            return true
        } else {
            return false
        }

    }

    static func checkColumnExists(queryUserID: Int) throws -> Bool {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }


        let query = table.filter(queryUserID == userID).exists

        let isExists = try DB.scalar(query)
        return  isExists

    }

    static func delete (item: T) throws -> Void {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        let id = item.userID
        let query = table.filter(userID == id)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.deleteError
            }
        } catch _ {
            throw DataAccessError.deleteError
        }
    }
    
    
    static func find(queryUserID: Int) throws -> [T] {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        let query = table.filter(queryUserID == userID)
        let items = try DB.prepare(query)
        var retArray = [T]()
        for item in  items {
            
            retArray.append(UserInfoModel(userID: item[userID], name: item[name],icon: item[icon]))
        }
        
        return retArray
        
    }
    
    static func findAll() throws -> [T]? {

        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.datastoreConnectionError
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(UserInfoModel(userID: item[userID], name: item[name],icon: item[icon]))
        }
        
        return retArray
    }
    
    
}
