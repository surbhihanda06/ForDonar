//
//  CountryListController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol CountryListDelegate: class {
    func getCountryDetails(countryId: String, countryName: String , countrySortname: String)
}

class CountryListController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVwCountry: UITableView!
    
    var delegate: CountryListDelegate!
    var filteredCountries = [CountryDetails]()
    var countries = [CountryDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 12
        
        tblVwCountry.tableHeaderView = vwBg
        
        tfSearch.addTarget(self, action: #selector(self.performAutosearch), for: .editingChanged)
        tfSearch.delegate = self
        
        self.tblVwCountry.register(UINib(nibName: "TableCell", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
        countryList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Service Call
    
    func countryList()
    {
        SVProgressHUD.show()
        //let deviceToken = UserDefaults.standard.object(forKey: "pushNotificationID") as? String ?? ""
        let prmList:[String: Any] = [:]
        let request = MakeGetRequest.init(parameterList: prmList, APIName: "/country")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: CountryAPIResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.status == "200" && getMyData?.data != nil
                {
                    self.countries = (getMyData?.data)!
                    self.filteredCountries = self.countries
                    self.tblVwCountry.reloadData()
                }
                else
                {
                    Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: (getMyData?.message)!)
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
            filteredCountries = self.countries.filter { ($0.name?.contains(SearchString))! }
        }
        else
        {
            if self.countries.count > 0
            {
                self.filteredCountries = self.countries
            }
            //tfSearch.resignFirstResponder()
        }
        tblVwCountry.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }

    // MARK: - Action
    @IBAction func btnCancelPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
extension CountryListController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredCountries.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let myCountry = filteredCountries[indexPath.row]
        cell.lblName.text = myCountry.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let myCountry = filteredCountries[indexPath.row]
        delegate.getCountryDetails(countryId: String(format:"%d",myCountry.countryId), countryName: myCountry.name!, countrySortname: myCountry.shortName!)
        dismiss(animated: true, completion: nil)
    }
}
