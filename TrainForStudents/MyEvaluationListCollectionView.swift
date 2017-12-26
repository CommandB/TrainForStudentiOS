//
//  MyEvaluationListCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/30.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyEvaluationListCollectionView : MyBaseCollectionView{
    
    var parentView = UIViewController()
    var isCk = false
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
        
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["officename"].stringValue
        lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = "好评率 \(json["rate"].stringValue)%"
        
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = json["createtime"].stringValue
        
        //按钮间距
        let spacing = 15
        //按钮宽度 = [屏幕宽度 - (5 * 按钮间距)] / 3
        let btnWidth = Int(UIScreen.width.subtracting(CGFloat(5 * spacing)).divided(by: 3))
        let btnHeight = 30
        let items = json["items"].arrayValue
        let maxItems = items.count > 6 ? 6 : items.count
        for i in 0...maxItems - 1{
            //行数
            let lineNumber = i <= 2 ? 0 : 1
            //按钮y轴
            let btnY = 43 + lineNumber * (btnHeight + 10)
            //按钮x轴
            let btnX = spacing + (i * spacing) + (btnWidth * i) - ((btnWidth * 3 + spacing * 3) * lineNumber)
            
            cell.addSubview(buttonBuilder(CGRect.init(x: btnX, y: btnY, width: btnWidth, height: btnHeight), items[i]["itemtitle"].stringValue, items[i]["itemrate"].stringValue))
        }
        cell.isUserInteractionEnabled = true
        
        
        return cell
        
    }
    
    func buttonBuilder(_ frame : CGRect , _ btnTitle : String  , _ btnContent : String) -> UIButton{
        let btn = UIButton.init(frame: frame)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor(hex: "f5f8fb")
        // 加5是为了右边空出一点
        let contentWidth = 5 + "\(btnContent)%".getWidth(font: UIFont.systemFont(ofSize: 14))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: frame.width.subtracting(contentWidth), bottom: 0, right: 0)

        btn.setTitle("\(btnContent)%", for: .normal)
        btn.setTitleColor(UIColor(hex: "3b454f"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.alpha = 0.79
        btn.layer.borderColor = UIColor(hex: "c7d3e0").cgColor
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true 
        
        let lbl = UILabel(frame: CGRect(x: 5, y: 0, width: frame.width.subtracting(contentWidth), height: btn.frame.height))
        lbl.text = btnTitle
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor(hex: "3b454f")
        lbl.backgroundColor = UIColor.clear
        btn.addSubview(lbl)
        
        return btn
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = getViewToStoryboard("myEvaluationDetailView") as! MyEvaluationDetailController
        guard jsonDataSource.count > 0 else {
            return
        }
        vc.evaluationView.jsonDataSource = jsonDataSource[indexPath.item]
        parentView.present(vc, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width, height: 160)
    }
    
}
