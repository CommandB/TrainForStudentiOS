//
//  TaskDetail2Controller.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/1.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//


import Foundation
import UIKit
import SwiftyJSON
import SwiftCharts

class TaskDetail2Controller : MyBaseUIViewController{
    
    var headDataJson = JSON.init("")
    var teachingmaterialJson = JSON.init("")
    let c : CircleDataView = CircleDataView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222)
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务明细")
        var lbl = view.viewWithTag(80001)
        self.c.frame = (lbl?.frame)!
        //        self.c.backgroundColor = UIColor.white
        //        self.c.progress = 2/2
        //
        //        self.view.addSubview(self.c)
        
        lbl = view.viewWithTag(80002)
        lbl?.layer.cornerRadius = 4
        lbl?.clipsToBounds = true
        lbl = view.viewWithTag(80004)
        lbl?.layer.cornerRadius = 4
        lbl?.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = headDataJson["title"].stringValue
        lbl = view.viewWithTag(10002) as! UILabel
        lbl.text = headDataJson["student_state_show"].stringValue
        lbl = view.viewWithTag(20001) as! UILabel
        lbl.text = headDataJson["starttime_show"].stringValue
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = headDataJson["endtime_show"].stringValue
        lbl = view.viewWithTag(40001) as! UILabel
        lbl.text = headDataJson["credit"].stringValue
        lbl = view.viewWithTag(50001) as! UILabel
        lbl.text = headDataJson["creater"].stringValue
        lbl = view.viewWithTag(60001) as! UILabel
        lbl.text = headDataJson["note"].stringValue
        lbl = view.viewWithTag(70001) as! UILabel
        if headDataJson["isneedsign"].stringValue == "0"{
            lbl.text = "否"
        }else{
            lbl.text = "是"
        }
        lbl = view.viewWithTag(90001) as! UILabel
        lbl.text = headDataJson["tasktypeshow"].stringValue
        lbl = view.viewWithTag(100001) as! UILabel
        lbl.text = headDataJson["addressname"].stringValue
        
        let lateImageView = view.viewWithTag(101010) as! UIImageView
        var lateImage = UIImage()
        do{
            if let imageurl = URL(string: headDataJson["siginurl"].stringValue) {
                try lateImage = UIImage(data: Data.init(contentsOf: imageurl))!
            }
        }catch{
            
        }
        lateImageView.image = lateImage
        
        getTaskDetail()
    }
    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func otherFileAction(_ sender: UIButton) {
        let vc = getViewToStoryboard("OtherFilesController") as! OtherFilesController
        vc.taskId = headDataJson["taskid"].stringValue
        self.present(vc, animated: true, completion: nil)
    }

    
    //获取已完成的任务
    func getTaskDetail(){
        
        let url = SERVER_PORT+"rest/task/queryDetail.do"
        myPostRequest(url,["taskid":headDataJson["taskid"].stringValue , "task_type":headDataJson["task_type"].stringValue]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    let sc = json["student_count"]
                    
                    let num1 = sc["uncomplete_count"].intValue
                    let num2 = sc["complete_count"].intValue
                    
                    var lbl = self.view.viewWithTag(80006) as! UILabel
                    lbl.text = "\(num1)"
                    
                    lbl = self.view.viewWithTag(80003) as! UILabel
                    lbl.text = "\(num2 / (num1 + num2) * 100)% 已完成"
                    
                    lbl = self.view.viewWithTag(80005) as! UILabel
                    lbl.text = "\(num1 / (num1 + num2) * 100)% 未完成"
                    
                    self.c.backgroundColor = UIColor.white
                    self.c.progress = CGFloat(num1 / (num1 + num2))
                    self.view.addSubview(self.c)
                    
//                    let tm = json["teachingmaterial"]
//                    self.teachingmaterialJson = tm
//                    lbl = self.view.viewWithTag(90001) as! UILabel
//                    lbl.text = tm["title"].stringValue
//                    lbl = self.view.viewWithTag(100001) as! UILabel
//                    lbl.text = tm["dept_name"].stringValue
//                    lbl = self.view.viewWithTag(100002) as! UILabel
//                    lbl.text = tm["resource_type_show"].stringValue
//                    lbl = self.view.viewWithTag(110001) as! UILabel
//                    lbl.text = tm["teaching_createtime_show"].stringValue
//                    lbl = self.view.viewWithTag(110002) as! UILabel
//                    lbl.text = tm["howlong"].stringValue
//                    lbl = self.view.viewWithTag(120001) as! UILabel
//                    lbl.text = tm["aaaaa"].stringValue
//                    lbl = self.view.viewWithTag(120002) as! UILabel
//                    lbl.text = tm["aaaaa"].stringValue
//                    lbl = self.view.viewWithTag(130001) as! UILabel
//                    lbl.text = tm["description"].stringValue
                    
                }else{
                    myAlert(self, message: "请求未完成任务列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
}
