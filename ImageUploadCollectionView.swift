//
//  ImageUploadCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/26.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//


import Foundation
import UIKit
import SwiftyJSON

class ImageUploadCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var parentView : AssistantController? = nil
    var images = [UIImage]()
    var willUploadImagesIndex = [Int]()
    let uploadImageMaxLenth = 1024 //kb
    var uploadImages = [String : UIImage]()
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return images.count + 1
        
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell = UICollectionViewCell()
        if indexPath.item > 0 {
            //显示图片
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c2", for: indexPath)
            let imgView = cell.viewWithTag(10001) as! UIImageView
            imgView.image = images[indexPath.item - 1]
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
            cell.backgroundColor = UIColor(hex: "f4f7fa")
        }
        
        return cell
        
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        parentView?.hiddenKeyBoard()
        
        if indexPath.item == 0 {
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
        }else{
            var isNotUploaded = false
            //遍历要上传图片的下标 匹配到cell的index 并删除
            var counter = 0
            for i in willUploadImagesIndex{
                if indexPath.item - 1 == i {
                    willUploadImagesIndex.remove(at: counter)
                    isNotUploaded = true
                    break;
                }
                counter += 1
            }
            if isNotUploaded{
                //删除图片
                images.remove(at: indexPath.item - 1)
            }else{
                myAlert(parentView!, message: "已上传的图片,暂时无法删除!")
            }
            parentView?.imageUploadCollection.reloadData()
        }
        
    }
    
    //计算大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 80, height: 80 )
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
        parentView?.imageUploadCollection.reloadData()
    }
    
    
}
