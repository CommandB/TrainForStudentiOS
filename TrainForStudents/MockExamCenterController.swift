//
//  MockExamController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MockExamCenterController: MyBaseUIViewController {
    
    var titleBarText = "";
    
    @IBOutlet var btnArray: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(10001)
        let titleView = view.viewWithTag(20001) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: titleBarText)
        
        for btn in btnArray {
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 25, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_exam_inside(_ sender: UIButton) {
        
        if sender.tag != 10001{
            myAlert(self, message: "此功能暂未开放,尽请期待!")
        }else{
            let vc = getViewToStoryboard("examView") as! ExamViewController
            let url = SERVER_PORT + "rest/questions/queryExercisesQuestions.do"
            myPostRequest(url).responseJSON(completionHandler: { resp in
                switch  resp.result{
                case .success(let result):
                    let json = JSON(result)
                    if json["code"].intValue == 1 {
                        vc.exercises = json["data"].arrayValue
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        myAlert(self, message: json["msg"].stringValue)
                    }
                    
                case .failure(let error):
                    debugPrint(error)
                }
            })
        }
        
    }
    
    
    
}
