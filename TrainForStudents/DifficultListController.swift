//
//  DifficultListController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/1.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DifficultListController: MyBaseUIViewController {
    
    let listView = DifficultListCollectionView()
    
    @IBOutlet weak var lbl_markLine: UILabel!
    
    @IBOutlet weak var btn_mine: UIButton!
    
    @IBOutlet weak var btn_office: UIButton!
    
    
    //我的疑难 collection
    @IBOutlet weak var mineCollection: UICollectionView!
    
    let mineView = DifficultListCollectionView()
    
    //当前科室
    @IBOutlet weak var officeCollection: UICollectionView!
    
    let officeView = DifficultListCollectionView()
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    var addTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mineCollection.gtm_addRefreshHeaderView(delegate: mineView)
        mineCollection.gtm_addLoadMoreFooterView(delegate: mineView)
        mineCollection.delegate = mineView
        mineCollection.dataSource = mineView
        mineView.parentView = self
        mineView.isMine = true
        
        officeCollection.gtm_addRefreshHeaderView(delegate: officeView)
        officeCollection.gtm_addLoadMoreFooterView(delegate: officeView)
        officeCollection.delegate = officeView
        officeCollection.dataSource = officeView
        officeView.parentView = self
        officeView.isMine = false
        
        btn_office.restorationIdentifier = "btn_office"
        
        mineView.initLimitPage()
        officeView.initLimitPage()
        getMineDatasource()
        getOfficeDatasource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置2个collection的位置
        mineCollection.frame.origin = CGPoint(x: 0, y: 90)
        officeCollection.frame.origin = CGPoint(x: 0-UIScreen.width, y: 90)
        
        lbl_markLine.clipsToBounds = true
        lbl_markLine.layer.cornerRadius = 1
        buttonGroup = [btn_mine , btn_office]
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        let buttonBar = view.viewWithTag(33333) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView,buttonBar], titleIndex: 1,titleText: "疑难专区")
        
        tabsTouchAnimation(sender: btn_mine)
        
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //添加疑问
    @IBAction func btn_add_inside(_ sender: UIButton) {
        
        myPresentView(self, viewName: "difficultAddView")
        
    }
    
    //我的疑难 按钮
    @IBAction func btn_mine_inside(_ sender: UIButton) {
        tabsTouchAnimation(sender: sender)
    }
    
    //科室疑难 按钮
    @IBAction func btn_office_inside(_ sender: UIButton) {
        tabsTouchAnimation(sender: sender)
    }

    
    //获取我的疑问
    func getMineDatasource(){
        
        if mineView.isLastPage{
            return
        }
        
        let url = SERVER_PORT+"rest/difficult/queryByOffice.do"
        myPostRequest(url,["type":1 , "ismy":1 , "pageindex":mineView.pageIndex * mineView.pageSize , "pagesize":mineView.pageSize]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if(arrayData.count>0){
                        self.mineView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.mineView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.mineCollection.endRefreshing(isSuccess: true)
                    self.mineCollection.endLoadMore(isNoMoreData: self.mineView.isLastPage)
                    
                    self.mineCollection.reloadData()
                    
                }else{
                    self.mineCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求我的疑问列表失败!")
                }
                
                self.mineView.pageIndex += 1    //页码增加
                
            case .failure(let error):
                self.mineCollection.endRefreshing(isSuccess: false)
                print(error)
            }
            
        })
        
    }
    
    //获取科室疑问
    func getOfficeDatasource(){
        
        if officeView.isLastPage{
            return
        }
        
        let url = SERVER_PORT+"rest/difficult/queryByOffice.do"
        myPostRequest(url,["type":1 , "ismy":0, "pageindex":officeView.pageIndex * officeView.pageSize , "pagesize":officeView.pageSize]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if(arrayData.count>0){
                        self.officeView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.officeView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.officeCollection.endRefreshing(isSuccess: true)
                    self.officeCollection.endLoadMore(isNoMoreData: self.officeView.isLastPage)
                    
                    self.officeCollection.reloadData()
                    
                }else{
                    self.officeCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求科室疑问列表失败!")
                }
                
                self.officeView.pageIndex += 1    //页码增加
                
            case .failure(let error):
                self.officeCollection.endRefreshing(isSuccess: false)
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
        //        if sender.restorationIdentifier == "btn_office"{
        //            mineCollection.frame = CGRect(origin: mineCollection.frame.origin , size: CGSize(width: 0, height: mineCollection.frame.size.height))
        //        }else{
        //            mineCollection.frame = CGRect(origin: mineCollection.frame.origin , size: CGSize(width: UIScreen.width, height: mineCollection.frame.size.height))
        //        }
        //滚动效果
        if sender.restorationIdentifier == "btn_office"{
            mineCollection.frame = CGRect(origin: CGPoint(x:UIScreen.width*2 , y: mineCollection.frame.origin.y) , size: mineCollection.frame.size)
            officeCollection.frame = CGRect(origin: CGPoint(x:0 , y: mineCollection.frame.origin.y) , size: mineCollection.frame.size)
        }else{
            mineCollection.frame = CGRect(origin: CGPoint(x:0 , y: mineCollection.frame.origin.y) , size: mineCollection.frame.size)
            officeCollection.frame = CGRect(origin: CGPoint(x:0 - UIScreen.width , y: mineCollection.frame.origin.y) , size: mineCollection.frame.size)
        }
        
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    
    
}
