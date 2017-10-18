//
//  OnlineAskController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import BMPlayer
import NVActivityIndicatorView
import GTMRefresh

class OnlineAskController: MyBaseUIViewController {
    
    var videoInfo = JSON("")
    
    @IBOutlet weak var btn_mine: UIButton!
    
    @IBOutlet weak var btn_all: UIButton!
    
    @IBOutlet weak var questionTotal: UILabel!
    
    @IBOutlet weak var player: BMCustomPlayer!
    
    @IBOutlet weak var txt_askContnt: UITextField!
    
    //问题 collection
    @IBOutlet weak var onlineAskCollection: UICollectionView!
    
    let askView = OnlineAskCollectionView()
    var viewTitlte = "在线提问"
    var btn_toggle = true
    
    //按钮的集合
    var buttonGroup = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_askContnt.delegate = self
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.itemSize = CGSize(width: UIScreen.width , height: 130 )
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        
        askView.parentView = self
        onlineAskCollection.delegate = askView
        onlineAskCollection.dataSource = askView
        onlineAskCollection.collectionViewLayout = collectionLayout
        onlineAskCollection.gtm_addRefreshHeaderView( delegate: askView)
        onlineAskCollection.gtm_addLoadMoreFooterView(delegate: askView)
        
        let url = URL(string:SERVER_PORT + "../" + videoInfo["url"].stringValue)
        
        player.parentView = self
        player.markView = view.viewWithTag(20001)

        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let res1 = BMPlayerResourceDefinition(url: url!,
                                              definition: "标清")
        let asset = BMPlayerResource(name: videoInfo["title"].stringValue,
                                     definitions: [res1],
                                     cover: url)
        
        player.setVideo(resource: asset)

        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = videoInfo["title"].stringValue
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = "时长 \(videoInfo["howlong"].stringValue) 分钟"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //支持横屏
        appDelegate.blockRotation = true
        
        buttonGroup = [btn_mine , btn_all]
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: viewTitlte)
        MyNotificationUtil.addKeyBoardWillChangeNotification(self)
        getAllDataSource()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //释放视频资源
        player.playerLayer?.prepareToDeinit()
    }
    
    //返回
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //全部问题 按钮
    @IBAction func btn_all_inside(_ sender: UIButton) {
        initLimitPage()
        btn_toggle = true
        getAllDataSource()
    }
    
    //我的问题 按钮
    @IBAction func btn_mine_inside(_ sender: UIButton) {
        initLimitPage()
        btn_toggle = false
        getMineDataSource()
    }
    
    ///发布 按钮
    @IBAction func btn_submit_inside(_ sender: UIButton) {
        
        if txt_askContnt.text == nil || (txt_askContnt.text?.isEmpty)!{
            myAlert(self, message: "请输入需要发布的问题!")
            return
        }
        
        let url = SERVER_PORT+"rest/difficult/add.do"
        myPostRequest(url,["title":txt_askContnt.text! , "type":1 , "teachingid":videoInfo["teachingmaterialid"].stringValue ]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    self.txt_askContnt.text = ""
                    self.askView.refresh()
                    myAlert(self, message: "发布问题成功!")
                }else{
                    myAlert(self, message: "发布问题失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    //获取全部问题
    func getAllDataSource(){
        
        if askView.isLastPage{
            return
        }
        
        let url = SERVER_PORT+"rest/difficult/queryByTeachingMeterial.do"
        myPostRequest(url,["pageindex":askView.pageIndex * pageSize , "pagesize":pageSize , "teachingid" : videoInfo["teachingmaterialid"].stringValue]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if(arrayData.count>0){
                        self.askView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.askView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.onlineAskCollection.endRefreshing(isSuccess: true)
                    self.onlineAskCollection.endLoadMore(isNoMoreData: self.askView.isLastPage)
                    
                    self.onlineAskCollection.reloadData()
                    self.questionTotal.text = "问题(\(json["totalcount"].intValue))"
                }else{
                    self.onlineAskCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求全部列表失败!")
                }
                
                self.askView.pageIndex += 1    //页码增加
                
            case .failure(let error):
                self.onlineAskCollection.endRefreshing(isSuccess: false)
                print(error)
            }
            
        })
        
    }
    
    //获取我的提问
    func getMineDataSource(){
        
        if askView.isLastPage{
            return 
        }
        
        let url = SERVER_PORT+"rest/difficult/queryByTeachingMeterialAndMine.do"
        myPostRequest(url,["pageindex":askView.pageIndex * pageSize , "pagesize":pageSize , "teachingid" : videoInfo["teachingmaterialid"].stringValue]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    let arrayData = json["data"].arrayValue
                    //判断是否在最后一页
                    if arrayData.count >= self.pageSize{
                        self.askView.jsonDataSource += json["data"].arrayValue
                    }else{
                        self.askView.isLastPage = true
                    }
                    //修改上拉刷新和下拉加载的状态
                    self.onlineAskCollection.endRefreshing(isSuccess: true)
                    self.onlineAskCollection.endLoadMore(isNoMoreData: self.askView.isLastPage)
                    
                    self.onlineAskCollection.reloadData()
                    
                    self.questionTotal.text = "问题(\(json["totalcount"].intValue))"
                }else{
                    self.onlineAskCollection.endRefreshing(isSuccess: false)
                    myAlert(self, message: "请求我的问题列表失败!")
                }
                
                self.askView.pageIndex += 1    //页码增加
                
            case .failure(let err):
                print(err)
                
            }
        })
        
    }
    
    
}

extension OnlineAskController: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
