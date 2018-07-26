//
//  CityController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol CityDelegate: class {
    func cityDetails(cityId: String, cityName: String)
}

class CityController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tblVwCity: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var delegate: CityDelegate!
    var arrCity = [CityDetails]()
    var stateId: String = ""
    var filteredCity = [CityDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 12
        tfSearch.addTarget(self, action: #selector(self.performAutosearch), for: .editingChanged)
        tfSearch.delegate = self
        tblVwCity.tableHeaderView = vwBg
        
        self.tblVwCity.register(UINib(nibName: "TableCell", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cityList(strStateId: stateId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Service Call
    func cityList(strStateId: String)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: String(format:"/city?stateId=%@",strStateId))
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CityApiResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.allCity.count != nil
                {
                    self.arrCity = (getMyData?.allCity)!
                    self.filteredCity = self.arrCity
                    self.tblVwCity.reloadData()
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
            filteredCity = self.arrCity.filter { ($0.name?.contains(SearchString))! }
        }
        else
        {
            if self.arrCity.count > 0
            {
                self.filteredCity = self.arrCity
            }
        }
        tblVwCity.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }

    // MARK: - Action
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
extension CityController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredCity.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let details = filteredCity[indexPath.row]
        cell.lblName.text = details.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let details = filteredCity[indexPath.row]
        delegate.cityDetails(cityId: String(format:"%d",details.cityId), cityName: details.name!)
        dismiss(animated: true, completion: nil)
    }
}
