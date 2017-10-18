//
//  WaitEvanluationTaskCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/26.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WaitEvanluationTaskCollectionView : MyBaseCollectionView{
    
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
        
        var lbl = cell.viewWithTag(10001) as? UILabel
        lbl?.text = json["title"].stringValue
        lbl = cell.viewWithTag(20001) as? UILabel
        lbl?.text = "\(json["evaluatetypename"].stringValue)"
        lbl = cell.viewWithTag(20002) as? UILabel
        lbl?.text = json["personname"].stringValue
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width, height: 80)
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = jsonDataSource[indexPath.item]
        let vc = getViewToStoryboard("evaluationDetailView") as! EvaluationDetailController
        vc.isReadonly = false
        vc.headData = data
        parentView?.present(vc, animated: true, completion: nil)
    }
    
    public override func refresh() {
        initLimitPage()
        parentView?.getEvaluationDatasource()
    }
    
    override func loadMore() {
        parentView?.getEvaluationDatasource()
    }
    
    ///初始化分页属性
    override func initLimitPage(){
        pageIndex = 0
        isLoading = false
        isLastPage = false
        jsonDataSource = [JSON]()
        parentView?.evaluationCollection.reloadData()
    }
    
    
}

