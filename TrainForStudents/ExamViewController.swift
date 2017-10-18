//
//  ExamViewController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/12.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ExamViewController : MyBaseUIViewController{
    
    var taskId = ""
    var exerciseId = ""
    var isSimulation = false
    var exercises = [JSON]()    //考卷内容
    var currentType = JSON.init("") //当前题型
    var typeIndex = 0
    var questionIndex = 0
    var anwserDic = [String:Dictionary<String, String>]()
    
    let questionTypeTitle = "    %@【%@】 共%d道 每道%d分 共%d分"
    
    var fromView = UIViewController()
    
    @IBOutlet weak var lbl_questionType: UILabel!
    
    @IBOutlet weak var btn_prev: UIButton!
    
    @IBOutlet weak var btn_next: UIButton!
    
    @IBOutlet weak var btn_complete: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    
    
    //未完成 collection
    @IBOutlet weak var questionCollection: UICollectionView!
    
    var questionView = QuestionCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let questionlayout = UICollectionViewFlowLayout()
        questionlayout.minimumLineSpacing = 3
        questionlayout.minimumInteritemSpacing = 0
        
        questionCollection.collectionViewLayout = questionlayout
        
        resultView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentType = exercises[typeIndex]
        
        //初始化题型标题
        lbl_questionType.text = String(format: questionTypeTitle, arguments: [currentType["indexname"].stringValue,currentType["typename"].stringValue,currentType["count"].intValue,currentType["score"].intValue,currentType["count"].intValue * currentType["score"].intValue])
        
        btn_complete.isHidden = true
        btn_prev.isEnabled = !isFirstQuestion()
        btn_next.isEnabled = !isLastQuestion()
        if isLastQuestion() {
            btn_complete.isHidden = false
        }
        
        initCollection()
        
    }
    
    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //上一题
    @IBAction func btn_prev_inside(_ sender: UIButton) {
        questionIndex -= 1
        //如果已是当前题型最后一题 则切换到下一题型
        if questionIndex < 0{
            switchQuestionType(isNext: false)
        }
        //获取当前题目
        let question = (currentType["questions"].arrayValue)[questionIndex]
        //重新初始化展示题目的collection
        initCollection()
        //展示考题
        questionView.jsonDataSource = question
        questionCollection.reloadData()
        //设置按钮
        btn_next.isEnabled = !isLastQuestion()
        btn_prev.isEnabled = !isFirstQuestion()
        btn_complete.isHidden = true
    }
    
    //下一题
    @IBAction func btn_next_inside(_ sender: UIButton) {
        questionIndex += 1
        //如果已是当前题型最后一题 则切换到下一题型
        if questionIndex >= currentType["questions"].arrayValue.count{
            switchQuestionType(isNext: true)
        }
        //获取当前题目
        let question = (currentType["questions"].arrayValue)[questionIndex]
        //重新初始化展示题目的collection
        initCollection()
        //展示考题
        questionView.jsonDataSource = question
        questionCollection.reloadData()
        //设置按钮
        btn_next.isEnabled = !isLastQuestion()
        btn_prev.isEnabled = !isFirstQuestion()
        if isLastQuestion() {
            btn_complete.isHidden = false
        }
    }
    
    //完成
    @IBAction func btn_complete_inside(_ sender: UIButton) {
        
        var anwserList = [Dictionary<String, String>]()
        
        for (_,v) in anwserDic{
            anwserList.append(v)
        }
        
        let url = SERVER_PORT + "rest/exercises/commitPaper.do"
        myPostRequest(url,["commit_questions":anwserList , "exercisesid": exerciseId , "taskid" : taskId]).responseJSON(completionHandler: { resp in
            switch  resp.result{
            case .success(let result):
                let json = JSON(result)
                if json["code"].intValue == 1 {
                    self.resultView.isHidden = false
                    if json["ispass"].stringValue == "1"{
                        let imageView = self.resultView.viewWithTag(10001) as! UIImageView
                        imageView.image = UIImage(named: "通过了.png")
                        var lbl = self.resultView.viewWithTag(20001) as! UILabel
                        lbl.text = "恭喜你顺利通过抽考!"
                        lbl = self.resultView.viewWithTag(30001) as! UILabel
                        lbl.text = json["score"].stringValue
                        let btn = self.resultView.viewWithTag(40002) as! UIButton
                        btn.isHidden = false
                        if self.isSimulation{   //模拟考和抽考区分处理
                            //btn.setTitle("返回", for: .normal)
                        }
                        
                    }else{
                        let imageView = self.resultView.viewWithTag(10001) as! UIImageView
                        imageView.image = UIImage(named: "没通过.png")
                        var lbl = self.resultView.viewWithTag(20001) as! UILabel
                        lbl.text = "考试不合格!"
                        lbl = self.resultView.viewWithTag(30001) as! UILabel
                        lbl.text = json["score"].stringValue
                        if self.isSimulation{   //模拟考和抽考区分处理
                            let btn = self.resultView.viewWithTag(40002) as! UIButton
                            btn.isHidden = false
                            //btn.setTitle("返回", for: .normal)
                        }else{
                            var btn = self.resultView.viewWithTag(40001) as! UIButton
                            btn.isHidden = false
                            btn = self.resultView.viewWithTag(40003) as! UIButton
                            btn.isHidden = false
                        }
                        
                    }
                }else{
                    myAlert(self, message: json["msg"].stringValue)
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        })
        
    }
    
    
    //目录
    @IBAction func btn_directory_inside(_ sender: UIButton) {
        let vc = getViewToStoryboard("directoryView") as! DirectoryController
        vc.directoryView.jsonDataSource = exercises
        vc.presentedController = self
        present(vc, animated: true, completion: nil)
    }
    
    //返回任务中心
    @IBAction func btn_toTaskCenter_inside(_ sender: UIButton) {
        
        //置顶tabBar显示任务中心
        let app = (UIApplication.shared.delegate) as! AppDelegate
        let tabBar = (app.window?.rootViewController) as! UITabBarController
        tabBar.selectedIndex = 0
        
        var root = presentingViewController
        while let parent = root?.presentingViewController{
            root = parent
        }
        root?.dismiss(animated: true, completion: nil)
    }
    
    //返回视频中心
    @IBAction func btn_toVideo_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    ///初始化展示题目的collection
    func initCollection(){
        //获取当前题目
        let question = (currentType["questions"].arrayValue)[questionIndex]
        
        if question["type"].stringValue == "0"{   //单选题
            questionView = RadioCollectionView()
        }else if question["type"].stringValue == "2"{     //多选题
            questionView = CheckboxCollectionView()
        }else if question["type"].stringValue == "3"{     //配伍题
            questionView = PeiwuCollectionView()
        }else if question["type"].stringValue == "4"{   //简答题
            questionView = ShortAnswerCollectionView()
        }else if question["type"].stringValue == "6"{   //名词解释
            questionView = ShortAnswerCollectionView()
        }else if question["type"].stringValue == "8"{   //病例题
            questionView = RecordsCollectionView()
        }else if question["type"].stringValue == "9"{   //论述题
            questionView = ShortAnswerCollectionView()
        }
        
        questionView.myCollection = questionCollection
        questionView.parentView = self
        questionView.jsonDataSource = question
        questionView.cellTotal = getCellTotalForQuestion(json: question)
        
        questionCollection.delegate = questionView
        questionCollection.dataSource = questionView
        
    }
    
    
    ///根据题目计算collection需要显示几个cell
    func getCellTotalForQuestion(json : JSON) -> Int{
        
        if json["type"].stringValue == "0"{ //单选题
            return json["answers"].arrayValue.count + 1
        }else if json["type"].stringValue == "2"{ //多选题
            return json["answers"].arrayValue.count + 1
        }else if json["type"].stringValue == "3"{ //配伍题
            return json["sub_questions"].arrayValue.count + json["up_answers"].arrayValue.count
        }else if json["type"].stringValue == "4"{   //简答题
            return 2
        }else if json["type"].stringValue == "6"{ //名词解释
            return 2
        }else if json["type"].stringValue == "8"{ //病例题
            var total = 1
            let subQ = json["sub_questions"].arrayValue
            
            for json in subQ {
                total += json["answers"].arrayValue.count
            }
            total += subQ.count
            return total
        }else if json["type"].stringValue == "9"{ //论述题
            return 2
        }
        
        return 0
    }
    
    ///切换题型
    func switchQuestionType(isNext : Bool){
        
        if isNext{
            typeIndex += 1
            //获取题型
            currentType = exercises[typeIndex]
            //初始化题目索引
            questionIndex = 0
        }else{
            typeIndex -= 1
            //获取题型
            currentType = exercises[typeIndex]
            //初始化题目索引
            questionIndex = currentType["questions"].arrayValue.count - 1
        }
        
        
        //初始化题型标题
        lbl_questionType.text = String(format: questionTypeTitle, arguments: [currentType["indexname"].stringValue,currentType["typename"].stringValue,currentType["count"].intValue,currentType["score"].intValue,currentType["count"].intValue * currentType["score"].intValue])
        
        btn_prev.isEnabled = !isFirstQuestion()
        btn_next.isEnabled = !isLastQuestion()
        
    }
    
    ///判断当前是否第一题
    func isFirstQuestion() -> Bool{
        if typeIndex == 0 && questionIndex == 0 {
            return true
        }
        return false
    }
    
    ///判断当前是否最后一题
    func isLastQuestion() -> Bool{
        if (exercises.count - 1) == typeIndex{
            if (currentType["questions"].arrayValue.count - 1) == questionIndex{
                return true
            }
        }
        return false
    }
    
}
