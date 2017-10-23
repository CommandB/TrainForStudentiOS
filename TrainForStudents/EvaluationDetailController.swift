//
//  EvaluationDetailController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class EvaluationDetailController: MyBaseUIViewController {
    
    
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var detailCollection: UICollectionView!
    
    let detailView = EvaluationDetailCollectionView()
    
    var headData = JSON.init("")
    var isReadonly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "评价详情")
        
        detailView.isReadonly = isReadonly
        detailView.parentVC = self
        detailCollection.delegate = detailView
        detailCollection.dataSource = detailView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isReadonly{
            btn_submit.isHidden = true
            detailCollection.frame = CGRect(origin: detailCollection.frame.origin, size: CGSize(width: UIScreen.width, height: detailCollection.frame.height+50))
            
            var lbl = view.viewWithTag(10001) as! UILabel
            lbl.text = headData["evaluationtitle"].stringValue
            lbl = view.viewWithTag(10002) as! UILabel
            lbl.text = headData["evalutedpersonname"].stringValue
            lbl = view.viewWithTag(20001) as! UILabel
            lbl.text = "评价时间  \(headData["evaluationtime"].stringValue)"
            
            lbl = view.viewWithTag(30001) as! UILabel
            lbl.text = headData["evaluatetypename"].stringValue
            lbl = view.viewWithTag(30003) as! UILabel
            lbl.text = "\(headData["value"].stringValue)"
            lbl.textColor = UIColor.red
            lbl.alpha = 0.9
            
        }else{
            
            var lbl = view.viewWithTag(10001) as! UILabel
            lbl.text = headData["title"].stringValue
            lbl = view.viewWithTag(10002) as! UILabel
            lbl.text = headData["personname"].stringValue
            lbl = view.viewWithTag(20001) as! UILabel
            lbl.text = "评价截止时间  \(headData["endtime_show"].stringValue)"
            
            lbl = view.viewWithTag(30001) as! UILabel
            lbl.text = headData["evaluatetypename"].stringValue
            lbl = view.viewWithTag(30002) as! UILabel
            lbl.isHidden = true
            
        }
        
        getDetailDatasource()
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //提交按钮
    @IBAction func btn_submit_inside(_ sender: UIButton) {
        
        let url = SERVER_PORT+"rest/evaluation/commitEvaluationResult.do"
        myPostRequest(url,JSON(["items":detailView.jsonDataSource , "taskid":headData["taskid"]]).dictionaryObject).responseJSON(completionHandler: {resp in
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(self, message: "评价完成!" , handler: {action in
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    myAlert(self, message: "评价失败!\(json["msg"].stringValue)")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    //获取评价详情
    func getDetailDatasource(){
        
        var url = SERVER_PORT+"rest/evaluation/query.do"
        var params = ["evaluationid":headData["evaluationid"].stringValue]
        
        if isReadonly {
            url = SERVER_PORT+"rest/evaluation/queryHistoryResultInfo.do"
            params = ["evaluationid":headData["evaluationid"].stringValue,"taskid":headData["taskid"].stringValue,"loginpersonid":headData["personid"].stringValue]
        }
        myPostRequest(url,params).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.detailView.jsonDataSource = json["data"]
                    for item in json["data"].arrayValue{
                        let index = self.detailView.jsonDataSource.arrayValue.index(of: item)
                        self.detailView.jsonDataSource[index!]["get_value"].stringValue = "5"
                    }
                    self.detailCollection.reloadData()
                }else{
                    myAlert(self, message: "请求评价详情失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
}
