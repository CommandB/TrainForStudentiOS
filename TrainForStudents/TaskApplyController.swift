//
//  TaskApplyController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/17.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskApplyController: MyBaseUIViewController , UIPickerViewDataSource , UIPickerViewDelegate{
    
    @IBOutlet weak var txt_type: UITextField!
    
    @IBOutlet weak var txt_code: UITextField!
    
    @IBOutlet weak var txt_completeDate: UITextField!
    
    @IBOutlet weak var txt_content: UITextView!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    let imageCollectionView = TaskApplyImageCollectionView()
    
    var datePicker = UIDatePicker()
    
    var pickerView = UIPickerView()
    
    var pickerDataSource = [JSON]()
    
    let pickerViewFirstStr = "请选择"
    var typeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务申报")
        
        pickerView.dataSource = self
        pickerView.delegate = self
        txt_type.restorationIdentifier = "type"
        txt_type.inputView = pickerView
        txt_type.layer.cornerRadius = 4
        txt_type.tintColor = UIColor.clear
        txt_type.delegate = self
        txt_code.layer.cornerRadius = 4
        txt_completeDate.layer.cornerRadius = 4
        txt_completeDate.tintColor = UIColor.clear
        txt_completeDate.restorationIdentifier = "completeDate"
        txt_completeDate.delegate = self
        txt_content.layer.cornerRadius = 4
        
        
        imageCollectionView.parentView = self
        imageCollection.delegate = imageCollectionView
        imageCollection.dataSource = imageCollectionView
        
        //设置 日期控件
        txt_completeDate.inputView = datePicker
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChange), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getTypeList()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交按钮
    @IBAction func btn_submit_inside(_ sender: UIButton) {
        
        let type = txt_type.text
        let code = txt_code.text
        let content = txt_content.text
        let completeDate = txt_completeDate.text
        
        if type == nil || (type?.isEmpty)!{
            myAlert(self, message: "请选择培训类型!")
            return
        }
        
        if code == nil || (code?.isEmpty)!{
            myAlert(self, message: "请填写病例编码!")
            return
        }
        
        if completeDate == nil || (completeDate?.isEmpty)!{
            myAlert(self, message: "请选择完成时间!")
            return
        }
        
        if content == nil || (content?.isEmpty)!{
            myAlert(self, message: "请填写申请内容!")
            return
        }
        
        var param = [String:Any]()
        param["typename"] = type
        param["traincontent"] = content
        param["caseid"] = typeId
        param["finshtime"] = completeDate
        
        
        let url = SERVER_PORT + "rest/taskApply/add.do"
        
        var imgDir = [String:UIImage]()
        
        for img in imageCollectionView.images{
            imgDir[arc4random().description] = img
        }
        //禁用按钮 防止重复提交
        sender.isEnabled = false
        uploadImage(url, images: imgDir, parameters: param, completionHandler: {resp in
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "提交申请成功!" , handler : { action in
                        let root = self.presentingViewController
                        root?.dismiss(animated: true, completion: nil)
                        myPresentView(root!, viewName: "taskApplyListView")
                    })
                    
                }else{
                    myAlert(self, message: "提交申请失败!\(json["msg"].stringValue)")
                }
                
            case .failure(let error):
                print(error)
            }
            sender.isEnabled = true
        })
        
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
            txt_type.text = data["name"].stringValue
            typeId = data["id"].stringValue
        }
        
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        if "completeDate" == textField.restorationIdentifier{
            txt_completeDate.text = DateUtil.dateToString(datePicker.date)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if "type" == textField.restorationIdentifier{
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        return true
    }
    
    func datePickerChange(picker :UIDatePicker){
        
        txt_completeDate.text = DateUtil.dateToString(picker.date)
        
    }
    
    //获取培训类型
    func getTypeList(){
        
        let url = SERVER_PORT+"rest/taskApply/queryType.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.pickerDataSource.append(JSON(["name":self.pickerViewFirstStr]))
                    self.pickerDataSource += json["data"].arrayValue
                }else{
                    myAlert(self, message: "请求类型列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    
    
}
