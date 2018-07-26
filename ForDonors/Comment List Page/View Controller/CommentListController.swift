//
//  CommentListController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentListController: UIViewController {
    
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoComments: UILabel!
    var strPurpose = ""
    var allList: NSMutableArray = NSMutableArray()
    var campaignId: Int!
    
    var arrComment = [CommentDetails]()
    var arrUpdate = [UpdateDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblVwList.register(UINib(nibName: "CommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCell")
        
        tblVwList.register(UINib(nibName: "UpdateCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdateCell")
        
        tblVwList.estimatedRowHeight = UITableViewAutomaticDimension
        tblVwList.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if strPurpose == "Comment"
        {
            lblTitle.text = "Comment".localized
            AllCommentListCall(campaignId: campaignId)
        }
        else
        {
            lblTitle.text = "Update".localized
            AllUpdateListCall(campaignId: campaignId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Service Call
    
    func AllUpdateListCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/53675/update?sortBy=createdDate&direction=DESC&size=10&page=0
        
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/campaign/\(campaignId)/update?sortBy=createdDate&size=%d&page=%d&order=DESC", PER_PAGE_CONTENT,PAGE_NUMBER(total: arrUpdate.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UpdateListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.arrUpdate = myData.allUpdate
                self.tblVwList.reloadData()
                if self.arrUpdate.count > 0
                {
                    self.lblNoComments.isHidden = true
                }
                else
                {
                    self.lblNoComments.isHidden = false
                    self.lblNoComments.text = "No Comment"
                }
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    //print(err)
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                } else {
                    // other failures
                    
                    if let err = error as? DDSError
                    {
                        self.allList = NSMutableArray()
                        self.tblVwList.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
    func AllCommentListCall(campaignId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/53675/comment?sortBy=createdDate&direction=DESC&size=10&page=0
        
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/campaign/\(campaignId)/comment?sortBy=createdDate&size=%d&page=%d&order=DESC", PER_PAGE_CONTENT,PAGE_NUMBER(total: arrComment.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CommentListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                self.arrComment = myData.allComment
                self.tblVwList.reloadData()
                if self.arrComment.count > 0
                {
                    self.lblNoComments.isHidden = true
                }
                else
                {
                    self.lblNoComments.isHidden = false
                    self.lblNoComments.text = "No Update"
                }
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    //print(err)
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                } else {
                    // other failures
                    
                    if let err = error as? DDSError
                    {
                        self.allList = NSMutableArray()
                        self.tblVwList.reloadData()
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension CommentListController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if strPurpose == "Comment"
        {
            return arrComment.count
        }
        else
        {
            return arrUpdate.count
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if strPurpose == "Comment"
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 80.0
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if strPurpose == "Comment"
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.imgVwUser.layer.masksToBounds = true
            cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
            
            let commentDetails = self.arrComment[indexPath.row]
            let firstName = commentDetails.posterFirstName
            let lastName = commentDetails.posterLastName
            cell.lblName.text = firstName! + " " + lastName!
            cell.tvText.text = commentDetails.message
            
            let date = Date(timeIntervalSince1970: commentDetails.createdDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            
            //cell.lblTyme.text = dateFormatter.string(from: date)
            cell.lblTime.text = dateFormatter.string(from: date)
            
//            let date = commentDetails.createdDate
//            let dateFormat = DateFormatter()
//            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:sssZ"
//            let getDate = dateFormat.date(from: date!)
//            print("getDate", getDate)
            
            return cell
        }
        else
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell
            
            let updateDetails = self.arrUpdate[indexPath.row]
            let firstName = updateDetails.posterFirstName
            let lastName = updateDetails.posterLastName
            cell.lblTitle.text = firstName! + " " + lastName!
            cell.tvText.text = updateDetails.message
            
            let date = Date(timeIntervalSince1970: updateDetails.createdDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            cell.lblTime.text = dateFormatter.string(from: date)
            
            //cell.lblTime.text = updateDetails.createdDate
            
            return cell
        }
    }
    
}
