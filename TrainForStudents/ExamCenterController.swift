//
//  SecondViewController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExamCenterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_start_inside(_ sender: UIButton) {
        
        let vc = getViewToStoryboard("examView") as! ExamViewController
        let url = "http://192.168.1.106:8070/doctor_train/rest/questions/queryExercisesQuestions.do"
        myPostRequest(url,["exercisesid":"46"]).responseJSON(completionHandler: { resp in
            switch  resp.result{
            case .success(let result):
                let json = JSON(result)
                if json["code"].intValue == 1 {
                    vc.exercises = json["data"].arrayValue
                    self.present(vc, animated: true, completion: nil)
                }

            case .failure(let error):
                debugPrint(error)
            }
        })
        
    }

}

