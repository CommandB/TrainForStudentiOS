//
//  MyselfController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/28.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class MyselfController: MyBaseUIViewController {
    
    @IBOutlet weak var selfCollection: UICollectionView!
    
    @IBOutlet weak var btn_settings: UIButton!
    
    @IBOutlet weak var showImageView: UIView!
    
    let selfView = MyselfCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "我的")
        
        selfView.parentView = self
        selfCollection.delegate = selfView
        selfCollection.dataSource = selfView
        selfCollection.gtm_addRefreshHeaderView(delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        selectedTabBarIndex = 4
        
        showImageView.isHidden = true
        getMySelfData()
        getMyQr()
    }
    
    @IBAction func btn_settings_inside(_ sender: UIButton) {
        myPresentView(self, viewName: "settingsView")
    }
    
        
    
    @IBAction func btn_myQRCancel_inside(_ sender: UIButton) {
        showImageView.isHidden = true
    }
    
    //获取我的信息
    func getMySelfData(){
        
        let url = SERVER_PORT+"rest/personStudent/query.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.selfView.jsonDataSource = json["data"]
                    self.selfCollection.reloadData()
                    self.selfCollection.endRefreshing(isSuccess: true)
                }else{
                    self.selfCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求我的信息失败!")
                }
            case .failure(let error):
                self.selfCollection.endRefreshing(isSuccess: false)
                print(error)
            }
            
        })
        
    }
    
    //获取我的二维码
    func getMyQr(){
        
        let url = SERVER_PORT+"rest/public/GenerateQRCode.do"
        myPostRequest(url,["type":"mycode"]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    let qrCode = json["qrcode"].stringValue
                    let qrView = self.showImageView.viewWithTag(10001) as! UIImageView
                    qrView.image = UIImage.createQR(text: qrCode, size: 240)
                }else{
                    myAlert(self, message: "获取我的二维码信息失败!")
                }
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    override func refresh() {
        getMySelfData()
        getMyQr()
    }
    
}
