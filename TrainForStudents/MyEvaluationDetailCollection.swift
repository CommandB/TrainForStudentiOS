//
//  MyEvaluationDetailCollection.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/30.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyEvaluationDetailCollection : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView = UIViewController()
    var jsonDataSource = JSON.init("")
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return jsonDataSource["items"].arrayValue.count
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        let json = jsonDataSource["items"].arrayValue[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
        
        let lbl = cell.viewWithTag(10002) as! UILabel
        lbl.text = json["itemtitle"].stringValue
        let btn = cell.viewWithTag(10001) as! UIButton
        btn.setTitle("\(json["itemrate"].stringValue)%", for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UIColor(hex: "c7d3e0").cgColor
        btn.layer.borderWidth = 1
        
        // 加5是为了右边空出一点
        let contentWidth = 5 + "\(json["itemrate"].stringValue)%".getWidth(font: UIFont.systemFont(ofSize: 14))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: btn.frame.width.subtracting(contentWidth), bottom: 0, right: 0)
        
        return cell
        
    }
    
    func buttonBuilder(_ frame : CGRect , _ btnTitle : String  , _ btnContent : String) -> UIButton{
        let btn = UIButton.init(frame: frame)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor(hex: "f5f8fb")
        // 加5是为了右边空出一点
        let contentWidth = 5 + "\(btnContent)%".getWidth(font: UIFont.systemFont(ofSize: 14))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: frame.width.subtracting(contentWidth), bottom: 0, right: 0)
        
        btn.setTitle("\(btnContent)%", for: .normal)
        btn.setTitleColor(UIColor(hex: "3b454f"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
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
        
        //        let vc = getViewToStoryboard("wishDetailView") as! WishDetailController
        //        vc.wishView.jsonDataSource = jsonDataSource[indexPath.item]
        //        parentView.present(vc, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width / 3, height: 45)
    }
    
}
