//
//  LayoutCollectionView.swift
//  easyStore
//
//  Created by 黄玮晟 on 2017/3/17.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TurnCenterCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentVC = UIViewController()
    
    var outLineData = [JSON]()
    var turnTaskData = [JSON]()
    var outLineCount = 0
    var outLineContentWidth = CGFloat(150)
    var outLineContentHeight = CGFloat(20)
    var outLineContentFont = UIFont.systemFont(ofSize: 15)
    
    let titleHeight = 32
    let childCellHeight = 90
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
//        if outLineData.count == 0{
//            return 1
//        }
        outLineCount = outLineData.count + 1
        return outLineCount + turnTaskData.count
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
//        if outLineData.count == 0{
//            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
//        }
        
        if indexPath.section < outLineCount {
            return builderOutLine(_:collectionView , cellForItemAt:indexPath)
        }else{
            return builderTurnTask(_:collectionView , cellForItemAt:indexPath)
        }
        
        
    }
    
    func builderOutLine(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "c0", for: indexPath)
        }
        
        let cellName = "c1"
        let json = outLineData[indexPath.section - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as? UILabel
        let outLineName = json["outlinename"].stringValue
        
        //计算展示大纲label的行数与高度
        lbl?.text = outLineName
        let lineNum = outLineName.getLineNumberForUILabel(lbl!)
        lbl?.numberOfLines = lineNum
        lbl?.frame.size = CGSize(width: (lbl?.frame.width)!, height: outLineContentHeight.multiplied(by: CGFloat(lineNum)))
        
        
        lbl = cell.viewWithTag(10002) as? UILabel
        lbl?.text = "\(json["requirednum"].stringValue)例"
        lbl = cell.viewWithTag(10003) as? UILabel
        lbl?.text = "\(json["completenum"].stringValue)例"
        lbl = cell.viewWithTag(10004) as? UILabel
        lbl?.text = "\(json["overrate"].stringValue)%"
        return cell
    }
    
    func builderTurnTask(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellName = "c2"
        let cellIndex = indexPath.section - outLineCount
        let json = turnTaskData[cellIndex]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as? UILabel
        lbl?.text = json["officename"].stringValue
        lbl = cell.viewWithTag(10002) as? UILabel
        let status = json["state"].intValue
        var statusText = "";
        switch status {
        case 0:
            statusText = "待轮转"
            lbl?.textColor  = UIColor(hex:"9ba6ad")
            break
        case 10:
            statusText = "轮转中"
            lbl?.textColor  = UIColor(hex:"f95050")
            break
        case 20:
            statusText = "已轮转"
            lbl?.textColor  = UIColor(hex:"62a6e9")
            break
        default:
            break
        }
        lbl?.text = statusText
        lbl = cell.viewWithTag(20001) as? UILabel
        lbl?.text = json["roundcycle"].stringValue
        lbl = cell.viewWithTag(30001) as? UILabel
        lbl?.text = "带教老师 \(json["teachername"].stringValue)"
        lbl = cell.viewWithTag(30002) as? UILabel
        lbl?.text = "参与任务数 \(json["tasknum"].stringValue)"
        
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    //展示section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header:HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HeaderReusableView
            
            //let json = jsonDataSource[indexPath.section]
            
            //header.headerLb!.text = json["group_title"].stringValue
            return header
        default:
            return HeaderReusableView()
        }
    }
    
    //分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height = 0
        
        if section == 0 {
            
        }else if section < outLineCount {
            height = 1
        }else{
            height = 10
        }
        
        
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: CGFloat(height))
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if outLineData.count == 0{
            if indexPath.section == 0 {
                return CGSize(width: UIScreen.width-20, height: 55.0 )
            }
            return CGSize(width: UIScreen.width-20, height: 110 )
        }else if indexPath.section == 0 {   //大纲要求的的标题
            return CGSize(width: UIScreen.width, height: 55 )
        }else if indexPath.section < outLineCount { //大纲要求的展示cell
            
            
            let json = outLineData[indexPath.section - 1]
            
            let outLineName = json["outlinename"].stringValue
            let lineNum = outLineName.getLineNumberForWidth(width: outLineContentWidth, cFont: outLineContentFont)
            print("这个高度是:\(CGFloat(20 * lineNum + 25))")
            return CGSize(width: UIScreen.width, height: outLineContentHeight.multiplied(by: CGFloat(lineNum)).adding(25))
            
        }else{  //任务的cell
            return CGSize(width: UIScreen.width-20, height: 110 )
        }
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.section >= outLineCount{
            let i = indexPath.section - outLineCount
            let vc = getViewToStoryboard("turnDetailView") as! TurnDetailController
            vc.turnTaskData = turnTaskData[i]
            vc.roundokpeopleresultid = turnTaskData[i]["roundokpeopleresultid"].stringValue
            parentVC.present(vc, animated: true, completion: nil)
        }
    }
    
}

class HeaderReusableView: UICollectionReusableView {
    var headerLb:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        let width = UIScreen.width-40
        let x = (UIScreen.width - width) / 2
        headerLb = UILabel(frame: CGRect.init(x: x, y: 1, width: width, height: 0))
        headerLb.backgroundColor = UIColor(hex: "e9ebf3")
        headerLb.textAlignment = .center
        headerLb.font = UIFont.boldSystemFont(ofSize: 16)
        headerLb.textColor = UIColor(hex: "ffffff")
        headerLb.layer.borderColor = UIColor(hex: "333333").cgColor
        headerLb.layer.borderWidth = 0
        headerLb.layer.cornerRadius = 8
        self.addSubview(headerLb!)
        //self.backgroundColor = UIColor.white
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
