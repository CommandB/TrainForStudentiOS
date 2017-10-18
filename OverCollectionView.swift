//
//  OverCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/8.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OverCollectionView: MyBaseCollectionView{
    
    var parentView : TaskCenterController? = nil
    
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        if jsonDataSource.count <= indexPath.item{
            return cell
        }
        let json = jsonDataSource[indexPath.item]
        
        if json["addressname"].stringValue == ""{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c2", for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        }
        
        var lbl = cell.viewWithTag(10001) as! UILabel
//        lbl.text = "[\(json["tasktypeshow"].stringValue)]\(json["title"].stringValue)"
        lbl.text = "\(json["title"].stringValue)"
        let btn = cell.viewWithTag(10002) as! UIButton
        let f = btn.frame
        if cell.viewWithTag(10003) == nil{
            lbl = UILabel(frame: CGRect(x: UIScreen.width.subtracting(46), y: f.origin.y.subtracting(3), width: f.size.width.subtracting(10), height: f.size.height))
        }else{
            lbl = cell.viewWithTag(10003) as! UILabel
        }
        
        lbl.text = json["tasktypeshort"].stringValue
        lbl.textColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 2
        lbl.tag = 10003
        lbl.tag = 10003
        if let subview = cell.viewWithTag(10003) {
            subview.removeFromSuperview()
        }
        cell.addSubview(lbl)
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = json["student_state_show"].stringValue
        lbl.layer.cornerRadius = 4
        lbl.clipsToBounds = true
        lbl = cell.viewWithTag(30002) as! UILabel
        lbl.text = json["creater"].stringValue
        lbl.layer.cornerRadius = 4
        lbl.clipsToBounds = true
        lbl = cell.viewWithTag(30003) as! UILabel
        lbl.text = json["starttime_show"].stringValue
        lbl.layer.cornerRadius = 4
        lbl.clipsToBounds = true
        lbl = cell.viewWithTag(40001) as! UILabel
        lbl.text = json["note"].stringValue
        
        
        if json["addressname"].stringValue != ""{
            lbl = cell.viewWithTag(50002) as! UILabel
            lbl.text = json["addressname"].stringValue
        }
        
        if json["type"].stringValue == "1"{
            let btn = cell.viewWithTag(50003) as! UIButton
            btn.isHidden = false
            btn.restorationIdentifier = json["taskid"].stringValue
            btn.addTarget(self, action: #selector(btn_assistant_inside), for: .touchUpInside)
            btn.layer.cornerRadius = 8
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0).cgColor
            btn.setTitleColor(UIColor.init(red: 64/255.0, green: 123/255.0, blue: 216/255.0, alpha: 1.0), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.backgroundColor = .clear
        }
        
        return cell

        
    }
    
    //cell被选中
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if jsonDataSource.count > indexPath.item{
            let headData = jsonDataSource[indexPath.item]
            if headData["type"].stringValue == "2"{
                let vc = getViewToStoryboard("taskDetail") as! TaskDetailController
                vc.headDataJson = headData
                parentView?.present(vc, animated: true, completion: nil)
            }else{
                let vc = getViewToStoryboard("taskDetail2View") as! TaskDetail2Controller
                vc.headDataJson = headData
                parentView?.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
    
    //计算cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if showNoDataCell{
            return CGSize(width: UIScreen.width, height: 50)
        }
        
        let json = jsonDataSource[indexPath.item]
        var cellHeight = CGFloat(125)
        
        if json["addressname"].stringValue != ""{
            cellHeight = CGFloat(160)
        }
        
        return CGSize(width: UIScreen.width, height: cellHeight)
    }
    
    public override func refresh() {
        initLimitPage()
        parentView?.searchParam = nil
        parentView?.getOverCollectionDatasource()
    }
    
    override func loadMore() {
        parentView?.getOverCollectionDatasource()
    }
    
    ///初始化分页属性
    override func initLimitPage(){
        pageIndex = 0
        isLoading = false
        isLastPage = false
        jsonDataSource = [JSON]()
    }
    
    func btn_assistant_inside(sender : UIButton){
        let vc = getViewToStoryboard("assistantView") as! AssistantController
        vc.taskId = sender.restorationIdentifier!
        parentView?.present(vc, animated: true, completion: nil)
    }
    
    
}
