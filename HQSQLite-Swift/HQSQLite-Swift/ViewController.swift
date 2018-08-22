//
//  ViewController.swift
//  HQSQLite-Swift
//
//  Created by HaiQuan on 2018/8/21.
//  Copyright © 2018年 HaiQuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        creatDB()

        insterUserModel()

        checkUserModel()

        updateUserModel()
        
        getUserModel()

    }

}
//MARK: access DB
extension ViewController {

    func creatDB() {
        do {
            try  SQLiteDataStore.sharedInstance.createTables()
        } catch _ {
            print("creat DB Error")
        }
    }
    private func insterUserModel() {

        let userModel = UserInfoModel.init(userID: 100, name: "XiaoMing", icon:UIImage.init(named: "UserPerformance")!)
        do {
            let torId = try UserinfoDataHelper.insert(item: userModel )
            print(torId)
        } catch _ {
            print("inster userModel error")
        }
        
    }

    private func checkUserModel() {

        do {
            let exists = try UserinfoDataHelper.checkColumnExists(queryUserID: 100)
            print(exists)
        } catch _ {
            print("check userModel error")
        }
    }

    private func updateUserModel() {
        
        let userModel = UserInfoModel.init(userID: 100, name: "XiaoWang", icon:UIImage.init(named: "UserPerformance")!)
        do {
            let isSuccess = try UserinfoDataHelper.update(item: userModel)
            print(isSuccess)
        } catch _ {
            print("update userModel error")
        }
    }

    private func getUserModel() {

        do {
            let items = try UserinfoDataHelper.find(queryUserID: 100)
            if let item = items.first {
                print(item.userID, item.name, item.icon)
            }
        } catch _ {
            print("find UserinfoData error")

        }
    }

}
