//
//  BankingInfoController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 13/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class BankingInfoController: UIViewController {

    @IBOutlet weak var scrlVwMain: UIScrollView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwIndividualOrBusiness: UIView!
    @IBOutlet weak var vwIndividual: UIView!
    @IBOutlet weak var lblIndividual: UILabel!
    @IBOutlet weak var vwBusiness: UIView!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var vwAllIndividual: UIView!
    @IBOutlet weak var vwBusinessExtra: UIView!
    @IBOutlet weak var vwBankingInformation: UIView!
    @IBOutlet weak var vwBankOrCard: UIView!
    @IBOutlet weak var vwBank: UIView!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var vwAllBankAccount: UIView!
    @IBOutlet weak var vwAllCard: UIView!
    @IBOutlet weak var vwTermsConditions: UIView!
    @IBOutlet weak var imgVwCheck: UIImageView!
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwFirstName: UIView!
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var vwDateOfBirth: UIView!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var vwAddress1: UIView!
    @IBOutlet weak var vwAddress2: UIView!
    @IBOutlet weak var vwSSN: UIView!
    @IBOutlet weak var vwPostalCode: UIView!
    
    @IBOutlet weak var vwBusinessName: UIView!
    @IBOutlet weak var vwBusinessTaxID: UIView!
    
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var vwCardNumber: UIView!
    @IBOutlet weak var vwExpireDate: UIView!
    @IBOutlet weak var vwCCV: UIView!
    
    @IBOutlet weak var vwPersonalAccount: UIView!
    @IBOutlet weak var vwBankName: UIView!
    @IBOutlet weak var vwRoutingNumber: UIView!
    @IBOutlet weak var vwAccountNumber: UIView!
    @IBOutlet weak var vwSwiftNumber: UIView!
    @IBOutlet weak var vwCountry: UIView!
    @IBOutlet weak var vwState: UIView!
    @IBOutlet weak var vwCity: UIView!
    
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfDob: UITextField!
    @IBOutlet weak var tfSSN: UITextField!
    @IBOutlet weak var tfAddress1: UITextField!
    @IBOutlet weak var tfAddress2: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPostalCode: UITextField!
    
    @IBOutlet weak var tfBusinessName: UITextField!
    @IBOutlet weak var tfBusinessTaxID: UITextField!
    
    @IBOutlet weak var tfPersonalAccount: UITextField!
    @IBOutlet weak var tfBankName: UITextField!
    @IBOutlet weak var tfRoutingNumber: UITextField!
    @IBOutlet weak var tfAccountNumber: UITextField!
    @IBOutlet weak var tfSwiftNumber: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfExpMonth: UITextField!
    @IBOutlet weak var tfExpYear: UITextField!
    @IBOutlet weak var tfCCV: UITextField!
    
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
    var strAccountType = ""
    var strBankOrCard = ""
    
    let borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    var strCountryId = ""
    var strStateId = ""
    
    var dicBankOrCard:[String: Any] = [:]
    var dicIndividualOrBusiness:[String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setViewBorder(vw: vwFirstName)
        self.setViewBorder(vw: vwLastName)
        self.setViewBorder(vw: vwSSN)
        self.setViewBorder(vw: vwPersonalAccount)
        self.setViewBorder(vw: vwBankName)
        self.setViewBorder(vw: vwRoutingNumber)
        self.setViewBorder(vw: vwAccountNumber)
        self.setViewBorder(vw: vwCountry)
        self.setViewBorder(vw: vwSwiftNumber)
        self.setViewBorder(vw: vwState)
        self.setViewBorder(vw: vwCity)
        self.setViewBorder(vw: vwBusinessName)
        self.setViewBorder(vw: vwBusinessTaxID)
        self.setViewBorder(vw: vwDateOfBirth)
        self.setViewBorder(vw: vwAddress1)
        self.setViewBorder(vw: vwAddress2)
        self.setViewBorder(vw: vwPhone)
        self.setViewBorder(vw: vwPostalCode)
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        tfExpMonth.inputView = datePickerView
        tfExpYear.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Add Banking".localized
        
        strAccountType = "individual"
        strBankOrCard = "bank_account"
        
        vwAllIndividual.isHidden = false
        vwBusinessExtra.isHidden = true
        vwAllBankAccount.isHidden = false
        vwAllCard.isHidden = true
        lblIndividual.isHidden = false
        lblBusiness.isHidden = true
        lblBank.isHidden = false
        lblCard.isHidden = true
        
        let prefs = UserDefaults.standard
        print(prefs.string(forKey: "city") ?? "")
        self.tfFirstName.text = prefs.string(forKey: "FName") ?? ""
        self.tfLastName.text = prefs.string(forKey: "LName") ?? ""
        self.tfAddress1.text = prefs.string(forKey: "address") ?? ""
        self.tfCity.text = prefs.string(forKey: "city") ?? ""
        self.tfState.text = prefs.string(forKey: "state") ?? ""
        self.tfDob.text = prefs.string(forKey: "birthDate") ?? ""
        self.tfCity.isUserInteractionEnabled = false
        self.tfState.isUserInteractionEnabled = false
        self.tfDob.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vwBankingInformation.frame.origin.y = vwAllIndividual.frame.size.height + vwAllIndividual.frame.origin.y + 10
        
        vwBankOrCard.frame.origin.y = vwBankingInformation.frame.size.height + vwBankingInformation.frame.origin.y + 10
        
        vwAllBankAccount.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y + 10
        
        vwAllCard.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y
        
        vwTermsConditions.frame.origin.y = vwAllBankAccount.frame.size.height + vwAllBankAccount.frame.origin.y + 30
        
        //vwMain.frame.size.height = vwTermsConditions.frame.size.height + vwTermsConditions.frame.origin.y + 10
        
        //scrlVwMain.contentSize = CGSize(width: vwMain.frame.size.width, height: vwMain.frame.size.height+100)
        
        view.updateConstraintsIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewBorder(vw: UIView)
    {
        vw.layer.borderColor = borderColor.cgColor
        vw.layer.borderWidth = 1.0
        vw.clipsToBounds = true
    }

    // MARK: - Action
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        //let actualDate = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy"
        tfExpYear.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "MM"
        tfExpMonth.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func btnMonthPressed(_ sender: Any) {
    }
    @IBAction func btnYearPressed(_ sender: Any) {
    }
    @IBAction func btnIndividualPressed(_ sender: Any)
    {
        strAccountType = "individual"
        vwAllIndividual.isHidden = false
        vwBusinessExtra.isHidden = true
        lblIndividual.isHidden = false
        lblBusiness.isHidden = true
        vwBankingInformation.frame.origin.y = vwAllIndividual.frame.size.height + vwAllIndividual.frame.origin.y + 10
        
        vwBankOrCard.frame.origin.y = vwBankingInformation.frame.size.height + vwBankingInformation.frame.origin.y + 10
        
        vwAllBankAccount.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y + 10
        
        vwAllCard.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y
        
        vwTermsConditions.frame.origin.y = vwAllBankAccount.frame.size.height + vwAllBankAccount.frame.origin.y + 30
        view.updateConstraintsIfNeeded()
    }
    @IBAction func btnBusinessPressed(_ sender: Any)
    {
        strAccountType = "company"
        vwAllIndividual.isHidden = false
        vwBusinessExtra.isHidden = false
        lblIndividual.isHidden = true
        lblBusiness.isHidden = false
        vwBankingInformation.frame.origin.y = vwBusinessExtra.frame.size.height + vwBusinessExtra.frame.origin.y + 10
        vwBankOrCard.frame.origin.y = vwBankingInformation.frame.size.height + vwBankingInformation.frame.origin.y + 10
        vwAllBankAccount.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y + 10
        vwAllCard.frame.origin.y = vwBankOrCard.frame.size.height + vwBankOrCard.frame.origin.y
        vwTermsConditions.frame.origin.y = vwAllBankAccount.frame.size.height + vwAllBankAccount.frame.origin.y + 30
        view.updateConstraintsIfNeeded()
    }
    @IBAction func btnBankPressed(_ sender: Any)
    {
        strBankOrCard = "bank_account"
        vwAllBankAccount.isHidden = false
        vwAllCard.isHidden = true
        lblBank.isHidden = false
        lblCard.isHidden = true
    }
    @IBAction func btnDebitCardPressed(_ sender: Any)
    {
        strBankOrCard = "card"
        vwAllBankAccount.isHidden = true
        vwAllCard.isHidden = false
        lblBank.isHidden = true
        lblCard.isHidden = false
    }
    @IBAction func btnSkipPressed(_ sender: Any)
    {
        dismissController()
    }
    @IBAction func btnCountryPressed(_ sender: Any)
    {
        let moveViewController = CountryListController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
    }
    @IBAction func btnStatePressed(_ sender: Any)
    {
        let moveViewController = StateController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
        moveViewController.countryId = strCountryId
    }
    @IBAction func btnCityPressed(_ sender: Any)
    {
        let moveViewController = CityController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
        moveViewController.stateId = strStateId
    }
    @IBAction func btnAcceptTermsPressed(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            sender.tag = 1
            imgVwCheck.image = UIImage(named: "tick")
        }
        else
        {
            sender.tag = 0
            imgVwCheck.image = UIImage(named: "")
        }
    }
    @IBAction func btnBackPressed(_ sender: Any)
    {
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = PopUpController()
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                pvc.present(vc, animated: false, completion: nil)
            })
        }
        
    }
    @IBAction func btnAddPressed(_ sender: Any)
    {
        if strAccountType == "individual"
        {
            if tfFirstName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "First Name", alertMsg: "Please enter your first name")
                return
            }
            else if tfLastName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Last Name", alertMsg: "Please enter your last name")
                return
            }
            else if tfDob.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Date of Birth", alertMsg: "Please enter your date of birth")
                return
            }
            else if tfSSN.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Personal Identification Number", alertMsg: "Please enter your personal Identification number")
                return
            }
            else if tfPhone.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Phone Number", alertMsg: "Please enter your phone number")
                return
            }
            else if tfCity.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "City", alertMsg: "Please enter your city")
                return
            }
            else if tfState.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "State", alertMsg: "Please enter your state")
                return
            }
            else if tfPostalCode.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Postal Code", alertMsg: "Please enter your postal code")
                return
            }
            else
            {
                print("individual")
            }
        }
        else
        {
            if tfFirstName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "First Name", alertMsg: "Please enter your first name")
                return
            }
            else if tfLastName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Last Name", alertMsg: "Please enter your last name")
                return
            }
            else if tfDob.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Date of Birth", alertMsg: "Please enter your date of birth")
                return
            }
            else if tfSSN.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Personal Identification Number", alertMsg: "Please enter your personal Identification number")
                return
            }
            else if tfCity.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "City", alertMsg: "Please enter your city")
                return
            }
            else if tfState.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "State", alertMsg: "Please enter your state")
                return
            }
            else if tfBusinessName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Business Name", alertMsg: "Please enter business name")
                return
            }
            else if tfBusinessTaxID.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Business Tax ID", alertMsg: "Please enter business Tax ID")
                return
            }
            else
            {
                print("business")
            }
        }
        if strBankOrCard == "bank_account"
        {
            if tfPersonalAccount.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Account Type", alertMsg: "Please add account type")
                return
            }
            else if tfBankName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Bank Name", alertMsg: "Please enter your bank name")
                return
            }
            else if tfRoutingNumber.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Routing Number", alertMsg: "Please add routing number")
                return
            }
            else if tfAccountNumber.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Account Number", alertMsg: "Please add account number")
                return
            }
            else if tfSwiftNumber.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Swift Number", alertMsg: "Please add swift number")
                return
            }
            else if tfCountry.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Country", alertMsg: "Please select country")
                return
            }
            else
            {
                dicBankOrCard = [ "object": "bank_account",
                                  "account_holder_name": self.tfFirstName.text! + " " + self.tfLastName.text!,
                                  "account_holder_type": tfPersonalAccount.text!,
                                  "bank_name": tfBankName.text!,
                                  "routing_number": tfRoutingNumber.text!,
                                  "account_number": tfAccountNumber.text!,
                                  "currency": "usd",
                                  "country": tfCountry.text!]
                print("bank_account")
            }
        }
        else
        {
            if tfName.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Name", alertMsg: "Please enter name")
                return
            }
            else if tfCardNumber.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Card Number", alertMsg: "Please enter your card number")
                return
            }
            else if tfExpMonth.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "Expire Date", alertMsg: "Please enter expiration date")
                return
            }
            else if tfCCV.text == ""
            {
                Alert.disPlayAlertMessage(titleMessage: "CCV Number", alertMsg: "Please enter CCV number")
                return
            }
            else
            {
                
                dicBankOrCard = [ "object": "card",
                                  "name": tfName.text!,
                                  "number": tfCardNumber.text!,
                                  "exp_month": tfExpMonth.text!,
                                  "exp_year": tfExpYear.text!,
                                  "cvc": tfCCV.text!,
                                  "currency": "usd"]
                print("card")
            }
        }
        if (self.imgVwCheck.image == nil){
            Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please accept all terms & conditions.")
        }
        else
        {
            addAccount()
        }
        
    }
    func dismissController()
    {
        
        if let pvc = self.presentingViewController as? UINavigationController
        {
            self.dismiss(animated: false, completion: {
                let homevc = HomeController()
                pvc.navigationController?.pushViewController(homevc, animated: true)
                
                var inLoop = false
                for vc in pvc.viewControllers
                {
                    print("vc",vc)
                    
                    if vc.isKind(of: HomeController.self)
                    {
                        inLoop = true
                        pvc.popToViewController(vc, animated: true)
                        
                        break
                    }
                }
                if !inLoop
                {
                    let homevc = HomeController()
                    pvc.navigationController?.pushViewController(homevc, animated: true)
                    
                }
                
            })
        }
    }
    
    //MARK: - Service Call
    func addAccount()
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/payment/bank/45445/add
        let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
        let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let email = UserDefaults.standard.object(forKey: "email") ?? ""
        //let postalCode = UserDefaults.standard.object(forKey: "zipCode") ?? ""
        
        //"555-867-5309"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let actualDate = dateFormatter.date(from: tfDob.text!)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: actualDate!)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: actualDate!)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: actualDate!)
        
        let prmList:[String: Any] = ["accountType":"custom", "type":strAccountType, "firstName": tfFirstName.text!, "lastName": tfLastName.text!, "dobDay":day, "dobMonth":month,"dobYear": year, "personalIdNumber": tfSSN.text!, "supportPhone": tfPhone.text!, "supportEmail": email,  "businessName": tfBusinessName.text!, "businessTaxId": tfBusinessTaxID.text!, "addressLine1": tfAddress1.text!,"addressLine2": tfAddress2.text!,"city": tfCity.text!,"state": tfState.text!,"postal":tfPostalCode.text!,"externalAccount":dicBankOrCard]
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/payment/bank/\(userId)/add")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: AddBAnkAccountResponse?) in
            
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "isBanking")
                UserDefaults.standard.synchronize()
                //self.dismissController()
                //Alert.disPlayAlertMessage(titleMessage: "Done!", alertMsg: response.msg!)
                
                if let pvc = self.presentingViewController
                {
                    self.dismiss(animated: true, completion: {
                        if UserDefaults.standard.value(forKey: "isBanking") as? Bool == true && UserDefaults.standard.value(forKey: "isVerified") as? Bool == true
                        {
                            Alert.disPlayAlertMessage(titleMessage: "Done!", alertMsg: response.msg!)
                        }
                        else
                        {
                            let vc = PopUpController()
                            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            pvc.present(vc, animated: false, completion: nil)
                        }
                    })
                }
                self.view.endEditing(true)
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
extension BankingInfoController:CountryListDelegate
{
    func getCountryDetails(countryId: String, countryName: String, countrySortname: String)
    {
        self.tfCountry.text = countryName
        strCountryId = countryId
        self.tfState.text = ""
        self.tfCity.text = ""
    }
}
extension BankingInfoController:StateListDelegate
{
    func getStateDetails(stateId: String, stateName: String)
    {
        self.tfState.text = stateName
        strStateId = stateId
        self.tfCity.text = ""
    }
}
extension BankingInfoController:CityDelegate
{
    func cityDetails(cityId: String, cityName: String)
    {
        self.tfCity.text = cityName
        //strStateId = stateId
        //        self.tfState.text = ""
        //        self.tfCity.text = ""
    }
}
