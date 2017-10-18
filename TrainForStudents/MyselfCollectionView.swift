//
//  MyselfCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/5.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyselfCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    let uploadImageMaxLenth = 10240 //kb
    
    var parentView : MyselfController? = nil
    
    var jsonDataSource = JSON.init([:])
    
    var avatarImage = UIImage()
    
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cellName = "c\(indexPath.item)"
        let json = jsonDataSource
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        
        switch indexPath.item {
        case 0:
            var lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = json["personname"].stringValue
            lbl = cell.viewWithTag(10002) as! UILabel
            lbl.text = json["grade_show"].stringValue
            lbl = cell.viewWithTag(20001) as! UILabel
            lbl.text = json["phoneno"].stringValue
            lbl = cell.viewWithTag(30001) as! UILabel
            lbl.text = json["subjectname"].stringValue
            lbl = cell.viewWithTag(30002) as! UILabel
            lbl.text = json["jobnum"].stringValue
            lbl = cell.viewWithTag(40001) as! UILabel
            lbl.text = json["studentstate_show"].stringValue
            lbl = cell.viewWithTag(40002) as! UILabel
            lbl.text = json["degree_show"].stringValue
            
            let btn = cell.viewWithTag(10010) as! UIButton
//            btn.setImage(avatarImage, for: .normal)
            do{
                if !json["photourl"].stringValue.isEmpty{
//                    try avatarImage = UIImage(data: Data.init(contentsOf: URL(string: json["photourl"].stringValue)!))!
                    btn.sd_setBackgroundImage(with: URL(string: json["photourl"].stringValue)!, for: .normal)
                }
            }catch{
            
            }
            
            //头像
//            btn.setBackgroundImage(avatarImage, for: .normal)
            
            btn.addTarget(self, action: #selector(btn_avatar_inside), for: .touchUpInside)
            
            //下面4个功能按钮
            let btns = [
                cell.viewWithTag(50001) as! UIButton,
                cell.viewWithTag(50002) as! UIButton,
                cell.viewWithTag(50003) as! UIButton,
                cell.viewWithTag(50004) as! UIButton
            ]
            
            for btn in btns{
                //绑定事件
                btn.addTarget(self, action: #selector(myTools), for: .touchUpInside)
            }
            
            break
        case 1:
            var lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = json["teachername"].stringValue
            lbl = cell.viewWithTag(10002) as! UILabel
            lbl.text = json["teacherphoneno"].stringValue
            lbl = cell.viewWithTag(20001) as! UILabel
            lbl.text = json["secretaryname"].stringValue
            lbl = cell.viewWithTag(20002) as! UILabel
            lbl.text = json["secretaryphono"].stringValue
            lbl = cell.viewWithTag(30001) as! UILabel
            lbl.text = json["officename"].stringValue
            break
        case 2:
            let lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = json["unworkdays"].stringValue
            break
        case 3:
            parentView?.showImageView.isHidden = true
            break
        case 4:
            let lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = "\(json["evaluation_okratename"].doubleValue)%"
            break
        case 5:
            
            break
        default:
            break
        }
        
        
        
        return cell
    }
    
    //我的工具按钮点击事件
    func myTools(sender : UIButton){
        switch sender.tag {
        case 50001:
            //心愿单
            myPresentView(parentView!, viewName: "wishListView")
            break
        case 50002:
            //教材
            myPresentView(parentView!, viewName: "meterialListView")
            break
        case 50003:
            //疑难杂症
            myPresentView(parentView!, viewName: "difficultListView")
            break
        case 50004:
            //远程学习
            myAlert(self.parentView!, message: "暂未开放!")
            break
        default:
            break
        }
        print(sender.tag)
    }
    
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat(0)
        switch indexPath.item {
        case 0:
            height = 225
            break
        case 1:
            height = 125
            break
        case 2:
            height = 85
            break
        case 3:
            height = 85
            break
        case 4:
            height = 85
            break
//        case 5:
//            height = 110
//            break
        default:
            break
        }
        
        return CGSize(width: UIScreen.width , height: height )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 3:
            //我的二维码
            parentView?.showImageView.isHidden = false
        case 4:
            //评价
            myPresentView(parentView!, viewName: "myEvaluationListView")
        default:
            break
        }
    }
    
    func btn_avatar_inside(_ sender: UIButton) {
        //选择图片
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        let alertSheet = UIAlertController(title: "提示", message: "请选择照片", preferredStyle: .actionSheet)
        
        //注册"相册"按钮
        alertSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { action in
            
            self.parentView?.present(picker, animated: true, completion: nil)
            
        }))
        
        //注册"照相"按钮
        alertSheet.addAction(UIAlertAction(title: "照相", style: .default, handler: { action in
            
            if LBXPermissions.isGetPhotoPermission() {
                picker.sourceType = .camera
                
                self.parentView?.present(picker, animated: true, completion: nil)
                
            }else{
                myAlert(self.parentView!, message: "没有相机权限")
            }
            
        }))
        
        ///注册"取消"
        alertSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            
        }))
        
        self.parentView?.present(alertSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //压缩图片
        let after = image.compressImage(image, maxLength: uploadImageMaxLenth)
        image = UIImage(data: after!)!
        
        
        let url = SERVER_PORT + "rest/person/updateMyPhoto.do"
        //上传头像
        uploadImage(url, images: [arc4random().description : image], parameters: nil, completionHandler: {resp in
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    //成功后 重新加载个人信息collection
                    self.avatarImage = image
                    self.parentView?.selfCollection.reloadData()
                }else{
                    myAlert(self, message: "\(json["msg"].stringValue)")
                }
                
            case .failure(let error):
                print(error)
            }
        })
        
        parentView?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
