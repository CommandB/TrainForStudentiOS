//
//  ChangePersonInfoController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/23.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChangePersonInfoController: MyBaseUIViewController   {
    
    
    //返回
    @IBAction func btn_back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交
    @IBAction func btn_submit(_ sender: UIButton) {
        
        let url = SERVER_PORT + "rest/person/updateMyInfo.do"
        
        let jobnum = self.view.viewWithTag(10001) as! UITextField
        if jobnum.text == ""{
            myAlert(self, message: "请输入工号!")
            return
        }
        
        myPostRequest(url,["jobnum":jobnum.text]).responseJSON(completionHandler: { resp in
            
            switch  resp.result{
            case .success(let result):
                
                let resultJson = JSON(result)
                switch  resultJson["code"].stringValue{
                case "1":
                    myAlert(self, message: "修改成功!", handler: {action in
                        var root = self.presentingViewController
                        while let parent = root?.presentingViewController{
                            root = parent
                        }
                        root?.dismiss(animated: true, completion: nil)
                    })
                default:
                    myAlert(self, message: resultJson["msg"].stringValue)
                }
                
            case .failure(let err):
                
                myAlert(self, message: "服务器异常!")
                print(err)
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField = self.view.viewWithTag(10001) as! UITextField
        textField.clearButtonMode = .always
        
        
    }
    
}
