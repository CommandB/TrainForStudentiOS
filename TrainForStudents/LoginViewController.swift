//
//  LoginController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/6.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LoginViewController : MyBaseUIViewController, UIPickerViewDataSource , UIPickerViewDelegate{
    
    @IBOutlet weak var txt_loginId: UITextField!
    
    @IBOutlet weak var txt_password: UITextField!
    
    @IBOutlet weak var txt_hospital: TextFieldForNoMenu!
    
    let myPickerView = UIPickerView()
    
    var pickerDataSource = [JSON]()
    
    let pickerViewFirstStr = "请选择"
    
    @IBAction func btn_login_inside(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
        login()
    }
    
    @IBAction func btn_hospital_inside(_ sender: UITextField) {
        
    }
    
    @IBAction func btn_forgotPassword_inside(_ sender: UIButton) {
        myAlert(self, message: "请联系科教处!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPickerView.dataSource = self
        myPickerView.delegate = self
        
        
        txt_loginId.returnKeyType = .next
        txt_loginId.delegate = self
        txt_password.delegate = self
        txt_hospital.delegate = self
        txt_hospital.inputView = myPickerView
        txt_hospital.restorationIdentifier = "hospital"
        txt_hospital.tintColor = UIColor.clear
        txt_hospital.layer.borderColor = UIColor.clear.cgColor
        txt_hospital.layer.borderWidth = 1

//        txt_hospital.editingRect(forBounds: CGRect(x: 0, y: 100, width: 100, height: 100))
        
//        txt_loginId.text = "439"
//        txt_password.text = "123456"
        
        
        loadHospital()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loginId = UserDefaults.standard.string(forKey: LoginInfo.loginId.rawValue)
        let hospital = UserDefaults.standard.string(forKey: LoginInfo.hospital.rawValue)
        
        if loginId != nil {
            txt_loginId.text = loginId
        }
        
        if hospital != nil {
            txt_hospital.text = hospital
        }
        
    }
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if "loginId" == textField.restorationIdentifier{
            txt_password.becomeFirstResponder()
        }else if "password" == textField.restorationIdentifier{
            login()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if "hospital" == textField.restorationIdentifier{
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        return true
    }
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let json = pickerDataSource[row]
        
        return json["name"].stringValue
    }
    
    //picker 选中
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row > 0 {
            let data = pickerDataSource[row]
            txt_hospital.text = data["name"].stringValue
            
            let server_port = "http://\(data["url"].stringValue )/doctor_train/"
            let portal_port = "http://\(data["portalurl"].stringValue)/doctor_portal/"
            
            //存app本地
            UserDefaults.standard.set(server_port, forKey: LoginInfo.server_port.rawValue)
            UserDefaults.standard.set(portal_port, forKey: LoginInfo.portal_port.rawValue)
            UserDefaults.standard.set(txt_loginId.text!, forKey: LoginInfo.loginId.rawValue)
            UserDefaults.standard.set(txt_password.text!, forKey: LoginInfo.password.rawValue)
            UserDefaults.standard.set(txt_hospital.text!, forKey: LoginInfo.hospital.rawValue)
            
            SERVER_PORT = server_port
            PORTAL_PORT = portal_port
            
        }
        
    }
    
    
    
    //下载基地列表
    func loadHospital(){
        
        let url = CLOUD_SERVER + "rest/trainHospital/query.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.pickerDataSource.append(JSON(["name":self.pickerViewFirstStr]))
                    self.pickerDataSource += json["data"].arrayValue
                }else{
                    myAlert(self, message: json["msg"].stringValue)
                }
                self.myPickerView.reloadAllComponents()
            case .failure(let error):
                
                print(error)
            }
            
            
            
        })
    }
    
    
    //登录
    func login(){
        if txt_loginId.text?.length == 0{
            myAlert(self, message: "请输入用户名!")
            return
        }else if txt_password.text?.length == 0 {
            myAlert(self, message: "请输入密码!")
            return
        }else if txt_hospital.text?.length == 0 {
            myAlert(self, message: "请选择基地")
            return
        }
        
        let url = PORTAL_PORT + "rest/loginCheck.do"
//        let url = "http://192.168.1.106:8081/doctor_portal/rest/loginCheck.do"
        myPostRequest(url,["loginid":txt_loginId.text , "password":txt_password.text?.sha1()]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    let token = json["token"].stringValue
                    r_token = token
                    UserDefaults.standard.set(token, forKey: LoginInfo.token.rawValue)
                    UserDefaults.standard.set(self.txt_loginId.text!, forKey: LoginInfo.loginId.rawValue)
                    //注册极光推送别名
                    JPUSHService.setAlias(json["userkey"].stringValue, completion: nil, seq: 0)
                    print("极光推送注册的别名:\(json["userkey"].stringValue)")
                    myPresentView(self, viewName: "tabBarView")
                }else{
                    myAlert(self, message: json["msg"].stringValue)
                }
                
            case .failure(let error):
                myAlert(self, message: "服务器异常!")
                print(error)
            }
            
        })
        
    }
    
}
