//
//  DirectoryCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/16.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DirectoryCollectionView: UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    var parentView : DirectoryController?
    var jsonDataSource = [JSON]()
    var myCollection : UICollectionView?
    let questionTypeTitle = "   %@【%@】 共%d道 每道%d分 共%d分"
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return jsonDataSource.count
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return jsonDataSource[section]["questions"].arrayValue.count
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cellName = "c1"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        let json = jsonDataSource[indexPath.section]
        let questions = json["questions"].arrayValue
        let q = questions[indexPath.item]
        let lbl = (cell.viewWithTag(10001) as? UILabel)!
        let title = q["indexname"].stringValue + " " + q["title"].stringValue
        lbl.text = title
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.width, height: 50)
        
        
    }
    
    //cell被选中
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        parentView?.presentedController?.typeIndex = indexPath.section
        parentView?.presentedController?.questionIndex = indexPath.item
        
        parentView?.dismiss(animated: true, completion: nil)
        
    }
    
    //展示section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! TitleReusableView
            
            let currentType = jsonDataSource[indexPath.section]
            
            header.headerLb!.text = String(format: questionTypeTitle, arguments: [currentType["indexname"].stringValue,currentType["typename"].stringValue,currentType["count"].intValue,currentType["score"].intValue,currentType["count"].intValue * currentType["score"].intValue])
            return header
        default:
            return TitleReusableView()
        }
    }
    
    //分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = 35
        //height = height * section
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: CGFloat(height))
    }
    
    
}

class TitleReusableView: UICollectionReusableView {
    var headerLb:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLb = UILabel(frame: CGRect.init(x: 0, y: 0, width: UIScreen.width, height: 35))
        headerLb.backgroundColor = UIColor(hex: "f5f8fb")
        headerLb.textAlignment = .left
        headerLb.font = UIFont.systemFont(ofSize: 14)
        headerLb.textColor = UIColor(hex: "9ba6ae")
        
        self.addSubview(headerLb!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
