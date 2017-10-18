//
//  MyBaseCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import GTMRefresh

class MyBaseCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , GTMRefreshHeaderDelegate , GTMLoadMoreFooterDelegate{
    
    var jsonDataSource = [JSON]()
    var showNoDataCell = false
    var pageIndex = 0
    var pageSize = 10
    var isLoading = false
    var isLastPage = false
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if jsonDataSource.count == 0 {
            collectionView.registerNoDataCellView()
            if showNoDataCell{
                return 1
            }
            return 0
        }else{
            showNoDataCell = false
            return jsonDataSource.count
        }
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if showNoDataCell{
            return MyNoDataCellView()
        }
        
        let cell = UICollectionViewCell()
        
        
        return cell
        
    }
    
    
    
    public func refresh() {
        
    }
    
    func loadMore() {
        
    }
    
    ///初始化分页属性
    func initLimitPage(){
        pageIndex = 0
        isLoading = false
        isLastPage = false
        jsonDataSource = [JSON]()
    }
    
}
