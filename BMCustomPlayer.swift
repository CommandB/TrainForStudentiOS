//
//  BMCustomPlayer.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/6/9.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import BMPlayer

class BMCustomPlayer : BMPlayer{
    
    var parentView : UIViewController? = nil
    var markView : UIView? = nil
    class override func storyBoardCustomControl() -> BMPlayerControlView? {
        //return BMPlayerCustomControlView()
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        let vc = BMPlayerControlView()
        vc.isMaskShowing = false
        return vc
    }
    
    override func updateUI(_ isFullScreen: Bool) {
        if isFullScreen{
            snp.makeConstraints { (make) in
                make.top.equalTo((parentView?.view.snp.top)!)
                make.left.equalTo((parentView?.view.snp.left)!)
                make.right.equalTo((parentView?.view.snp.right)!)
                make.height.equalTo((parentView?.view.snp.width)!).multipliedBy(9.0/16.0)
            }
        }else{
            snp.removeConstraints()
            
            snp.makeConstraints { (make) in
                make.top.equalTo((markView?.snp.top)!)
                make.left.equalTo((markView?.snp.left)!)
                make.right.equalTo((markView?.snp.right)!)
                make.height.equalTo((markView?.snp.height)!)
            }
            
        }

    }
    
}

