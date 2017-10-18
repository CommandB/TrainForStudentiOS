//
//  TurnDetailController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import GTMRefresh

class TurnDetailController : MyBaseUIViewController{
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var alertOutlineView: UIView!
    
    @IBOutlet weak var btn_btnList: UIButton!
    
    //轮转数据
    var turnTaskData = JSON.init("{}")
    //
    var roundokpeopleresultid = ""
    
    let ttc = TurnTaskCollectionView()
    
    let otc = OutlineTaskCollectionView()
    
    @IBOutlet weak var completedTasksCollection: UICollectionView!
    
    @IBOutlet weak var outlineTaskCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222)
        let subTitleView = view.viewWithTag(33333)
        
        super.setNavigationBarColor(views: [barView,titleView,subTitleView], titleIndex: 1,titleText: "轮转详情")
        
        ttc.parentView = self
        ttc.isFirstLoad = true
        completedTasksCollection.gtm_addRefreshHeaderView(delegate: self)
        completedTasksCollection.gtm_addLoadMoreFooterView(delegate: self)
        completedTasksCollection.dataSource = ttc
        completedTasksCollection.delegate = ttc
        
        otc.parentView = self
        otc.isFirstLoad = true
        outlineTaskCollection.dataSource = otc
        outlineTaskCollection.delegate = otc
        
        
        getOutlineCollectionDatasource()
        getNoOutlineTask()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonViewIsHidden(true)
        alertOutlineView.isHidden = true
        
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = turnTaskData["teachername"].stringValue
        lbl = view.viewWithTag(10002) as! UILabel
        lbl.text = turnTaskData["state_show"].stringValue
        lbl = view.viewWithTag(20001) as! UILabel
        lbl.text = turnTaskData["secretaryname"].stringValue
        lbl = view.viewWithTag(20002) as! UILabel
        lbl.text = turnTaskData["officename"].stringValue
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = turnTaskData["monthnum"].stringValue
        lbl = view.viewWithTag(30002) as! UILabel
        lbl.text = turnTaskData["turnprocess"].stringValue
        
        
        
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //右上角 + 按钮
    @IBAction func btn_btnList_inside(_ sender: UIButton) {
        if sender.tag == 0 {
            buttonViewIsHidden(false)
        }else{
            buttonViewIsHidden(true)
        }
        alertOutlineView.isHidden = true
    }
    
    
    //任务申报
    @IBAction func btn_taskApply_inside(_ sender: UIButton) {
        myPresentView(self, viewName: "taskApplyView")
    }
    
    //任务申报清单
    @IBAction func btn_taskApplyList_inside(_ sender: UIButton) {
        myPresentView(self, viewName: "taskApplyListView")
    }
    
    //弹出view的空白处
    @IBAction func btn_space_inside(_ sender: UIButton) {
        alertOutlineView.isHidden = true
    }
    
    
    //获取大纲要求
    func getOutlineCollectionDatasource(){
        
        let url = SERVER_PORT + "rest/outline/queryOutlineWithRound.do"
        myPostRequest(url,["roundofficeid":turnTaskData["roundofficeid"].stringValue , "officeid":turnTaskData["officeid"].stringValue]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.ttc.outlineData = json["data"].arrayValue
                    self.otc.outlineData = json["data"].arrayValue
                    self.completedTasksCollection.reloadData()
                    self.outlineTaskCollection.reloadData()
                }else{
                    myAlert(self, message: "请求大纲列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    //获取未挂载大纲的任务
    func getNoOutlineTask(){
        
        if isLastPage{
            return
        }
        let url = SERVER_PORT + "rest/round/queryNoOutlineTask.do"
        myPostRequest(url,["roundokpeopleresultid":roundokpeopleresultid , "pageindex":pageIndex * pageSize , "pagesize":pageSize ]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if arrayData.count < self.pageSize{
                        self.isLastPage = true
                    }
                    self.ttc.jsonDataSource += json["data"].arrayValue
                    //修改上拉刷新和下拉加载的状态
                    self.completedTasksCollection.endRefreshing(isSuccess: true)
                    self.completedTasksCollection.endLoadMore(isNoMoreData: self.isLastPage)
                    
                    self.completedTasksCollection.reloadData()
                }else{
                    self.completedTasksCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求任务列表失败!")
                }
                self.pageIndex += 1    //页码增加
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    //控制右上角菜单的现实和隐藏
    func buttonViewIsHidden(_ isHidden : Bool){
        
        if isHidden{
            btn_btnList.tag = 0
        }else{
            btn_btnList.tag = 1
        }
        buttonView.isHidden = isHidden
    }
    
    public override func refresh() {
        initLimitPage()
        getOutlineCollectionDatasource()
        getNoOutlineTask()
    }
    
    override func loadMore() {
        getNoOutlineTask()
    }
    
    ///初始化分页属性
    override func initLimitPage(){
        pageIndex = 0
        isLoading = false
        isLastPage = false
        
        ttc.jsonDataSource = [JSON]()
        ttc.outlineData = [JSON]()
    }
    
}
