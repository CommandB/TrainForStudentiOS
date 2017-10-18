//
//  MyNotificationUtil.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

class MyNotificationUtil {
    
    ///给view增加一个监听键盘的事件
    ///当键盘出现时view的frame随键盘高度而改变
    static func addKeyBoardWillChangeNotification(_ viewController : UIViewController){
        
        //        NSNotificationCenter.defaultCenter().addObserver(viewController, selector: #selector(UIViewController.keyboardWillChange(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(viewController, selector: #selector(UIViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(viewController, selector: #selector(UIViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    
}

extension UIViewController {
    // 键盘改变
    func keyboardWillChange(_ notification: Notification) {
        print("keyboard changing...")
        let vc = self
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(vc.view.frame)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
                
                if vc.view.frame.size.height >= UIScreen.height{
                    vc.view.frame.size.height = vc.view.frame.size.height-intersection.height
                }else{
                    vc.view.frame.size.height = UIScreen.height
                }
                
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(_ notification : Notification){
        
        let vc = self
        if let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
                
                vc.view.frame.size.height = UIScreen.height
                
            }, completion: nil)
        }
    }
    
    func keyboardWillShow(_ notification : Notification){
        
        let vc = self
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(vc.view.frame)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
                
                vc.view.frame.size.height = vc.view.frame.size.height-intersection.height
                
                
            }, completion: nil)
        }
    }
    
    
}
