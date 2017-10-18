//
//  WishAddController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/28.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishAddController: MyBaseUIViewController, UIPickerViewDataSource , UIPickerViewDelegate {
    
    var titleBarText = "心愿申请";
    
    let pickerView = UIPickerView()
    var pickerViewData = [String]()
    var dataSource = JSON.init("")
    var submitParameter = ["":""]
    
    @IBOutlet weak var txt_wishType: UITextField!
    
    @IBOutlet weak var txt_dept: UITextField!
    
    @IBOutlet weak var txtView_wishContent: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: titleBarText)
        
        txt_wishType.delegate = self
        txt_dept.delegate = self
        
        txt_wishType.inputView = pickerView
        txt_dept.inputView = pickerView
        
        txt_wishType.restorationIdentifier = "wishType"
        txt_dept.restorationIdentifier = "dept"
        
//        txt_wishType.isUserInteractionEnabled = false
//        txt_dept.isUserInteractionEnabled = false
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        getDatasource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //文本框输入之前
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     
        if textField.restorationIdentifier == "dept"{
            //处理职能部门
            let list = dataSource["managerole"].arrayValue
            pickerViewData = [String]()
            for item in list {
                pickerViewData.append(item["name"].stringValue)
            }
            pickerView.tag = 0
            pickerView.reloadAllComponents()
            return true
        }else if textField.restorationIdentifier == "wishType"{
            //处理心愿类型
            let list = dataSource["wishlisttype"].arrayValue
            pickerViewData = [String]()
            for item in list {
                pickerViewData.append(item["typename"].stringValue)
            }
            pickerView.tag = 1
            pickerView.reloadAllComponents()
            return true
        }
        return false
        
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交按钮
    @IBAction func btn_submit_inside(_ sender: UIButton) {
        
        if txt_dept.text == ""{
            myAlert(self, message: "请选择职能部门!")
            return
        }
        
        if txt_wishType.text == ""{
            myAlert(self, message: "请选择心愿类型!")
            return
        }
        
        submitParameter["wishcontent"] = txtView_wishContent.text
        //print(submitParameter)
        
        
        let url = SERVER_PORT+"rest/wishList/add.do"
        myPostRequest(url,submitParameter).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "心愿单申请成功!请等待审核!" , handler:{action in
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    myAlert(self, message: "心愿单申请异常!请联系管理员!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerViewData[row]
    }
    
    //选择后
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0{
            //职能部门
            submitParameter["manageroleid"] = dataSource["managerole"][row]["id"].stringValue
            txt_dept.text = pickerViewData[row]
        }else if pickerView.tag == 1{
            //心愿类型
            submitParameter["typeid"] = dataSource["wishlisttype"][row]["id"].stringValue
            txt_wishType.text = pickerViewData[row]
        }
        
    }
    
    //获取申请类型和职能部门
    func getDatasource(){
        
        activityIndicatorStartAnimating()
        
        let url = SERVER_PORT+"rest/wishList/queryType.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            
            self.activityIndicatorStopAnimating()
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.dataSource = json
                }else{
                    myAlert(self, message: "请求评价详情失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
}
