//
//  WishListController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/29.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishListController: MyBaseUIViewController {
    
    @IBOutlet weak var wishCollection: UICollectionView!
    
    let wishView = WishListCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "心愿列表")
        
        wishView.parentView = self
        wishCollection.registerNoDataCellView()
        wishCollection.delegate = wishView
        wishCollection.dataSource = wishView
        wishCollection.gtm_addRefreshHeaderView(delegate: wishView)
        wishCollection.gtm_addLoadMoreFooterView(delegate: wishView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        wishView.initLimitPage()
        wishCollection.reloadData()
        getWishList()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_wishAdd_inside(_ sender: UIButton) {
        myPresentView(self, viewName: "wishAddView")
    }
    
    
    //获取心愿单列表
    func getWishList(){
        
        if wishView.isLastPage{
            return
        }
        
        let url = SERVER_PORT+"rest/wishList/query.do"
        myPostRequest(url,["pageindex":wishView.pageIndex * wishView.pageSize , "pagesize":wishView.pageSize]).responseJSON(completionHandler: {resp in

            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if(arrayData.count>0){
                        self.wishView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.wishView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.wishCollection.endRefreshing(isSuccess: true)
                    self.wishCollection.endLoadMore(isNoMoreData: self.wishView.isLastPage)
                    
                    self.wishCollection.reloadData()
                }else{
                    self.wishCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求心愿单列表失败!")
                }
                
                self.wishView.pageIndex += 1    //页码增加
                
                
            case .failure(let error):
                self.wishCollection.endRefreshing(isSuccess: false)
                print(error)
            }
            
        })
        
        
    }
    
}
