//
//  SettingsController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/27.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : MyBaseUIViewController{
    
    @IBOutlet weak var settingsCollection: UICollectionView!
    
    let settingsView = SettingsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "设置")
        
        settingsView.parentView = self
        settingsCollection.delegate = settingsView
        settingsCollection.dataSource = settingsView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //返回按钮
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //退出系统
    @IBAction func btn_settings_inside(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: LoginInfo.token.rawValue)
        r_token = ""
        myPresentView(self, viewName: "loginView")
    }

}
