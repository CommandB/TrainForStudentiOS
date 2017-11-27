//
//  extension.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/8.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//


import Foundation
import Alamofire
import UIKit
import SwiftyJSON


let CLOUD_SERVER = "http://120.77.181.22:8080/cloud_doctor_train/"
var SERVER_PORT = "http://192.168.1.108:8070/doctor_train/"
var PORTAL_PORT = "http://120.77.181.22:8080/doctor_portal/"
//let PORTAL_URL = "http://192.168.1.106:8080/doctor_portal/"

//var rootViewController
var selectedTabBarIndex = 0

///request请求后台必须要带下列参数
var r_param = [String:Any]()
var r_token = "";
///图片下载默认id
let congou_image_id = "congou_image_id"

//post方式提交数据
func myPostRequest(_ url:String, _ parameters: [String: Any]? = nil , method: HTTPMethod = HTTPMethod.post) -> DataRequest {
    
    var requestParam = [String:Any]()
    let paramData = NSMutableDictionary(dictionary:["token":r_token])
    
    //合并默认参数和用户请求的参数
    if parameters != nil{
        paramData.addEntries(from: parameters!)
    }

    //把请求参数转成JSON
    let jsonData = JSON(paramData)
    
    //把json放入request请求的参数
    requestParam["data"] = jsonData.description
    //添加必要参数
    requestParam["myshop_forapp_key"] = 987654321
    
//    print("url:\(url)\nparam:\(JSON.init(requestParam))")
    
    return Alamofire.request(url, method: method, parameters: requestParam, encoding: URLEncoding.default, headers: ["Content-type":"application/x-www-form-urlencoded"])
}

///图片上传
func uploadImage(_ url: String , images:[String : UIImage]? , parameters:[String : Any]? , completionHandler : @escaping (DataResponse<Any>) -> Void ){
    
    //用于验证的参数必须放在url里
    let urlParam = "myshop_forapp_key=987654321&token="+r_token;
    var postUrl = url
    if url.hasSuffix(".do") || url.hasSuffix(".action") {
        postUrl += "?" + urlParam
    }else {
        postUrl += "&" + urlParam
    }
    
    
    if parameters != nil {
        let jsonData = JSON(parameters!)
        r_param["data"] = jsonData.description
    }
    
    upload(multipartFormData: { multipartFormData in
        
        if images != nil && (images?.count)!>0 {
            for (k , v ) in images!{
                let data = UIImagePNGRepresentation(v)
                let imageName = k + ".png"
                multipartFormData.append(data!, withName: "file", fileName: imageName, mimeType: "image/png")
                
            }
        }
        
        for (k , v) in r_param{
            multipartFormData.append((v as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: k)
//            multipartFormData.append(v.data(using: String.Encoding.utf8)!, withName: k)
        }
        
    },to:postUrl, encodingCompletion: { encodingResult in
        
        
        switch encodingResult {
        case .success(let upload, _, _):
            
            upload.responseJSON(completionHandler: completionHandler)
            
            
        case .failure(let encodingError):
            print(encodingError)
        }
        
    })
    
}

///系统消息提示
func myAlert(_ viewController:UIViewController, title:String = "系统提示", message:String, btnTitle:String = "好的", handler:((UIAlertAction) -> Void)? = nil){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: handler))
    viewController.present(alert, animated: true, completion: nil)
    
}

//我要报名
func signUpAlertPresent(_ viewController:UIViewController, title:String?, message:String?, btnTitle:String?, handler:((UIAlertAction) -> Void)? = nil){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: handler))
    viewController.present(alert, animated: true, completion: nil)
    
}

///confirm
func myConfirm(_ viewController:UIViewController, title:String = "系统提示", message:String, okTitle:String = "好的", cancelTitle:String = "取消" , okHandler:((UIAlertAction) -> Void)? = nil , cancelHandler:((UIAlertAction) -> Void)? = nil){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: okHandler))
    alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler))
    viewController.present(alert, animated: true, completion: nil)
    
}

///跳转view
func myPresentView(_ controller:UIViewController, viewName:String , completion: (() -> Void)? = nil ){
    let vc=getViewToStoryboard(viewName)
    //跳转
    controller.present(vc, animated: true, completion: nil)
    
    
}

func getViewToStoryboard(_ viewName:String) -> UIViewController{
    //获取Main.Storyboard对象
    let sb=UIStoryboard(name: "Main", bundle: nil)
    //从storyboard中获取view
    return sb.instantiateViewController(withIdentifier: viewName)
    	
}

///基础的http访问成功处理结果
func baseHttpRequestSuccessHandle(_ vc:UIViewController , httpResult:AnyObject, successMsg:String = "提交成功!" , errorMsg:String = "服务器异常,访问失败!"){
    
    let json = JSON(httpResult)
    
    if json["code"] == "1" {
        myAlert(vc, message: successMsg)
    }else{
        var msg = json["msg"].stringValue
        if msg == "" {
            msg = errorMsg
        }
        myAlert(vc, message: msg)
        print(json)
    }
    
}


extension UIImage {
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func  scaleImage(_ image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            return CGSize(width: newWidth, height: newHeight)
        }else{
            return CGSize(width: width, height: height)
        }
        
    }
    
    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
    func compressImage(_ image: UIImage, maxLength: Int) -> Data? {
        
        let newSize = self.scaleImage(image, imageLength: 300)
        let newImage = self.resizeImage(image, newSize: newSize)
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
        
        while (data?.count)! > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)
        }
        
        return data
    }
    
    
}
