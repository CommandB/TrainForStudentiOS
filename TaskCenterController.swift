//
//  TaskCenterController.swift
//  TrainForTeacher
//
//  Created by 黄玮晟 on 2017/5/31.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import GTMRefresh

class TaskCenterController: MyBaseUIViewController , AVCaptureMetadataOutputObjectsDelegate  {
    
    @IBOutlet weak var lbl_markLine: UILabel!
    
    @IBOutlet weak var btn_undone: UIButton!
    
    @IBOutlet weak var btn_over: UIButton!
    
    @IBOutlet weak var btn_scanner: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btn_space: UIButton!
    
    @IBOutlet weak var txt_s_title: UITextField!
    
    @IBOutlet weak var txt_s_date: TextFieldForNoMenu!
    
    @IBOutlet weak var btn_s_online: UIButton!
    
    @IBOutlet weak var btn_s_rounds: UIButton!
    
    
    //未完成 collection
    @IBOutlet weak var undoneCollection: UICollectionView!
    
    let undoneView = UndoneCollectionView()
    
    
    @IBOutlet weak var overCollection: UICollectionView!
    
    let overView = OverCollectionView()
    
    //日期选择控件
    let datePicker = UIDatePicker()
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    var isOverTab = false
    
    var searchParam : [String:Any]? = nil
    
    func datePickerChange(picker :UIDatePicker){
        
        txt_s_date.text = DateUtil.dateToString(picker.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_s_online.layer.cornerRadius = 4
        btn_s_rounds.layer.cornerRadius = 4
        txt_s_date.inputView = datePicker
        txt_s_date.tintColor = UIColor.clear
        txt_s_date.delegate = self
        txt_s_date.restorationIdentifier = "txt_s_date"
        
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.addTarget(self, action: #selector(datePickerChange), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        
        btn_scanner.layer.cornerRadius = btn_scanner.frame.width/2
        
        undoneCollection.gtm_addRefreshHeaderView(delegate: undoneView)
        undoneCollection.gtm_addLoadMoreFooterView(delegate: undoneView)
        
        undoneCollection.registerNoDataCellView()
        undoneCollection.delegate = undoneView
        undoneCollection.dataSource = undoneView
        undoneView.parentView = self
        
        overCollection.registerNoDataCellView()
        overCollection.gtm_addRefreshHeaderView(delegate: overView)
        overCollection.gtm_addLoadMoreFooterView(delegate: overView)
        overCollection.delegate = overView
        overCollection.dataSource = overView
        overView.parentView = self
        
        undoneView.initLimitPage()
        overView.initLimitPage()
        getUndoneCollectionDatasource()
        getOverCollectionDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedTabBarIndex = 0
        
        //设置2个collection的位置
        undoneCollection.frame.origin = CGPoint(x: 0, y: 90)
        overCollection.frame.origin = CGPoint(x: 0-UIScreen.width, y: 90)
        //设置搜索的view
        containerView.frame.origin = CGPoint(x: UIScreen.width, y: 0)
        
        lbl_markLine.clipsToBounds = true
        lbl_markLine.layer.cornerRadius = 1
        buttonGroup = [btn_undone , btn_over]
        
        let barView = view.viewWithTag(10001)
        let titleView = view.viewWithTag(20001) as! UILabel
        let buttonBar = view.viewWithTag(30001) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView,buttonBar], titleIndex: 1,titleText: "任务中心")
        
        tabsTouchAnimation(sender: btn_undone)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == "txt_s_date"{
            txt_s_date.text = DateUtil.dateToString(datePicker.date)
        }
        return true
    }
    
    //未完成 按钮
    @IBAction func btn_undone_inside(_ sender: UIButton) {
        isOverTab = false
        searchParam = nil
        tabsTouchAnimation(sender: sender)
    }
    
    //已结束 按钮
    @IBAction func btn_over_inside(_ sender: UIButton) {
        isOverTab = true
        searchParam = nil
        tabsTouchAnimation(sender: sender)
    }
    
    //搜索view空白处
    @IBAction func btn_space_inside(_ sender: UIButton) {
        //txt_s_date.endEditing(true)
        hiddenKeyBoard()
        searchParam = nil
        //动画开始
//        UIView.beginAnimations(nil, context: nil)
        
        //self.btn_space.isHidden = true
        

        
        //滚动效果
//        containerView.frame = CGRect(origin: CGPoint(x:UIScreen.width,y:0), size: containerView.frame.size)
//        UIView.setAnimationCurve(.easeOut)
//        UIView.commitAnimations()
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.containerView.frame = CGRect(origin: CGPoint(x:UIScreen.width,y:0), size: self.containerView.frame.size)
            self.btn_space.isHidden = true
        }, completion: { finished in
            //print("oooooooooooooook")
        })
        
        

    }
    
    @IBAction func btn_s(_ sender: UIButton) {
        if sender.isSelected {
            sender.backgroundColor = UIColor(hex: "EBEBF1")
            sender.isSelected = false
            //            sender.setTitleColor(UIColor(hex:"3b454f"), for: .normal)
        }else{
            sender.backgroundColor = UIColor(hex: "69adf6")
            sender.tintColor = UIColor(hex: "69adf6")
            sender.isSelected = true
            //            sender.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    
    //弹出搜索层的按钮
    @IBAction func btn_search_inside(_ sender: UIButton) {
        
//        //动画开始
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.3)
//        
//        //滚动效果
//        containerView.frame = CGRect(origin: CGPoint(x:0,y:0), size: containerView.frame.size)
//        UIView.setAnimationCurve(.easeOut)
//        UIView.commitAnimations()
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.containerView.frame = CGRect(origin: CGPoint(x:0,y:0), size: self.containerView.frame.size)
        }, completion: { finished in
            self.btn_space.isHidden = false
        })
        
    }
    
    //点击执行搜索
    @IBAction func btn_searchAction_inside(_ sender: UIButton) {
        
        //动画开始
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        //滚动效果
        containerView.frame = CGRect(origin: CGPoint(x:UIScreen.width,y:0), size: containerView.frame.size)
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
        searchParam = [String:Any]()
        searchParam?["title"] = txt_s_title.text
        searchParam?["starttime"] = txt_s_date.text
        if btn_s_online.isSelected{
            searchParam?["type"] = 2
        }
        
        if btn_s_rounds.isSelected{
            //            param["type"] = 1
        }
        
        
        if isOverTab{
            overView.initLimitPage()
            getOverCollectionDatasource()
            
        }else{
            undoneView.initLimitPage()
            getUndoneCollectionDatasource()
        }
        
    }
    
    //清空
    @IBAction func btn_clear_inside(_ sender: UIButton) {
        
        btn_s_rounds.backgroundColor = UIColor(hex: "EBEBF1")
        btn_s_rounds.setTitleColor(UIColor(hex:"3b454f"), for: .normal)
        btn_s_rounds.isSelected = false
        btn_s_online.backgroundColor = UIColor(hex: "EBEBF1")
        btn_s_online.setTitleColor(UIColor(hex:"3b454f"), for: .normal)
        btn_s_online.isSelected = false
        txt_s_date.text = ""
        txt_s_title.text = ""
        searchParam = nil
    }
    
    
    //扫一扫
    @IBAction func btn_scanner_inside(_ sender: UIButton) {
        
//        let vc = QQScanViewController();
//        var style = LBXScanViewStyle()
//        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
//        vc.scanStyle = style
//        vc.initResultClosure(myClosure)
//        present(vc, animated: true, completion: nil)
        
//        let scannerView = getViewToStoryboard("scannerView") as! ScannerViewController
//        scannerView.myClosure = myClosure
//        present(scannerView, animated: true, completion: nil)
        
        
        
    }
    
    
    //获取未完成的任务
    func getUndoneCollectionDatasource(){
        
        if undoneView.isLastPage{
            return 
        }
        
        if searchParam == nil{
            searchParam = [String:Any]()
            
        }
        searchParam?["pagesize"] = pageSize
        searchParam?["pageindex"] = undoneView.pageIndex * pageSize
        searchParam?["student_state"] = "0"
        
        let url = SERVER_PORT+"rest/task/query.do"
        myPostRequest(url,searchParam).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if arrayData.count < self.pageSize{
                        self.undoneView.isLastPage = true
                    }
                    self.undoneView.jsonDataSource += arrayData
                    
                    //判断是否没有数据
                    if self.undoneView.jsonDataSource.count == 0{
                        self.undoneView.showNoDataCell = true
                    }
                    
                    //修改上拉刷新和下拉加载的状态
                    self.undoneCollection.endRefreshing(isSuccess: true)
                    self.undoneCollection.endLoadMore(isNoMoreData: self.undoneView.isLastPage)
                    
                    self.undoneCollection.reloadData()
                }else{
                    self.undoneCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求未完成任务列表失败!")
                }
                self.undoneView.pageIndex += 1    //页码增加
            case .failure(let error):
                self.undoneCollection.endRefreshing(isSuccess: false)
                print(error)
            }
            
        })
        
    }
    
    //获取已完成的任务
    func getOverCollectionDatasource(){
        
        if overView.isLastPage{
            return
        }
        
        if searchParam == nil{
            searchParam = [String:Any]()
        }
        
        searchParam?["pagesize"] = pageSize
        searchParam?["pageindex"] = overView.pageIndex * pageSize
        searchParam?["student_state"] = "1"
        
        let url = SERVER_PORT+"rest/task/query.do"
        myPostRequest(url,searchParam).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if arrayData.count < self.pageSize{
                        self.overView.isLastPage = true
                    }
                    self.overView.jsonDataSource += arrayData
                    
                    //判断是否没有数据
                    if self.overView.jsonDataSource.count == 0{
                        self.overView.showNoDataCell = true
                    }
                    
                    //修改上拉刷新和下拉加载的状态
                    self.overCollection.endRefreshing(isSuccess: true)
                    self.overCollection.endLoadMore(isNoMoreData: self.overView.isLastPage)
                    
                    self.overCollection.reloadData()
                }else{
                    self.overCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求已完成任务列表失败!")
                }
                self.overView.pageIndex += 1    //页码增加
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    func tabsTouchAnimation( sender : UIButton){
        //-----------------计算 "下标线"label的动画参数
        
        for b in buttonGroup {
            if b == sender{
                b.setTitleColor(UIColor.white, for: .normal)
            }else{
                b.setTitleColor(UIColor.init(hex: "D6DADA"), for: .normal);
            }
        }
        
        let btn_x = sender.frame.origin.x                      //按钮x轴
        let btn_middle = sender.frame.size.width / 2           //按钮中线
        let lbl_half = lbl_markLine.frame.size.width / 2       //下标线的一半宽度
        //计算下标线的x轴位置
        let target_x = btn_x + btn_middle - lbl_half
        let target_y = lbl_markLine.frame.origin.y
        
        
        //动画开始
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        lbl_markLine.frame = CGRect(origin: CGPoint(x:target_x,y:target_y), size: lbl_markLine.frame.size)

        //滚动效果
        if sender.restorationIdentifier == "btn_over"{
            undoneCollection.frame = CGRect(origin: CGPoint(x:UIScreen.width*2 , y: undoneCollection.frame.origin.y) , size: undoneCollection.frame.size)
            overCollection.frame = CGRect(origin: CGPoint(x:0 , y: undoneCollection.frame.origin.y) , size: undoneCollection.frame.size)
        }else{
            undoneCollection.frame = CGRect(origin: CGPoint(x:0 , y: undoneCollection.frame.origin.y) , size: undoneCollection.frame.size)
            overCollection.frame = CGRect(origin: CGPoint(x:0 - UIScreen.width , y: undoneCollection.frame.origin.y) , size: undoneCollection.frame.size)
        }
        UIView.setAnimationCurve(.easeOut)
        UIView.commitAnimations()
    }
    
    
    
    func myClosure(_ val : String , vc : UIViewController){
        
        let url = SERVER_PORT+"rest/taskSignResult/sign.do"
        myPostRequest(url,["taskid":val]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    myAlert(vc, title: "签到", message: json["msg"].stringValue, handler: { action in
                        vc.dismiss(animated: true, completion: nil)
                    })
                    
                }else{
                    myAlert(vc, message: json["msg"].stringValue , handler : { action in
                        vc.dismiss(animated: true, completion: nil)
                    })
                }
            case .failure(let error):
                print(error)
            }
            
        })

    }
    
    

}

