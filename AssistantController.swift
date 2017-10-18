//
//  AssistantController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/12.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class AssistantController: MyBaseUIViewController {
    
    @IBOutlet weak var assistantCollection: UICollectionView!
    
    @IBOutlet weak var imageUploadCollection: UICollectionView!
    
    @IBOutlet weak var btn_scanTab: UIButton!
    
    @IBOutlet weak var btn_imageUploadTab: UIButton!
    
    @IBOutlet weak var uploadImageView: UIView!
    
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    let assistantView = AssistantCollectionView()
    let imageUpload = ImageUploadCollectionView()
    var taskId = ""
    var timer = Timer.init()
    
    //签到二维码
    var QRCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "我是助理")
        
        buttonGroup = [btn_scanTab , btn_imageUploadTab]
        btn_scanTab.restorationIdentifier = "btn_scanTab"
        btn_scanTab.addTarget(self, action: #selector(btn_tab_inside), for: .touchUpInside)
        btn_imageUploadTab.addTarget(self, action: #selector(btn_tab_inside), for: .touchUpInside)
        
        //设置图片上传collection的初始位置
        imageUploadCollection.frame.origin = CGPoint(x: UIScreen.width, y: imageUploadCollection.frame.origin.y)
        
        assistantView.parentView = self
        assistantCollection.delegate = assistantView
        assistantCollection.dataSource = assistantView
        
        imageUpload.parentView = self
        imageUploadCollection.delegate = imageUpload
        imageUploadCollection.dataSource = imageUpload
        
        //隐藏资料上传 提交按钮的view
        uploadImageView.isHidden = true
        
        //定时刷新学员列表
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(getStudentsData), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        
        getImages()
        getQRCode()
        getStudentsData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    //资料上传 的图片提交
    @IBAction func btn_uploadImage_inside(_ sender: UIButton) {
        
        if imageUpload.images.count == 0 {
            myAlert(self, message: "请选择上传的图片!")
            return
        }
        
        let url = SERVER_PORT + "rest/task/taskResultImgAdd.do"
        let txt = uploadImageView.viewWithTag(10001) as! UITextView
        var param = [String:Any]()
        param["taskid"] = taskId
        param["context"] = txt.text
        
        var imgDir = [String:UIImage]()
        //根据记录的下标读取需要上传的图片
        for imgIndex in imageUpload.willUploadImagesIndex{
            imgDir[arc4random().description] = imageUpload.images[imgIndex]
        }
        
        uploadImage(url, images: imgDir, parameters: param, completionHandler: {resp in
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "资料上传成功!" , handler : { action in
                        
                    })
                    
                }else{
                    myAlert(self, message: "资料上传失败!\(json["msg"].stringValue)")
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    ///两个页签的touch事件
    func btn_tab_inside(sender :UIButton){
        
        tabsTouchAnimation(sender)
        
    }
    
    //获取我的信息
    func getStudentsData(){
        
        let url = SERVER_PORT+"rest/task/queryTaskAllStudent.do"
        myPostRequest(url,["taskid":taskId]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.assistantView.jsonDataSource = json["data"]
                    self.assistantCollection.reloadData()
                }else{
                    myAlert(self, message: "请求同学列表失败!")
                }
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    //请求签到二维码
    func getQRCode(){
        
        let url = SERVER_PORT + "rest/public/GenerateQRCode.do"
        myPostRequest(url,["taskid":taskId,"type":"apptask"]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.QRCode = json["qrcode"].stringValue
                    let imageView = self.view.viewWithTag(40001) as! UIImageView
                    imageView.image = UIImage.createQR(text: self.QRCode, size: 200)
                }else{
                    myAlert(self, message: "请求签到二维码失败!")
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    //请求资料的图片
    func getImages(){
        
        let url = SERVER_PORT + "rest/task/queryTaskResultUpload.do"
        myPostRequest(url,["taskid":taskId]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    for data in json["data"].arrayValue{
                        do{
                            for imgUrl in data["url"].arrayValue{
                                try self.imageUpload.images.append(UIImage(data: Data.init(contentsOf: URL(string: imgUrl.stringValue)!))!)
                            }
                           
                        }catch{
                            
                        }
                        
                    }
                    self.imageUploadCollection.reloadData()
//                    self.QRCode = json["qrcode"].stringValue
//                    let imageView = self.view.viewWithTag(40001) as! UIImageView
//                    imageView.image = UIImage.createQR(text: self.QRCode, size: 200)
                }else{
                    myAlert(self, message: "获取上传的资料图片失败!")
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    
    func tabsTouchAnimation(_ sender : UIButton){
        //-----------------计算 "下标线"label的动画参数
        
        for b in buttonGroup {
            if b == sender{
                b.setTitleColor(UIColor.black, for: .normal)
                b.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            }else{
                b.setTitleColor(UIColor.init(hex: "D6DADA"), for: .normal)
                b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            }
        }
        
        
        //动画开始
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        
        //滑动效果
        //        if sender.restorationIdentifier == "btn_over"{
        //            undoneCollection.frame = CGRect(origin: undoneCollection.frame.origin , size: CGSize(width: 0, height: undoneCollection.frame.size.height))
        //        }else{
        //            undoneCollection.frame = CGRect(origin: undoneCollection.frame.origin , size: CGSize(width: UIScreen.width, height: undoneCollection.frame.size.height))
        //        }
        //滚动效果
        if sender.restorationIdentifier == "btn_scanTab"{
            uploadImageView.isHidden = true
            imageUploadCollection.frame = CGRect(origin: CGPoint(x:UIScreen.width , y: imageUploadCollection.frame.origin.y) , size: imageUploadCollection.frame.size)
        }else{
            uploadImageView.isHidden = false
            imageUploadCollection.frame = CGRect(origin: CGPoint(x:10 , y: imageUploadCollection.frame.origin.y) , size: imageUploadCollection.frame.size)
            
        }
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    
}
