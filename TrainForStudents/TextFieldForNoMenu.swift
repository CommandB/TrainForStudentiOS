//
//  ddd.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

class  TextFieldForNoMenu: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        return false
        
    }
    
}
