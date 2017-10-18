//
//  WishDetailController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/29.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishDetailController: MyBaseUIViewController {
    
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var wishCollection: UICollectionView!
    
    let wishView = WishDetailCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "心愿详情")
        
        wishView.parentVC = self
        wishCollection.delegate = wishView
        wishCollection.dataSource = wishView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if wishView.jsonDataSource["state"].intValue >= 2{
            btn_cancel.isHidden = true
        }
//        getWish()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //取消申请按钮
    @IBAction func btn_cancel_inside(_ sender: UIButton) {
        let url = SERVER_PORT+"rest/wishList/cancle.do"
        myPostRequest(url,["wishlistid":wishView.jsonDataSource["wishlistid"].stringValue]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "取消成功!")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    myAlert(self, message: "取消心愿单失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
}
