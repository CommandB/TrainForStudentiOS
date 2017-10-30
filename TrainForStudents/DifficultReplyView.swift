//
//  DifficultReplyView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DifficultReplyView :UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    var jsonDataSource = [JSON]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return jsonDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellName = "replyItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        cell.selectionStyle = .none
        let json = jsonDataSource[indexPath.section]
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["creater"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = "\(json["answercontent"].stringValue)"
        
        lbl.numberOfLines = 0
        let num = lbl.text?.getLineNumberForUILabel(lbl)
        lbl.frame.size = CGSize(width: lbl.frame.width, height: lbl.frame.height.multiplied(by: CGFloat(num!)))
        lbl.lineBreakMode = .byCharWrapping
        
        
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = DateUtil.stringToDateToMinute(json["createtime"].stringValue)
        
        
        return cell
        
    }
    
    //cell的高度
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    //section的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
//    //section的样式
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 5))
        label.backgroundColor = tableView.backgroundColor
        return label
    }
    
}
