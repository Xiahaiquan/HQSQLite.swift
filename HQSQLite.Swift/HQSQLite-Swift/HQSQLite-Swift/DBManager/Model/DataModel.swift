//
//  DataModel.swift
//  HQSQLite-Swift
//
//  Created by HaiQuan on 2018/8/21.
//  Copyright © 2018年 HaiQuan. All rights reserved.
//

import Foundation
import UIKit
import SQLite

/// user Info
struct UserInfoModel {

    var userID: Int = 0
    var name: String = ""
    var icon: UIImage = UIImage.init(named: "UserPerformance")!

    init() {}
    
    init(userID: Int, name: String, icon: UIImage) {
        self.userID = userID
        self.name = name
        self.icon = icon

    }
}

// User Icon store
extension NSData: Value {

    // SQL Type
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    // Decode
    public class func fromDatatypeValue(_ datatypeValue: Blob) -> NSData {
        return NSData(bytes: datatypeValue.bytes, length: datatypeValue.bytes.count)
    }
    // Encode
    public var datatypeValue: Blob {
        return Blob(bytes: self.bytes, length: self.length)
    }
}

extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
        return UIImage(data: Data.fromDatatypeValue(blobValue))!
    }
    public var datatypeValue: Blob {
        return UIImagePNGRepresentation(self)!.datatypeValue
    }

}
