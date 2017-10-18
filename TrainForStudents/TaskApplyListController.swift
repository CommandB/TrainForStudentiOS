//
//  TaskApplyListController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/17.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskApplyListController: MyBaseUIViewController {
    
    @IBOutlet weak var taskApplyCollection: UICollectionView!
    
    let taskApplyView = TaskApplyListCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务申请列表")
        
        taskApplyCollection.gtm_addRefreshHeaderView(delegate: taskApplyView)
        taskApplyCollection.gtm_addLoadMoreFooterView(delegate: taskApplyView)
        taskApplyView.parentView = self
        taskApplyCollection.delegate = taskApplyView
        taskApplyCollection.dataSource = taskApplyView
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        taskApplyView.initLimitPage()
        taskApplyCollection.reloadData()
        getTaskApplyList()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //获取任务申请列表
    func getTaskApplyList(){
        
        if taskApplyView.isLastPage{
            return
        }
        
        let url = SERVER_PORT+"rest/taskApply/query.do"
        myPostRequest(url,["pageindex":taskApplyView.pageIndex * pageSize , "pagesize":pageSize]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if arrayData.count < self.pageSize{
                        self.taskApplyView.isLastPage = true
                    }
                    self.taskApplyView.jsonDataSource += json["data"].arrayValue
                    //修改上拉刷新和下拉加载的状态
                    self.taskApplyCollection.endRefreshing(isSuccess: true)
                    self.taskApplyCollection.endLoadMore(isNoMoreData: self.isLastPage)
                    
                    self.taskApplyCollection.reloadData()
                }else{
                    self.taskApplyCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求任务申请列表失败!")
                }
                self.taskApplyView.pageIndex += 1    //页码增加
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    

    
    
}
