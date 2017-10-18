//
//  myCollectionBaseFooter.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

class MyCollectionBaseFooter : UICollectionReusableView{
    
    static let identifier = "MyCollectionBaseFooter"
    var lbl_content : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lbl_content = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(lbl_content)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
