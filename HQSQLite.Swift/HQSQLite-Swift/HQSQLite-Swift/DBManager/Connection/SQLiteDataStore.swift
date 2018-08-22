//
//  SQLiteDataStore.swift
//  HQSQLite-Swift
//
//  Created by HaiQuan on 2018/8/21.
//  Copyright © 2018年 HaiQuan. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: Swift.Error {
    case datastoreConnectionError
    case insertError
    case deleteError
    case searchError
    case nilInData
    case nomoreData
}

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        
        let dirs: [NSString] =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString]
        
        let dir = dirs[0]
        let path = dir.appendingPathComponent("HaiQuanDB.sqlite");
        print("The DB Path:",path)
        
        
        do {
            BBDB = try Connection(path)
            BBDB?.busyTimeout = 5
            
            BBDB?.busyHandler({ tries in
                if tries >= 3 {
                    return false
                }
                return true
            })
        } catch _ {
            BBDB = nil 
        }
    }
    
    func createTables() throws{
        do {
            try UserinfoDataHelper.createTable()
        } catch {
            throw DataAccessError.datastoreConnectionError
        }
        
    } 
}

