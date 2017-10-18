//
//  OtherFilesController.swift
//  TrainForStudents
//
//  Created by 陈海峰 on 2017/10/13.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import QuickLook
class OtherFilesController: MyBaseUIViewController,UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate{
    var tableView = UITableView()
    var taskId = ""
    var dataSource:[JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222) as! UILabel
        
        super.setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "附件清单")
        self.initView()
        self.getFilesData()
    }

    func initView() {
        self.tableView.frame = CGRect.init(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        let nib = UINib.init(nibName: "OtherFilesCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "OtherFilesCell")
    }
    
    //获取我的信息
    func getFilesData(){
        let url = SERVER_PORT+"/rest/task/queryPCTaskResultUpload.do"
        myPostRequest(url,["taskid":taskId]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json=JSON(responseJson)
                if json["code"].stringValue == "1"{
                    if json["data"].arrayValue.count == 0{
                        return
                    }
                    self.dataSource = (json["data"].arrayValue.first?["url"].arrayValue)!
                    self.tableView.reloadData()
                }else{
                    myAlert(self, message: "请求失败!")
                }
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherFilesCell", for: indexPath) as! OtherFilesCell
        
        cell.titleLabel.text = dataSource[indexPath.section]["reffilename"].stringValue
        cell.timeLabel.text = dataSource[indexPath.section]["createtime"].stringValue
        cell.personName.text = dataSource[indexPath.section]["personname"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(self.dataSource[indexPath.section]["reffilename"].stringValue)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //开始下载
        Alamofire.download(dataSource[indexPath.section]["url"].stringValue, to: destination)
            .response { response in
                print(response)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(self.dataSource[indexPath.section]["reffilename"].stringValue)
                self.openFile(fileURL)
                
                
//                if let imagePath = response.destinationURL?.path {
//                    let image = UIImage(contentsOfFile: imagePath)
//                }
        }
    }
    
    func openFile(_ filePath: URL) {
        let _docController = UIDocumentInteractionController.init(url: filePath)
        _docController.delegate = self
//        _docController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
        _docController.presentPreview(animated: true)
        }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
