//
//  MeterialListController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/6.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MeterialListController : MyBaseUIViewController{
    
    //教材
    @IBOutlet weak var meterialCollection: UICollectionView!
    
    let meterialView = MeterialListCollectionView()
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meterialCollection.gtm_addRefreshHeaderView(delegate: meterialView)
        meterialCollection.gtm_addLoadMoreFooterView(delegate: meterialView)
        meterialCollection.delegate = meterialView
        meterialCollection.dataSource = meterialView
        meterialView.parentView = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "教材")
        
        getMeterials()
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //获取教材
    func getMeterials(){
        
        if meterialView.isLastPage{
            return
        }
        let url = SERVER_PORT+"rest/teachingMaterial/queryByOffice.do"
        myPostRequest(url,["pageindex":meterialView.pageIndex * pageSize , "pagesize":pageSize]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if(arrayData.count>0){
                        self.meterialView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.meterialView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.meterialCollection.endRefreshing(isSuccess: true)
                    self.meterialCollection.endLoadMore(isNoMoreData: self.meterialView.isLastPage)
                    
                    self.meterialCollection.reloadData()
                    
                }else{
                    self.meterialCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求教材列表失败!")
                }
                
                self.meterialView.pageIndex += 1    //页码增加
                
            case .failure(let error):
                print(error)
            }

            
        })
        
    }
    
}
