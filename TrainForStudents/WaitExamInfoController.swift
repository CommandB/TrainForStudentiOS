//
//  WaitExamInfoController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/26.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WaitExamInfoController : MyBaseUIViewController{

    @IBOutlet weak var btn_close: UIButton!
    
    var data = JSON.init([:])
//    var displayView : UIView? = nil
    
    override func viewDidLoad() {
        btn_close.layer.cornerRadius = 4
    }
    
    @IBAction func btn_close_inside(_ sender: UIButton) {
//        displayView?.isHidden = true
        view.isHidden = true
//        dismiss(animated: true, completion: nil)
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(sender)
//    }
    
}
