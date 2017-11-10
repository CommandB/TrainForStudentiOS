//
//  Task.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/26.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WaitExamTaskCollectionView : MyBaseCollectionView{
    
    var parentView : EvaluationCenterController? = nil
    
    //实现UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if showNoDataCell{
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyNoDataCellView.identifier, for: indexPath)
        }
            
        let cellName = "c1"
        let json = jsonDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        var lbl = cell.viewWithTag(10001) as! UILabel
        lbl.text = json["title"].stringValue
        lbl = cell.viewWithTag(20001) as! UILabel
        lbl.text = json["examtypename"].stringValue
        lbl = cell.viewWithTag(20002) as! UILabel
        lbl.text = json["task_state_show"].stringValue
        lbl = cell.viewWithTag(30001) as! UILabel
        lbl.text = json["examlong"].stringValue
        lbl = cell.viewWithTag(30002) as! UILabel
        lbl.text = json["passscore"].stringValue + "/" + json["exercisesscore"].stringValue
        lbl = cell.viewWithTag(40001) as! UILabel
        lbl.text = json["starttime"].stringValue
        lbl = cell.viewWithTag(50001) as! UILabel
        lbl.text = json["addressname"].stringValue
        
        cell.layer.cornerRadius = 4
        
        return cell
        
    }
    
    //size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let json = jsonDataSource[indexPath.item]
        if json["examtypename"].stringValue == "理论" {
            return CGSize(width: UIScreen.width, height: 190)
        }
        return CGSize(width: UIScreen.width, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    public override func refresh() {
        initLimitPage()
        parentView?.getExamDatasource()
    }
    
    override func loadMore() {
        parentView?.getExamDatasource()
    }
    
    ///初始化分页属性
    override func initLimitPage(){
        pageIndex = 0
        isLoading = false
        isLastPage = false
        jsonDataSource = [JSON]()
        parentView?.examCollection.reloadData()
    }
    

    
}

