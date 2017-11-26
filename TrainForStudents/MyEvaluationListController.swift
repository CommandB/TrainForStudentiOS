//
//  MyEvaluationListController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/30.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AVFoundation

class MyEvaluationListController: MyBaseUIViewController , AVCaptureMetadataOutputObjectsDelegate  {
    
    @IBOutlet weak var lbl_markLine: UILabel!
    
    @IBOutlet weak var btn_dept: UIButton!
    
    @IBOutlet weak var btn_activity: UIButton!
    
    
    //出科 collection
    @IBOutlet weak var deptCollection: UICollectionView!
    
    let deptView = MyEvaluationListCollectionView()
    
    //教学活动
    @IBOutlet weak var activityCollection: UICollectionView!
    
    let activityView = MyEvaluationListCollectionView()
    
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deptCollection.delegate = deptView
        deptCollection.dataSource = deptView
        deptCollection.registerNoDataCellView()
        deptView.parentView = self
        deptView.showNoDataCell = true
        
        activityCollection.delegate = activityView
        activityCollection.dataSource = activityView
        activityCollection.registerNoDataCellView()
        activityView.parentView = self
        activityView.showNoDataCell = true
        
        btn_activity.restorationIdentifier = "btn_activity"
        deptCollection.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
    }
    
    func refreshAction() {
        getEvaluationCollectionDatasource(60)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置2个collection的位置
        deptCollection.frame.origin = CGPoint(x: 0, y: 90)
        activityCollection.frame.origin = CGPoint(x: 0-UIScreen.width, y: 90)
        
        lbl_markLine.clipsToBounds = true
        lbl_markLine.layer.cornerRadius = 1
        buttonGroup = [btn_dept , btn_activity]
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        let buttonBar = view.viewWithTag(33333) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView,buttonBar], titleIndex: 1,titleText: "我的评价")
        
        tabsTouchAnimation(sender: btn_dept)
        
        getEvaluationCollectionDatasource(60)
        getEvaluationCollectionDatasource(50)
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //出科评价 按钮
    @IBAction func btn_dept_inside(_ sender: UIButton) {
        tabsTouchAnimation(sender: sender)
        //getEvaluationCollectionDatasource(0)
    }
    
    //教学活动 按钮
    @IBAction func btn_activity_inside(_ sender: UIButton) {
        tabsTouchAnimation(sender: sender)
        //getEvaluationCollectionDatasource(1)
    }
    
    
    //获取评价列表
    func getEvaluationCollectionDatasource(_ type : Int){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = SERVER_PORT+"rest/taskEvaluation/queryMyEvaluation.do"
        myPostRequest(url,["evaluatetypeid":String(type) , "pageindex":0 , "pagesize":999]).responseJSON(completionHandler: {resp in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.deptCollection.mj_header.endRefreshing()
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    if type == 50 {
                        self.deptView.jsonDataSource = json["data"].arrayValue
//                        self.deptView.jsonDataSource = JSON.init(d)["data"].arrayValue
                        self.deptCollection.reloadData()
                    }else{
                        self.activityView.jsonDataSource = json["data"].arrayValue
//                        self.activityView.jsonDataSource = JSON.init(d)["data"].arrayValue
                        self.activityCollection.reloadData()
                    }
                    
                }else{
                    myAlert(self, message: "请求出科评价列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    func tabsTouchAnimation( sender : UIButton){
        //-----------------计算 "下标线"label的动画参数
        
        for b in buttonGroup {
            if b == sender{
                b.setTitleColor(UIColor.white, for: .normal)
            }else{
                b.setTitleColor(UIColor.init(hex: "D6DADA"), for: .normal);
            }
        }
        
        let btn_x = sender.frame.origin.x                      //按钮x轴
        //计算下标线的x轴位置
        let target_x = btn_x/* + btn_middle - lbl_half*/
        let target_y = lbl_markLine.frame.origin.y
        
        
        //动画开始
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        let btnTextWidth = sender.titleLabel?.text?.getWidth(font: (sender.titleLabel?.font)!)
        lbl_markLine.frame = CGRect(origin: CGPoint(x:target_x,y:target_y), size: CGSize(width: btnTextWidth!, height: lbl_markLine.frame.height))
        //滑动效果
        //        if sender.restorationIdentifier == "btn_activity"{
        //            deptCollection.frame = CGRect(origin: deptCollection.frame.origin , size: CGSize(width: 0, height: deptCollection.frame.size.height))
        //        }else{
        //            deptCollection.frame = CGRect(origin: deptCollection.frame.origin , size: CGSize(width: UIScreen.width, height: deptCollection.frame.size.height))
        //        }
        //滚动效果
        if sender.restorationIdentifier == "btn_activity"{
            deptCollection.frame = CGRect(origin: CGPoint(x:UIScreen.width*2 , y: deptCollection.frame.origin.y) , size: deptCollection.frame.size)
            activityCollection.frame = CGRect(origin: CGPoint(x:0 , y: deptCollection.frame.origin.y) , size: deptCollection.frame.size)
        }else{
            deptCollection.frame = CGRect(origin: CGPoint(x:0 , y: deptCollection.frame.origin.y) , size: deptCollection.frame.size)
            activityCollection.frame = CGRect(origin: CGPoint(x:0 - UIScreen.width , y: deptCollection.frame.origin.y) , size: deptCollection.frame.size)
        }
        
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    
    
}
