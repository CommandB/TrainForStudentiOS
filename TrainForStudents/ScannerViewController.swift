//
//  ScannerViewController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/11.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyJSON

typealias sendResultValueClosure=(_ string:String , _ vc : UIViewController)->Void
class ScannerViewController: MyBaseUIViewController , AVCaptureMetadataOutputObjectsDelegate ,UIAlertViewDelegate {
    
    @IBOutlet weak var btn_back: UIButton!
    
    var myClosure : sendResultValueClosure?
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        
        myClosure = myClosureImpl
        btn_back.layer.cornerRadius = 8
        btn_back.clipsToBounds = true
        
        let app = (UIApplication.shared.delegate) as! AppDelegate
        let tabBar = (app.window?.rootViewController) as! UITabBarController
        tabBar.hidesBottomBarWhenPushed = true
        
        do{
            self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            self.input = try AVCaptureDeviceInput(device: device)
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width:windowSize.width*3/4, height:windowSize.width*3/4)
            var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                                  y:(windowSize.height-scanSize.height)/2,
                                  width:scanSize.width, height:scanSize.height)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width);
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x:0, y:0, width:scanSize.width,
                                             height:scanSize.height);
            self.scanRectView.center = CGPoint( x:UIScreen.main.bounds.midX,
                                                y:UIScreen.main.bounds.midY)
            self.scanRectView.layer.borderColor = UIColor.green.cgColor
            self.scanRectView.layer.borderWidth = 1;
            
            //开始捕获
            self.session.startRunning()
        }catch _ {
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",
                                                    message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.session.startRunning()
        
//        selectedTabBarIndex = 2
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let app = (UIApplication.shared.delegate) as! AppDelegate
        let tabBar = (app.window?.rootViewController) as! UITabBarController
        tabBar.hidesBottomBarWhenPushed = false
    }
    
    //摄像头捕获
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        
        myClosure!(stringValue! , self)
//        输出结果
//        let alertController = UIAlertController(title: "二维码",
//                                                message: stringValue,preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
//            action in
//            self.dismiss(animated: true, completion: nil)
//            //继续扫描
//            //self.session.startRunning()
//        })
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func btn_back_inside(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
        let app = (UIApplication.shared.delegate) as! AppDelegate
        let tabBar = (app.window?.rootViewController) as! UITabBarController
        tabBar.selectedIndex = selectedTabBarIndex
        if selectedTabBarIndex == 3 {
            tabBar.selectedIndex = 0
        }
    }
    
    func myClosureImpl(_ val : String , vc : UIViewController){
        
        let url = SERVER_PORT+"rest/taskSignResult/sign.do"
        myPostRequest(url,["qrcode":val]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(vc, title: "签到", message: json["msg"].stringValue, handler: { action in
//                        vc.dismiss(animated: true, completion: nil)
                        let app = (UIApplication.shared.delegate) as! AppDelegate
                        let tabBar = (app.window?.rootViewController) as! UITabBarController
                        tabBar.selectedIndex = selectedTabBarIndex
                    })
                    
                }else{
                    myAlert(vc, message: json["msg"].stringValue , handler : { action in
//                        vc.dismiss(animated: true, completion: nil)
                        let app = (UIApplication.shared.delegate) as! AppDelegate
                        let tabBar = (app.window?.rootViewController) as! UITabBarController
                        tabBar.selectedIndex = selectedTabBarIndex
                    })
                }
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
}
