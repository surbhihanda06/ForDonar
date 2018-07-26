//
//  CollaboratorListController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

protocol CollaboratorListControllerDalegate: class {
    func fetchCollaboratorList(selectedCollaborator: [User])
}

class CollaboratorListController: UIViewController {
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tblVwCollaborators: UITableView!
    
    var arrCollaborators = [User]()
    var commonCollaborators = [User]()
    var selectedCollaborators = [User]()
    var selectedId: NSMutableArray = NSMutableArray()
    
    var tmrColabList = Timer()
    
    weak var delegate: CollaboratorListControllerDalegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblVwCollaborators.register(UINib(nibName: "AddCollaboratorCell", bundle: Bundle.main), forCellReuseIdentifier: "AddCollaboratorCell")
        tblVwCollaborators.tableFooterView = UIView()
        tblVwCollaborators.separatorStyle = .singleLine
        
        for usr in selectedCollaborators
        {
            let id: String = String(format:"%d",usr.id)
            if !selectedId .contains(id)
            {
                selectedId.add(id)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //AllCollaboratorsListCall()
    }
    
    
    func startTimer()
    {
        //guard tmrUsrValidChk == nil else { return }
        if tmrColabList.isValid
        {
            tmrColabList.invalidate()
        }
        tmrColabList = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireUserCheckingService), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        //guard tmrUsrValidChk != nil else { return }
        if tmrColabList.isValid
        {
            tmrColabList.invalidate()
        }
    }
    
    @objc func fireUserCheckingService() {
        stopTimer()
        self.AllCollaboratorsListCall()
    }
    
    // MARK - Service Call
    func AllCollaboratorsListCall()
    {
        if let searchText = srchBar.text, searchText.count > 0
        {
            /*SVProgressHUD.show()
            APIManager.sharedInstance.getCollaboratorListWithName(name: searchText.lowercased(), onSuccess: { (getMyData: CollaboratorResponse?) in
                SVProgressHUD.dismiss()
                self.arrCollaborators = (getMyData?.allCollaborators)!
                self.tblVwCollaborators.reloadData()
            }, onFailure: { error in
                
                    SVProgressHUD.dismiss()
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
            })*/
            //http://fordonor.us-west-2.elasticbeanstalk.com/api/search/users?query=huyjgj
            SVProgressHUD.show()
            let prmList:[String: Any] = [:]
            let apiname = String(format:"/search/users?query=%@",searchText.lowercased())
            let request = MakeGetRequest.init(parameterList: prmList, APIName: apiname)
            RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CollaboratorResponse?) in
                SVProgressHUD.dismiss()
                if getMyData != nil
                {
                    let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
                    self.arrCollaborators = (getMyData?.allCollaborators)!
                    self.commonCollaborators = self.arrCollaborators
                    for index in 0..<self.arrCollaborators.count
                    {
                        let details = self.arrCollaborators[index]
                        let id = details.id
                        if id == userId
                        {
                            self.commonCollaborators.remove(at: index)
                        }
                        else
                        {
                            //self.commonCollaborators.append(details)
                        }
                    }
                    self.tblVwCollaborators.reloadData()
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
    
    // MARK: - Navigation

    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDonePressed(_ sender: Any)
    {
        //selectedCollaborators = []
        for strId in selectedId
        {
            for colaborator in arrCollaborators
            {
                if String(format:"%d",colaborator.id) == String(format:"%@",strId as! CVarArg) && selectedCollaborators.filter({ el in el.id == colaborator.id }).count == 0
                {
                    selectedCollaborators.append(colaborator)
                    break
                    
                }
            }
        }
        delegate?.fetchCollaboratorList(selectedCollaborator: selectedCollaborators)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension CollaboratorListController: UITableViewDataSource,UITableViewDelegate
{
    /*func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if arrCollaborators.count > 0
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No user available with your search keyword"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commonCollaborators.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "AddCollaboratorCell", for: indexPath) as! AddCollaboratorCell
        
        let details = commonCollaborators[indexPath.row]
        let firstName = details.firstname
        let lastName = details.lastname
        cell.lblUserName.text = firstName! + " " + lastName!
        cell.imgVwUser.layer.masksToBounds = true
        cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
        let profileImage = details.profileImg
        
        let profileImgURL = UrlUtil.getUserImage(image:profileImage ?? "")
        cell.imgVwUser.sd_setImage(with: URL(string: profileImgURL), placeholderImage: UIImage(named: Default_Image))
        
        /* Alamofire.request(profileImgURL).responseImage { response in
         if let image = response.result.value {
         cell.imgVwUser.image = image
         }
         }*/
        
        let id: String = String(format:"%d",details.id)
        if selectedId.contains(id)
        {
            //cell.imgVwCheck.image = UIImage(named: "selected")
            //cell.btnAdd.setTitle("Done", for: .normal)
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
            //cell.imgVwCheck.image = UIImage(named: "oval")
            //cell.btnAdd.setTitle("Add", for: .normal)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let details = commonCollaborators[indexPath.row]
        
        let id: String = String(format:"%d",details.id)
        if selectedId .contains(id)
        {
            selectedId.remove(id)
        }
        else
        {
            selectedId.add(id)
        }
        tblVwCollaborators.reloadData()
    }
}
extension CollaboratorListController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.startTimer()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.fireUserCheckingService()
    }
}
