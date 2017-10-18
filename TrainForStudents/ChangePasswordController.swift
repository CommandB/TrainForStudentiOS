//
//  ChangePasswordController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//


import UIKit
import SwiftyJSON

class ChangePasswordController: MyBaseUIViewController   {
    
    var oldpwd = ""
    
    //返回
    @IBAction func btn_back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交
    @IBAction func btn_submit(_ sender: UIButton) {
        
        let url = PORTAL_PORT + "rest/login/modify_mine.do"
        var param=["":""]
        
        let txt_pwd1 = self.view.viewWithTag(10002) as! UITextField
        let txt_pwd2 = self.view.viewWithTag(10003) as! UITextField
        
        if (txt_pwd1.text?.isEmpty)! {
            myAlert(self, message: "请输入新密码!")
        }
        
        if (txt_pwd2.text?.isEmpty)! {
            myAlert(self, message: "请再次输入新密码!")
        }
        
        if txt_pwd1.text != txt_pwd2.text{
            myAlert(self, message: "两次输入的新密码不一致!")
            return
        }
        
        param["password"] = txt_pwd1.text?.sha1()
        
        myPostRequest(url,param).responseJSON(completionHandler: { resp in
            
            switch  resp.result{
            case .success(let result):
                
                let resultJson = JSON(result)
                switch  resultJson["code"].stringValue{
                case "1":
                    myAlert(self, message: "密码修改成功!", handler: {action in
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
        
        var textField = self.view.viewWithTag(10002) as! UITextField
        textField.clearButtonMode = .always
        textField.isSecureTextEntry=true
        
        
        textField = self.view.viewWithTag(10003) as! UITextField
        textField.clearButtonMode = .always
        textField.isSecureTextEntry=true
        
//        let url = SERVER_PORT + "rest/queryUserInfo.do"
//        myPostRequest(url).responseJSON(completionHandler: { resp in
//            
//            switch  resp.result{
//            case .success(let result):
//                
//                let resultJson = JSON(result)
//                switch  resultJson["code"].stringValue{
//                case "1":
//                    self.oldpwd=resultJson["data"][0]["password"].stringValue
//                default:
//                    myAlert(self, message: resultJson["msg"].stringValue)
//                }
//                
//            case .failure(let err):
//                
//                myAlert(self, message: "服务器异常!")
//                print(err)
//            }
//            
//        })
        
        
        
    }
    
}
