//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit



class QQScanViewController: LBXScanViewController {
    
    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle:UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
// MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //返回按钮
    var btnBack:UIButton = UIButton()
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    //我的二维码
//    var btnMyQR:UIButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //需要识别后的图像
        setNeedCodeImage(true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
    

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawBottomItems()
    }
    
    
  
    override func handleCodeResult(_ arrayResult: [LBXScanResult]) {
        
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned!)
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        dismiss(animated: true, completion: {
            self.myClosure!(result.strScanned!)
        })
        


    }

    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame:CGRect( x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ) )
        
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        
        let size = CGSize(width: 65, height: 87);
        
        
        btnBack = UIButton(frame: CGRect(x: 20, y: 40, width: 40, height: 40))
        btnBack.bounds = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnBack.backgroundColor=UIColor.darkText
        btnBack.alpha=0.45
        btnBack.layer.cornerRadius=22
        btnBack.setImage(UIImage(named: "返回.png"), for: UIControlState())
        
        btnBack.addTarget(self, action: #selector(QQScanViewController.back), for: UIControlEvents.touchUpInside)
        
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState())
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        
//        self.btnPhoto = UIButton()
//        btnPhoto.bounds = btnFlash.bounds
//        btnPhoto.center = CGPointMake(CGRectGetWidth(bottomItemsView!.frame)/4, CGRectGetHeight(bottomItemsView!.frame)/2)
//        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), forState: UIControlState.Normal)
//        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), forState: UIControlState.Highlighted)
//        btnPhoto.addTarget(self, action: Selector("openPhotoAlbum"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
//        self.btnMyQR = UIButton()
//        btnMyQR.bounds = btnFlash.bounds;
//        btnMyQR.center = CGPointMake(CGRectGetWidth(bottomItemsView!.frame) * 3/4, CGRectGetHeight(bottomItemsView!.frame)/2);
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), forState: UIControlState.Normal)
//        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), forState: UIControlState.Highlighted)
//        btnMyQR.addTarget(self, action: #selector(QQScanViewController.myCode), forControlEvents: UIControlEvents.TouchUpInside)
        
        bottomItemsView?.addSubview(btnFlash)
//        bottomItemsView?.addSubview(btnPhoto)
//        bottomItemsView?.addSubview(btnMyQR)
        self.view .addSubview(bottomItemsView!)
        self.view.addSubview(btnBack)
        
    }
    
    //开关闪光灯
    func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControlState())
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState())
        }
    }
    
    func myCode()
    {
        let vc = MyCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    

}
