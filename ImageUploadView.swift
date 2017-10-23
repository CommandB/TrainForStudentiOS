//
//  DifficultReplyView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/20.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ImageUploadView :UIViewController , UITableViewDelegate , UITableViewDataSource, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var jsonDataSource = [JSON]()
    
    var parentView : AssistantController? = nil
    var images = [UIImage]()
    var willUploadImagesIndex = [Int]()
    let uploadImageMaxLenth = 1024 //kb
    var uploadImages = [String : UIImage]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return jsonDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellName = ""
        if indexPath.section == 0 {
            cellName = "c1"
            
            //let cell = tableView.dequeueReusableCell(withIdentifier: cellName)!
            let cell = (parentView?.tbl_imageUpload.dequeueReusableCell(withIdentifier: cellName))!
            let btn = cell.viewWithTag(10001) as! UIButton
            btn.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
            
            //
            let sbv = cell.subviews
            for v in sbv {
                v.removeFromSuperview()
            }
            cell.addSubview(btn)
            
            let btnWidth = btn.frame.width
            let space = CGFloat(55) //
            let prefix = CGFloat(15)
            var index = CGFloat(0)
            for image in images{
                let imageView = UIImageView(frame: btn.frame)
                imageView.frame.origin = CGPoint(x: space.adding(btnWidth).multiplied(by: index).adding(prefix), y: btn.frame.origin.y)
                imageView.image = image
                cell.addSubview(imageView)
                btn.frame.origin  = CGPoint(x: space.adding(btnWidth).multiplied(by: index.adding(1)).adding(prefix), y: btn.frame.origin.y)
                index.add(1)
            }
            
            return cell
        }else{
            cellName = "c2"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
            let data = jsonDataSource[indexPath.section - 1]
            var lbl = cell.viewWithTag(10001) as! UILabel
            lbl.text = data["context"].stringValue
            lbl = cell.viewWithTag(30001) as! UILabel
            lbl.text = data["createtime"].stringValue
            lbl = cell.viewWithTag(30002) as! UILabel
            lbl.text = data["personname"].stringValue
            
            var tag = 20001
            for url in data["url"].arrayValue{
                let imageView = cell.viewWithTag(tag) as! UIImageView
                do{
                    try imageView.image = UIImage(data: Data.init(contentsOf: URL(string: url.stringValue)!))!
                }catch{}
                tag += 1
            }
            return cell
        }
        
        
        
        
    }
    
    //cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }else{
            return 160
        }
    }
    
    //section的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
//    //section的样式
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 1))
        label.backgroundColor = tableView.backgroundColor
        return label
    }
    
    func selectImage(){
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
                myAlert(self, message: "没有相机权限")
            }
            
        }))
        
        ///注册"取消"
        alertSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            
        }))
        
        parentView?.present(alertSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let after = image.compressImage(image, maxLength: uploadImageMaxLenth)
        image = UIImage(data: after!)!
        
        //添加图片到数据源
        images.append(image)
        //记录用户选择的图片在数据源中的下标
        willUploadImagesIndex.append(images.count-1)
        parentView?.dismiss(animated: true, completion: nil)
        parentView?.tbl_imageUpload.reloadData()
    }
    
}
