//
//  DifficultAddController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import BMPlayer
import NVActivityIndicatorView

class DifficultAddController: MyBaseUIViewController , UITextViewDelegate {
    
    @IBOutlet weak var txt_title: UITextField!
    
    @IBOutlet weak var txt_content: UITextView!
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "疑难发布")
        
        txt_title.placeholder = "请将标题控制在40字内!"
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交
    @IBAction func btn_submit_inside(_ sender: UIButton) {
        let title = txt_title.text!
        let content = txt_content.text!
        
        if title == ""{
            myAlert(self, message: "请填写标题!")
            return
        }else if title.length > 40 {
            myAlert(self, message: "标题不能超过40个字!")
            return
        }
        
        if content == ""{
            myAlert(self, message: "发布内容不能为空!")
            return
        }
        
        let url = SERVER_PORT+"rest/difficult/add.do"
        myPostRequest(url,["title":title,"content":content]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "发布成功!" , handler : {
                        action in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }else{
                    myAlert(self, message: json["msg"].stringValue)
                }
                
                
            case .failure(let error):
                print(error)
            }
            
        })

    }
    

    
}
