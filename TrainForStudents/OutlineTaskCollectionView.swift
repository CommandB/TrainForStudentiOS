//
//  OutlineTaskCollectionView.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/7/18.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OutlineTaskCollectionView : UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    var parentView : TurnDetailController? = nil
    var outlineData = [JSON]()
    var selectedIndexPath = IndexPath.init()
    var isFirstLoad = false
    let itemWidth = UIScreen.width
    let itemSpcaing = CGFloat(15)
    
    //设置collectionView的分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //设置每个分区元素的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return outlineData.count
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c1", for: indexPath)
            let json = outlineData[indexPath.item]
            var lbl = cell.viewWithTag(10001) as? UILabel
            lbl?.text = json["roundsubjectname"].stringValue
            lbl = cell.viewWithTag(10002) as? UILabel
            lbl?.text = "需轮转\(json["monthnum"].stringValue)个月"
            
            
            var previousItemY = CGFloat(41)
            var previousItemHeight = CGFloat(0)
            let requireList = json["infolist"].arrayValue

            for rJson in requireList {
                
                let x = CGFloat(0)
                var y = CGFloat(0)
                var itemHeight = CGFloat(0)
                
                let v = Bundle.main.loadNibNamed("OutlineItem", owner: nil, options: nil)?.first as! OutlineItem
                
                
                //计算出内容的高度
                let contentText = rJson["outlineitemname"].stringValue
                //获取行数
                v.lbl_content.numberOfLines = contentText.getLineNumberForUILabel(v.lbl_content)
                //单行的高度
                let lineHeight = contentText.getHeight(font: v.lbl_content.font)
                //计算label的高度
                let contentHeight = lineHeight.multiplied(by: CGFloat(v.lbl_content.numberOfLines))
                //设置label的高度
                v.lbl_content.frame.size = CGSize(width: v.lbl_content.frame.width, height: contentHeight)
                
                
                
                v.lbl_content.text = contentText
                v.lbl_complate.text = rJson["completenum"].stringValue
                v.lbl_total.text = rJson["requirednum"].stringValue
                v.btn_action.restorationIdentifier = rJson["outlineid"].stringValue
                v.btn_action.addTarget(self, action: #selector(btn_action_inside), for: .touchUpInside)
                
                var frame = CGRect()
                //y轴 = 上一个元素的Y轴坐标 + 上一个元素的高度
                y = previousItemHeight.adding(previousItemY)
                //item高度 = 内容高度 + 间距
                itemHeight = contentHeight.adding(itemSpcaing)
                
                frame.origin = CGPoint(x: x, y: y)
                frame.size = CGSize(width: itemWidth, height: itemHeight)
                v.frame = frame
                
                //更新高度总和
                //totalHeight = totalHeight.adding(itemHeight)
                //更新上一个元素的高度
                previousItemHeight = itemHeight
                //更新上一个元素的Y轴坐标
                previousItemY = y
                
                cell.addSubview(v)
                
            }

        }
        
        return cell
        
    }
    
    //设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 && isFirstLoad{
            isFirstLoad = false
            selectedIndexPath = indexPath
        }
        
        var height = CGFloat(40)
        //如果此cell被用户选择则展开大纲
        if indexPath == selectedIndexPath{
            
            
            //height.add(cellItemsHeightTotal[indexPath.item])
            
            let json = outlineData[indexPath.item]
            let requireList = json["infolist"].arrayValue
            var total = CGFloat(0)
            for rJson in requireList {
                
                let v = Bundle.main.loadNibNamed("OutlineItem", owner: nil, options: nil)?.first as! OutlineItem
                
                //计算出内容的高度
                let contentText = rJson["outlineitemname"].stringValue
                //获取行数
                v.lbl_content.numberOfLines = contentText.getLineNumberForUILabel(v.lbl_content)
                //单行的高度
                let lineHeight = contentText.getHeight(font: v.lbl_content.font)
                //计算label的高度
                let contentHeight = lineHeight.multiplied(by: CGFloat(v.lbl_content.numberOfLines))
                
                //item高度 = 内容高度 + 间距
                let itemHeight = contentHeight.adding(itemSpcaing)
                
                total.add(itemHeight)
                
            }
            height.add(total)
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //判断用户点击的是否是大纲
        if indexPath.section == 0 {
            //判断是展开还是收缩
            if selectedIndexPath == indexPath{
                selectedIndexPath = IndexPath()
            }else{
                selectedIndexPath = indexPath
            }
            collectionView.reloadData()
        }
        
    }
    
    func btn_action_inside(sender : UIButton){
        let outlineId = sender.restorationIdentifier!
        let taskId = parentView?.ttc.selectedTaskId
        
        let outlineText = (sender.superview?.viewWithTag(10001) as! UILabel).text!
        myConfirm(parentView!, message: "是否将任务挂载到\(outlineText)" , okTitle: "是" , okHandler : { action in
            
            self.parentView?.alertOutlineView.isHidden = true
            let url = SERVER_PORT + "rest/outline/mountTaskToOutline.do"
            myPostRequest(url,["outlineid":outlineId , "taskid":taskId!]).responseJSON(completionHandler: {resp in
                
                switch resp.result{
                case .success(let responseJson):
                    
                    let json = JSON(responseJson)
                    if json["code"].stringValue == "1"{
                        self.parentView?.alertOutlineView.isHidden = true
                        self.parentView?.refresh()
                    }else{
                        myAlert(self.parentView!, message: json["msg"].stringValue)
                    }
                    print(json.description)
                case .failure(let error):
                    print(error)
                }
                
            })
        })
        
        
    }
    
}
