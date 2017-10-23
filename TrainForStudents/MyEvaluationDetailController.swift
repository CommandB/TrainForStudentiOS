//
//  MyEvaluationDetialController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/30.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyEvaluationDetailController: MyBaseUIViewController {
    
    
    @IBOutlet weak var evaluationCollection: UICollectionView!
    
    let evaluationView = MyEvaluationDetailCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "评价详情")
        
        evaluationView.parentView = self
        evaluationCollection.delegate = evaluationView
        evaluationCollection.dataSource = evaluationView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let json = evaluationView.jsonDataSource
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = json["officename"].stringValue
        lbl = view.viewWithTag(10002) as! UILabel
        lbl.text = "好评率 \(json["rate"].stringValue)%"
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
