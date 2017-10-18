//
//  HistoryExamController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HistoryExamController: MyBaseUIViewController {
    
    @IBOutlet weak var examCollection: UICollectionView!
    
    let examView = HistoryExamCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(10001)
        let titleView = view.viewWithTag(20001) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "历史考试")
        
        examView.parentVC = self
        examCollection.registerNoDataCellView()
        examCollection.delegate = examView
        examCollection.dataSource = examView
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getExamDatasource()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //获取历史评价
    func getExamDatasource(){
        
        let url = SERVER_PORT+"rest/taskexam/queryHistory.do"
        myPostRequest(url,["pageindex":pageIndex , "pagesize":pageSize]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.examView.jsonDataSource = json["data"].arrayValue
                    self.examCollection.reloadData()
                }else{
                    myAlert(self, message: "请求历史任务列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
}
