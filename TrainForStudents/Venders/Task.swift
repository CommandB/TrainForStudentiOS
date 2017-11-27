//
//  Task.swift
//  TestVersion
//
//  Created by 陈海峰 on 2017/9/25.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Task: NSObject {
    func checkUpdateForAppID(newVersionHandler: @escaping (_ thisVerion: String, _ newVersion: String) -> Void) {
        
        Alamofire.request("http://itunes.apple.com/cn/lookup?id=1279781724", method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: ["Content-type":"application/x-www-form-urlencoded"]).responseJSON {
            guard let value = $0.result.value,let json = Optional(JSON(value)),let version = json["results"].arrayValue.first?["version"].string,let versionInt = Int(version.replacingOccurrences(of: ".", with: "")),let thisVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String),
                let thisVersionInt = Int(thisVersion.replacingOccurrences(of: ".", with: ""))
                else {
                    NSLog("无法获取到App版本信息")
                    return
            }
            print(json)
            
            if versionInt > thisVersionInt {
                // 在下面的回调中可以做一些如弹窗等操作提示用户更新
                newVersionHandler(thisVersion, version)
            } else {
                NSLog("App已经是最新版本")
            }
        }
    }
}
