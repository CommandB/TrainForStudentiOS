//
//  TaskApplyDetalController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/15.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TaskApplyDetailController: MyBaseUIViewController {
    
    @IBOutlet weak var txt_type: UITextField!
    
    @IBOutlet weak var txt_code: UITextField!
    
    @IBOutlet weak var txt_completeDate: UITextField!
    
    @IBOutlet weak var txt_content: UITextView!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    let imageCollectionView = TaskApplyDetailImageCollectionView()
    
    var headData = JSON.init("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务申报详情")
        
        txt_type.layer.cornerRadius = 4
        txt_type.isUserInteractionEnabled = false
        txt_type.text = headData["typename"].stringValue
        
        txt_code.layer.cornerRadius = 4
        txt_code.isUserInteractionEnabled = false
        txt_code.text = headData["caseid"].stringValue
        
        txt_completeDate.layer.cornerRadius = 4
        txt_completeDate.isUserInteractionEnabled = false
        txt_completeDate.text = headData["finshtime"].stringValue
        
        txt_content.layer.cornerRadius = 4
        txt_content.isUserInteractionEnabled = false
        txt_content.text = headData["traincontent"].stringValue
        
        imageCollectionView.parentView = self
        imageCollection.delegate = imageCollectionView
        imageCollection.dataSource = imageCollectionView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        imageCollectionView.jsonDataSource = headData["imglist"].arrayValue
        
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
