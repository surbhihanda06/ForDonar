//
//  TopicListController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 28/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol TopicListControllerDalegate: class {
    func fetchTopicDetails(topic: SubTopicList)
}

class TopicListController: UIViewController {
    @IBOutlet weak var tblTopic: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    var topicSelected : SubTopicList!
    var tempTopicSelected : SubTopicList!
    var subTopic = [SubTopicList]()
    var subTopicId = 0
    var fromHome = ""
    
    weak var delegate: TopicListControllerDalegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblTopic.delegate=self
        tblTopic.dataSource=self
        tblTopic.register(UINib(nibName: "ChooseTopicCell", bundle: Bundle.main), forCellReuseIdentifier: "ChooseTopicCell")
        tblTopic.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tblTopic.tableFooterView = UIView()

        
        var topicNameToShow = "Topic"
        if let topicsel = topicSelected
        {
            topicNameToShow = topicsel.name
        }
        if fromHome == "true"
        {
            self.lblTitle.isHidden = true
        }
        else
        {
            self.lblTitle.isHidden = false
        }
        self.lblTitle.text = topicNameToShow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
        
    // MARK: - Service Call
    func getTopicList(topicId: Int)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/%d",topicId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let dictTopicList = response.topicList, dictTopicList.subTopic.count > 0
                {
                    let moveViewController = TopicListController()
                    moveViewController.subTopic = dictTopicList.subTopic
                    moveViewController.topicSelected = self.tempTopicSelected
                    moveViewController.fromHome = self.fromHome
                    self.navigationController?.pushViewController(moveViewController, animated: true)
                }
                else
                {
                    if self.fromHome == "true"
                    {
                        let moveViewController = CategoryWiseListController()
                        moveViewController.subTopicId = self.subTopicId
                        self.navigationController?.pushViewController(moveViewController, animated: true)
                    }
                    else
                    {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        var topicVC: TopicListController!
                        for controller:UIViewController in viewControllers.reversed()
                        {
                            if controller.isKind(of: TopicListController.self) {
                                topicVC = controller as! TopicListController
                            }
                            
                            if controller.isKind(of: CreateCampaignViewController.self) {
                                print("topicVC",topicVC)
                                if let topic = topicVC
                                {
                                    topic.delegate?.fetchTopicDetails(topic: self.tempTopicSelected)
                                }
                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    
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
                        let msg:String = err.description
                        Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: msg)
                    }
                    
                }
            }
        })
    }
}
// MARK: TableViewDelegate
extension TopicListController: UITableViewDelegate, UITableViewDataSource
{
    /*func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if subTopic.count > 0
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Topic, Please try again"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTopic.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ChooseTopicCell", for: indexPath) as! ChooseTopicCell
        let subTopicDetails = subTopic[indexPath.row]
        cell.lblName.text = subTopicDetails.name
        cell.lblName.textAlignment = .left
        cell.lblName.textColor = UIColor.darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let subTopicDetails = subTopic[indexPath.row]
        tempTopicSelected = subTopicDetails
        self.getTopicList(topicId: subTopicDetails.id)
        subTopicId = subTopicDetails.parentId
    }
}
