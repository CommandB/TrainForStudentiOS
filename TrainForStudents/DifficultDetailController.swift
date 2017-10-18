//
//  DifficultDetailController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DifficultDetailController: MyBaseUIViewController {
    
    @IBOutlet weak var tbl_reply: UITableView!
    
    let replyView = DifficultReplyView()
    var headData = JSON("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl_reply.separatorStyle = .none
        tbl_reply.delegate = replyView
        tbl_reply.dataSource = replyView
        tbl_reply.estimatedRowHeight = 510
        tbl_reply.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "疑难专区")
        
        
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = headData["title"].stringValue
        lbl.numberOfLines = 0
        var num = lbl.text?.getLineNumberForUILabel(lbl)
        lbl.frame.size = CGSize(width: lbl.frame.width, height: lbl.frame.height.multiplied(by: CGFloat(num!)))
        lbl.lineBreakMode = .byCharWrapping
        
        lbl = view.viewWithTag(20001) as! UILabel
        lbl.text = "\(headData["content"].stringValue)"
        lbl.numberOfLines = 0
        num = lbl.text?.getLineNumberForUILabel(lbl)
        lbl.frame.size = CGSize(width: lbl.frame.width, height: lbl.frame.height.multiplied(by: CGFloat(num!)))
        lbl.lineBreakMode = .byCharWrapping
        
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = "\(headData["creater"].stringValue) · \(headData["createtime"].stringValue)"
        
        lbl = view.viewWithTag(30002) as! UILabel
        lbl.text = "\(headData["answers"].count) 回答"
        
        replyView.jsonDataSource = headData["answers"].arrayValue
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
