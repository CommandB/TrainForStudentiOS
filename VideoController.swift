//
//  videoController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/9.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import BMPlayer
import NVActivityIndicatorView

class VideoController : MyBaseUIViewController {
    
    @IBOutlet weak var player: BMCustomPlayer!
    
    @IBOutlet weak var btn_exam: UIButton!
    
    var complate = "0"
    var taskId = ""
    var headData = JSON([:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222)
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务执行")
        player.parentView = self
        player.markView = view.viewWithTag(20001)
        
        if complate == "1"{
            btn_exam.isHidden = true
        }
        
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = headData["title"].stringValue
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = "时长\(headData["howlong"].stringValue)分钟"
        lbl = view.viewWithTag(30002) as! UILabel
        lbl.layer.cornerRadius = lbl.frame.width / 2
        lbl.clipsToBounds = true
        lbl = view.viewWithTag(30003) as! UILabel
        lbl.text = headData["question_num"].stringValue
        
        
//        let p = "http://192.168.1.106:8070/doctor_train/resources/video/1d95f88a-560b-427e-a83a-f86263c803e3.mp4"
        
        
//        player.backBlock = { [unowned self] (isFullScreen) in
//            if isFullScreen == true {
//                return
//            }
//            let _ = self.navigationController?.popViewController(animated: true)
//        }
        let url = URL(string: SERVER_PORT + "../" + headData["url"].stringValue)

        
        let res1 = BMPlayerResourceDefinition(url: url!,
                                              definition: "标清")
        let asset = BMPlayerResource(name: headData["title"].stringValue,
                                     definitions: [res1],
                                     cover: url)
        
        player.setVideo(resource: asset)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //支持横屏
        appDelegate.blockRotation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //释放视频资源
        player.playerLayer?.prepareToDeinit()
        
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //开始考试
    @IBAction func btn_exam_inside(_ sender: UIButton) {
        
        let vc = getViewToStoryboard("examView") as! ExamViewController
        vc.exerciseId = headData["exercisesid"].stringValue
        vc.taskId = taskId
        let url = SERVER_PORT + "rest/questions/queryExercisesQuestions.do"
        myPostRequest(url,["exercisesid":headData["exercisesid"].stringValue]).responseJSON(completionHandler: { resp in
            switch  resp.result{
            case .success(let result):
                let json = JSON(result)
                if json["code"].intValue == 1 {
                    //停止播放视频
                    self.player.pause()
                    vc.exercises = json["data"].arrayValue
                    vc.fromView = self
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
