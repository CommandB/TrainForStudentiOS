//
//  MyNoDataCellView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//
//  一个用于没有数据是展示的cell

import Foundation
import UIKit

class MyNoDataCellView : UICollectionViewCell{
    
    static let identifier = "MyNoDataCellView"
    
    var cellContent = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellContent = UILabel(frame:frame)
        cellContent.backgroundColor = UIColor.clear
        cellContent.textAlignment = .center
        cellContent.text = "没有数据啦!"
        cellContent.font = UIFont.systemFont(ofSize: 14)
        cellContent.textColor = UIColor.gray
        self.addSubview(cellContent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UICollectionView{
    
    static let noDataCellViewIdentifier = MyNoDataCellView.identifier
    
    ///注册这个cell
    func registerNoDataCellView(){
        register(MyNoDataCellView.self, forCellWithReuseIdentifier: MyNoDataCellView.identifier)
    }
    
    
    
}
