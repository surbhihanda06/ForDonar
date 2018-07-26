//
//  StateController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol StateListDelegate: class {
    func getStateDetails(stateId: String, stateName: String)
}

class StateController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVwState: UITableView!
    
    var delegate: StateListDelegate!
    var countryId: String = ""
    var filteredStates = [StateDetails]()
    var states = [StateDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 12
        tfSearch.addTarget(self, action: #selector(self.performAutosearch), for: .editingChanged)
        tfSearch.delegate = self
        tblVwState.tableHeaderView = vwBg
        
        self.tblVwState.register(UINib(nibName: "TableCell", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StateList(countryId: countryId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Service Call
    func StateList(countryId: String)
    {
        //http://166.62.40.135:9000/ForDonor-0.0.1-SNAPSHOT/api/state?countryId=101
        SVProgressHUD.show()
        //let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: String(format:"/state?countryId=%@",countryId))
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: StateApiResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.stateList.count != nil
                {
                    self.states = (getMyData?.stateList)!
                    self.filteredStates = self.states
                    self.tblVwState.reloadData()
                }
                else
                {
                    //Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: (getMyData?.message)!)
                }
                
                self.view.endEditing(true)
                //_=self.navigationController?.popToRootViewController(animated: true)
                //Alert.disPlayAlertMessage(titleMessage: "Login Success", alertMsg: "Thank you \(username), for logging in as \(role)")
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
    
    @objc func performAutosearch()
    {
        if (tfSearch.text?.isEmpty == false)
        {
            let SearchString:String = tfSearch.text ?? ""
            filteredStates = self.states.filter { ($0.name?.contains(SearchString))! }
        }
        else
        {
            if self.states.count > 0
            {
                self.filteredStates = self.states
            }
        }
        tblVwState.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }

    // MARK: - Action
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
extension StateController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredStates.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let details = filteredStates[indexPath.row]
        cell.lblName.text = details.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let details = filteredStates[indexPath.row]
        delegate.getStateDetails(stateId: String(format:"%d",details.stateId), stateName: details.name!)
        dismiss(animated: true, completion: nil)
    }
}

