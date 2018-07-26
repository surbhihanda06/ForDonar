//
//  MyContributionController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 08/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyContributionController: UIViewController {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVwContribution: UITableView!
    
    var arrCampaignList = [MyContributionDetails]()
    var arrAllList = [MyContributionDetails]()
    var arrContributeList = [ContributeDetails]()
    var heightArr :NSMutableArray = NSMutableArray()
    
    var isLast: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 12
        
        tblVwContribution.register(UINib(nibName: "MyContributionCell", bundle: Bundle.main), forCellReuseIdentifier: "MyContributionCell")
        tblVwContribution.estimatedRowHeight = 220
        tblVwContribution.rowHeight = UITableViewAutomaticDimension
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "My Contributions".localized
        MyContributionListCall()
    }
    
    

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterPressed(_ sender: Any) {
    }
    
    // MARK: - Service Call
    func MyContributionListCall()
    {
        //This is another change
        //Lets check teh change.
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/campaign/53450/mycontribution?sortBy=timestamp&direction=DESC&size=4&page=0
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let prmList:[String: Any] = [:] //\(String(format:"%d",userId))
        //MARK:- Static page count need to chagne later
        let apiName = String(format:"/user/\(userId)/mycontributions?sortBy=createdDate&size=%d&page=%d&direction=DESC", PER_PAGE_CONTENT,PAGE_NUMBER(total: arrCampaignList.count))
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyContributionListResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                self.isLast = (getMyData?.last)!
                if (getMyData?.allList.count)! > 0
                {
                    for item in (getMyData?.allList)!
                    {
                        self.arrCampaignList.append(item)
                    }
                }
                self.tblVwContribution.reloadData()
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
extension MyContributionController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.tblVwContribution
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if isLast == false
                {
                    self.MyContributionListCall()
                }
                else
                {
                    
                }
            }
        }
    }
}

extension MyContributionController: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int 
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1001
        {
            print("arrContributeList.count",arrContributeList.count)
            return arrContributeList.count
        }
        else
        {
            return arrCampaignList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 1001
        {
            return 30
        }
        else
        {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 1001
        {
            return 30.0
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1001
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "ContributeListCell", for: indexPath) as! ContributeListCell
            cell.setNeedsLayout()
            let contributeDetails = arrContributeList[indexPath.row]
            cell.lblDate.text = contributeDetails.createdDate
            cell.lblPrice.text = "Contribute: $" + "\(contributeDetails.amount)"
           // let height :CGFloat =  cell.tblVwList.contentSize.height
            
            
            return cell
        }
        else
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "MyContributionCell", for: indexPath) as! MyContributionCell
            let details = arrCampaignList[indexPath.row]
            arrContributeList = details.allContributeList
            cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            //cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: CGFloat(180 + cell.tblVwList.contentSize.height))
            //cell.tblVwList.frame.size = CGSize(width: cell.tblVwList.frame.width, height: (30.0 * CGFloat(arrContributeList.count)))
            //cell.tableHeightConstraint.constant = cell.tblVwList.contentSize.height
            //        cell.imgVwImage.layer.masksToBounds = true
            //        cell.imgVwImage.layer.cornerRadius = cell.imgVwImage.frame.size.height / 2
            
            cell.lblTitle.text = details.campaignName
            //cell.tblVwList.frame.size.height = cell.tblVwList.contentSize.height
            
            //cell.tableHeightConstraint.constant = cell.tblVwList.contentSize.height
            
            //let goalAmount = Float(details.goal_amount)
            //let raisedAmount: Float = Float(details.raisedAmount)
            //let getAmount = raisedAmount / goalAmount
            //cell.progressBar.setProgress(getAmount, animated: true)
            
            /*
             let expiredDate = details.date
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "MM/dd/yyyy"
             let date = dateFormatter.date(from: expiredDate!)
             dateFormatter.dateFormat = "MMM dd,yyyy"
             let strDate = dateFormatter.string(from: date!)
             print("strDate:", strDate)
             
             cell.lblDate.text = strDate
             */
            let price = details.amount
            if price != nil
            {
                //cell.lblAskingPrice.text = "Contributed $ " + String(price!)
            }
            
            
            let images = details.images
            if images.count > 0
            {
                let getImage = UrlUtil.getCampaignImage(image: images[0] as! String)
                
                cell.imgVwCampaignImage.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /*
        let details = arrCampaignList[indexPath.row]
        let moveViewController = ConfirmationController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
        moveViewController.campaignId = details.id
        moveViewController.fromHomeOrUpload = "Home"
        */
    }
}
