//
//  DirectoryController.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/16.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DirectoryController: UIViewController {
    
    @IBOutlet weak var directoryCollection: UICollectionView!
    
    var directoryView = DirectoryCollectionView()
    
    var presentedController : ExamViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        directoryView.parentView = self
        //questionView.jsonDataSource = question
        
        directoryCollection.delegate = directoryView
        directoryCollection.dataSource = directoryView
        
        directoryCollection.reloadData()
        
        //注册section Header
        directoryCollection.register(TitleReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
    }
    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
