//
//  FirstViewController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import UIKit
import SwiftyJSON

class TurnCenterController: MyBaseUIViewController {
    
    let c : CircleDataView = CircleDataView()
    
    let tc = TurnCenterCollectionView()
    
    @IBOutlet weak var turnCenterCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let barView = view.viewWithTag(10001)
        let titleView = view.viewWithTag(20001) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "我的轮转")
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing=0
        collectionLayout.minimumInteritemSpacing=0
        collectionLayout.headerReferenceSize = CGSize(width: UIScreen.width, height: 35)
        
        
        tc.parentVC = self
//        turnCenterCollection.registerNoDataCellView()
        turnCenterCollection.dataSource = tc
        turnCenterCollection.delegate = tc
        turnCenterCollection.collectionViewLayout = collectionLayout
        
        
        //注册section Header
        turnCenterCollection.register(HeaderReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        selectedTabBarIndex = 1
        
        getOutlineCollectionDatasource()
        getTurnTaskCollectionDatasource()
        
    }
    
    

    //获取要求的任务列表
    func getOutlineCollectionDatasource(){
        
        let url = SERVER_PORT+"rest/outline/query.do"
        myPostRequest(url).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.tc.outLineData = json["data"].arrayValue
                    self.turnCenterCollection.reloadData()
                }else{
                    myAlert(self, message: "请求要求任务列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    //获取轮转的任务列表
    func getTurnTaskCollectionDatasource(){
        
        let url = SERVER_PORT+"rest/round/query.do"
        myPostRequest(url,["pageindex":pageIndex , "pagesize":100]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.tc.turnTaskData = json["data"].arrayValue
                    self.turnCenterCollection.reloadData()
                }else{
                    myAlert(self, message: "请求轮转任务列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }


}

