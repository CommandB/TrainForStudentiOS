//
//  TurnTaskCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TurnTaskCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView : TurnDetailController? = nil
    var outlineData = [JSON]()
    var jsonDataSource = [JSON]()
    var selectedIndexPath = IndexPath.init()
    var selectedTaskId = ""
    var isFirstLoad = false
    let itemWidth = UIScreen.width
    let itemHeight = CGFloat(35)
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {
            return outlineData.count
        }else{
            return jsonDataSource.count
        }
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
            let json = outlineData[indexPath.item]
            var lbl = cell.viewWithTag(10001) as? UILabel
            lbl?.text = json["roundsubjectname"].stringValue
            lbl = cell.viewWithTag(10002) as? UILabel
            lbl?.text = "需轮转\(json["monthnum"].stringValue)个月"
            
            var linenum = 0
            let requireList = json["infolist"].arrayValue
            for rJson in requireList {
                let x = 0
                var y = 41
                //计算y轴
                y += Int(itemHeight.multiplied(by: CGFloat(linenum)))
                
                let v = Bundle.main.loadNibNamed("OutlineItem", owner: nil, options: nil)?.first as! OutlineItem
                
                var frame = CGRect()
                frame.origin = CGPoint(x: x, y: y)
                frame.size = CGSize(width: itemWidth, height: itemHeight)
                v.frame = frame
                
                v.lbl_content.text = rJson["outlineitemname"].stringValue
                v.lbl_complate.text = rJson["completenum"].stringValue
                v.lbl_total.text = rJson["requirednum"].stringValue
                v.btn_action.addTarget(self, action: #selector(btn_action_inside), for: .touchUpInside)
                
                cell.addSubview(v)
                
                linenum += 1
            }
            
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c2", for: indexPath)
            if indexPath.item < jsonDataSource.count{
                let json = jsonDataSource[indexPath.item]
                var lbl = cell.viewWithTag(10001) as? UILabel
                lbl?.text = json["title"].stringValue
                lbl = cell.viewWithTag(20001) as? UILabel
                lbl?.text = json["typename"].stringValue
                lbl = cell.viewWithTag(20002) as? UILabel
                lbl?.text = json["finishtimeshow"].stringValue
                lbl = cell.viewWithTag(30001) as? UILabel
                lbl?.text = json["note"].stringValue
                cell.layer.cornerRadius = 8
                
                let btn = cell.viewWithTag(10002) as! UIButton
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.setTitle(json["mountcount"].stringValue, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: 500)
                btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 15, right: 0)
            }
            
        }
        
        
        return cell
        
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            
            if indexPath.item == 0 && isFirstLoad{
                isFirstLoad = false
                selectedIndexPath = indexPath
            }
            
            var height = CGFloat(40)
            //如果此cell被用户选择则展开大纲
            if indexPath == selectedIndexPath{
                
                let json = outlineData[indexPath.item]
                let count = json["infolist"].arrayValue.count
                height = itemHeight.multiplied(by: CGFloat(count)).adding(height)
            }

            return CGSize(width: UIScreen.width, height: height)
        }else{
            return CGSize(width: UIScreen.width - 20, height: 110)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        parentView?.buttonViewIsHidden(true)
        
        //判断用户点击的是否是大纲
        if indexPath.section == 0 {
            //判断是展开还是收缩
            if selectedIndexPath == indexPath{
                selectedIndexPath = IndexPath()
            }else{
                selectedIndexPath = indexPath
            }
            collectionView.reloadData()
        }else{
            parentView?.alertOutlineView.isHidden = false
            let data = jsonDataSource[indexPath.item]
            selectedTaskId = data["taskid"].stringValue
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1{
            return CGSize(width: UIScreen.width, height: 10)
        }
        return CGSize.zero
    }
    
    func btn_action_inside(sender : UIButton){
        parentView?.buttonViewIsHidden(true)
    }
    
    
}
