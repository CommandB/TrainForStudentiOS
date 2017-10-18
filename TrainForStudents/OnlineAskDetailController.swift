//
//  OnlineAskDetailController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import BMPlayer
import NVActivityIndicatorView

class OnlineAskDetailController: MyBaseUIViewController {
    
    var headData = JSON.init("")
    
    //答案 collection
    @IBOutlet weak var onlineAskCollection: UICollectionView!
    
    let askView = OnlineAskDetailCollectionView()
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onlineAskCollection.delegate = askView
        onlineAskCollection.dataSource = askView
        askView.parentView = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "在线提问")
        
        let lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = headData["title"].stringValue
        //通过文本设置label的行数
        lbl.numberOfLines = (lbl.text?.getLineNumberForWidth(width: lbl.frame.width - 5))!
        //通过行数设置label的高度
        lbl.frame.size = CGSize(width: lbl.frame.width, height: (lbl.text?.getHeight(font: lbl.font))!)
        //通过label的高度 重新计算下面collection的高度以及y轴坐标
        let exHeight = lbl.frame.height - UILabel.getDefaultLineHeight()
        onlineAskCollection.frame.size = CGSize(width: UIScreen.width, height: onlineAskCollection.frame.height.subtracting(exHeight))
        onlineAskCollection.frame.origin = CGPoint(x: 0, y: onlineAskCollection.frame.origin.y.adding(exHeight))
        
        
        askView.jsonDataSource = headData["answers"].arrayValue
        onlineAskCollection.reloadData()
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    
}
