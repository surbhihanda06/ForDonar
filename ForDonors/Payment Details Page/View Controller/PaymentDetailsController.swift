//
//  PaymentDetailsController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 09/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import CCValidator
import Stripe
import SVProgressHUD

class PaymentDetailsController: UIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate  {

    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwCCName: UIView!
    @IBOutlet weak var vwCardNumber: UIView!
    @IBOutlet weak var vwExperation: UIView!
    @IBOutlet weak var vwCVV: UIView!
    @IBOutlet weak var vwCCDate: UIView!
    @IBOutlet weak var vwCheck: UIView!
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwTransparent: UIView!
    @IBOutlet weak var vwConfirmation: UIView!
    
    @IBOutlet weak var imgVwCheck: UIImageView!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCCName: UITextField!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfExpiration: UITextField!
    @IBOutlet weak var tfCVV: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var imgVwNameCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwAnonymousCheck: UIImageView!
    @IBOutlet weak var imgVwEnterName: UIImageView!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var strStripeToken: String?
    var willSave = false
    
    var aliasCheck = ""
    var nameToSend = ""
    
    var strAmount: String = ""
    var campaignId: Int!
    var parkId: Int!
    
    var SelectedTag: Int = 7
    
    @IBOutlet weak var colVwCards: UICollectionView!
    
    let borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    
    let cards: [[String: Any]] = [["name":"american_express", "tag": 0], ["name":"Dankort","tag": 1], ["name":"DinersClub","tag": 2], ["name":"Discover","tag": 3], ["name":"Maestro","tag": 5],["name":"MasterCard","tag": 6],["name":"visa","tag": 9]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewBorder(vw: vwCCName)
        self.setViewBorder(vw: vwCardNumber)
        self.setViewBorder(vw: vwCVV)
        self.setViewBorder(vw: vwCCDate)
        self.setViewBorder(vw: vwCheck)
        self.setViewBorder(vw: vwName)
        
        vwConfirmation.layer.masksToBounds = true
        vwConfirmation.layer.cornerRadius = 4
        vwConfirmation.layer.shadowColor = UIColor.darkGray.cgColor
        vwConfirmation.layer.shadowOffset = CGSize(width: 0, height: 0)
        vwConfirmation.layer.shadowRadius = 2
        vwConfirmation.layer.shadowOpacity = 1.0
        
        btnNo.layer.borderColor = borderColor.cgColor
        btnNo.layer.cornerRadius = 2
        btnNo.layer.borderWidth = 1.0
        btnNo.clipsToBounds = true
        
        btnYes.layer.borderColor = borderColor.cgColor
        btnYes.layer.cornerRadius = 2
        btnYes.layer.borderWidth = 1.0
        btnYes.clipsToBounds = true
        
        tfCardNumber.delegate = self
        tfCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        let nib = UINib(nibName: "CardCell", bundle: Bundle.main)
        colVwCards?.register(nib, forCellWithReuseIdentifier: "CardCell")
        
        let prefs = UserDefaults.standard
        let fname: String = prefs.string(forKey: "FName") ?? ""
        let lname: String = prefs.string(forKey: "LName") ?? ""
        self.lblName.text = fname + " " + lname
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        tfExpiration.inputView = datePickerView
        //datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Payment".localized
        vwBg.isHidden = true
        print("strAmount",strAmount)
        print("parkId",parkId)
        
        if strAmount == ""
        {
            tfAmount.isUserInteractionEnabled = true
        }
        else
        {
            tfAmount.isUserInteractionEnabled = false
        }
        tfAmount.text = strAmount
        imgVwNameCheck.image = UIImage(named: "tick")
        imgVwEnterName.image = UIImage(named: "")
        imgVwAnonymousCheck.image = UIImage(named: "")
        lblName.text = UserDefaults.standard.string(forKey: "FName")! + " " + UserDefaults.standard.string(forKey: "LName")!
        nameToSend = lblName.text!
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
        dateFormatter.dateFormat = "MM/yy"
        //        let now = Date()
        //        let birthday: Date = sender.date
        //        let calendar = Calendar.current
        
        //let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        //let age = ageComponents.year!
        //tfDateOfBirth.text = String(age)
        tfExpiration.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func btnYesCardPressed(_ sender: Any)
    {
        willSave = true
        vwBg.isHidden = true
        saveCardDetails()
    }
    @IBAction func btnNoCardPressed(_ sender: Any)
    {
        willSave = false
        vwBg.isHidden = true
        saveCardDetails()
    }
    
    @IBAction func btnBackPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPayAndPublishPressed(_ sender: Any)
    {
        if (tfAmount.text?.isEmpty)!
        {
            Alert.disPlayAlertMessage(titleMessage: "Amout", alertMsg: "Please enter amount.")
        }
        else if (tfCCName.text?.isEmpty)!
        {
            Alert.disPlayAlertMessage(titleMessage: "CC Name", alertMsg: "Please enter CC Name.")
        }
        else if (tfCardNumber.text?.isEmpty)!
        {
            Alert.disPlayAlertMessage(titleMessage: "Card Number", alertMsg: "Please enter card number.")
        }
        else if (tfExpiration.text?.isEmpty)!
        {
            Alert.disPlayAlertMessage(titleMessage: "Expire Date", alertMsg: "Please enter expire date.")
        }
        else if (tfCVV.text?.isEmpty)!
        {
            Alert.disPlayAlertMessage(titleMessage: "CVV", alertMsg: "Please enter CVV number.")
        }
        else if imgVwCheck.image == nil
        {
            Alert.disPlayAlertMessage(titleMessage: "Terms & Conditions", alertMsg: "Please accept all Terms & Conditions.")
        }
        else
        {
            //vwBg.isHidden = false
            //willSave = true
            saveCardDetails()
            /*
            let expireDate: String = (tfExpiration.text)!
            let fullNameArr = expireDate.components(separatedBy: "/")
            let month    = UInt(fullNameArr[0]) //fullNameArr[0]
            let year = UInt(fullNameArr[1])
            //print("UInt(month)",UInt(month))
            let cardNumber = tfCardNumber.text
            let cardParams = STPCardParams()
            cardParams.number = cardNumber
            cardParams.expMonth = month!
            cardParams.expYear = year!
            cardParams.cvc = tfCVV.text
            STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
                if let error = error {
                    print(error)
                } else if let token = token {
                    self.strStripeToken = token.tokenId
                    print(self.strStripeToken ?? "")
                        
                }
            }
            */
//            if let pvc = self.presentingViewController
//            {
//                self.dismiss(animated: true, completion: {
//                    let vc = StripeController()
//                    pvc.present(vc, animated: true, completion: nil)
//                })
//            }
        }
        
        
        
//        let moveViewController = StripeController()
//        self.navigationController?.pushViewController(moveViewController, animated: true)
    }
    @IBAction func btnTermsAndConditionsPressed(_ sender: UIButton)
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
    @IBAction func btnEnterNamePressed(_ sender: Any)
    {
        aliasCheck = "1"
        imgVwNameCheck.image = UIImage(named: "")
        imgVwEnterName.image = UIImage(named: "tick")
        imgVwAnonymousCheck.image = UIImage(named: "")
        nameToSend = tfName.text!
    }
    @IBAction func btnAnonymousPressed(_ sender: Any)
    {
        aliasCheck = "2"
        imgVwNameCheck.image = UIImage(named: "")
        imgVwEnterName.image = UIImage(named: "")
        imgVwAnonymousCheck.image = UIImage(named: "tick")
        nameToSend = "Anonymous"
        tfName.resignFirstResponder()
    }
    @IBAction func btnNamePressed(_ sender: Any)
    {
        aliasCheck = "3"
        imgVwNameCheck.image = UIImage(named: "tick")
        imgVwEnterName.image = UIImage(named: "")
        imgVwAnonymousCheck.image = UIImage(named: "")
        nameToSend = lblName.text!
        tfName.resignFirstResponder()
    }
    
    //MARK: - Service Call
    
    func saveCardDetails()
    {
        
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/payment/charge/create
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/yy"
        let date = dateFormat.date(from: tfExpiration.text!)
        dateFormat.dateFormat = "yyyy"
        let gateYear = dateFormat.string(from: date!)
        dateFormat.dateFormat = "MM"
        let gateMonth = dateFormat.string(from: date!)
        
        let campaign = String(campaignId)
        
//        let prmList:[String: Any] = ["userId":"\(userId)", "campaignId":campaign, "type": "card", "amount": tfAmount.text ?? "", "currency":"USD", "number":tfCardNumber.text ?? "","exp_month": gateMonth, "exp_year": gateYear, "cvc": tfCVV.text!, "description": "This is for test"]
        
        
        var invoice:Dictionary = [String: Any]()
        invoice["amount"]=tfAmount.text ?? ""
        invoice["perkId"] = parkId ?? nil
        //invoice["perkId"]="\(parkId)"
        
        var contribution:Dictionary = [String: Any]()
        
        
        
        contribution["contributorId"]="\(userId)"
        contribution["campaignId"]=campaign
        contribution["alias"]=nameToSend
        contribution["invoice"]=invoice
        
        var paymentCard:Dictionary = [String: Any]()
        paymentCard["type"]="card"
        paymentCard["number"]=tfCardNumber.text ?? ""
        paymentCard["exp_month"]=gateMonth
        paymentCard["exp_year"]=gateYear
        paymentCard["cvc"]=tfCVV.text!
        paymentCard["description"]="Contribution for \(Date())"
        paymentCard["name"] = tfCCName.text
        
        var prmList:Dictionary = [String: Any]()
        prmList["contribution"]=contribution
        prmList["paymentCard"]=paymentCard
        
        
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/payment/charge/create")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: PaymentDetailsResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.data != nil
                {
                    
                    self.dismissController()
                    Alert.disPlayAlertMessage(titleMessage: "Done!", alertMsg: "You have paid successfully")
                }
                else
                {
                    Alert.disPlayAlertMessage(titleMessage: "Sorry!", alertMsg: "Please try again")
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
    
    func dismissController()
    {
        if let pvc = self.presentingViewController as? UINavigationController
        {
            self.dismiss(animated: true, completion: {
                
                var inLoop = false
                for vc in pvc.viewControllers
                {
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
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        //let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // https://baymard.com/checkout-usability/credit-card-patterns
        let isAmex = ["34", "37"].contains(string.prefix(2))
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needsAmexSpacing = (isAmex && (i == 4 || i == 10 || i == 15))
            let needsNormalSpacing = (!isAmex && i > 0 && (i % 4) == 0)
            
            if needsAmexSpacing || needsNormalSpacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == tfName
        {
            imgVwNameCheck.image = UIImage(named: "")
            imgVwEnterName.image = UIImage(named: "tick")
            imgVwAnonymousCheck.image = UIImage(named: "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField==tfCardNumber ) {
            let numberAsString = tfCardNumber.text
            let recognizedType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: numberAsString!)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfCardNumber
        {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            let recognizedType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: previousTextFieldContent!)
            print("recognizedType:", recognizedType.hashValue)
            SelectedTag = recognizedType.hashValue
            colVwCards.reloadData()
        }
        else if textField == tfExpiration
        {
            if range.length > 0 {
                return true
            }
            if string == "" {
                return false
            }
            if range.location > 4 {
                return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
                return false
            }
            
            //Put / after 2 digit
            if range.location == 2 {
                originalText?.append("/")
                textField.text = originalText
            }
        }
        else if textField == tfCVV
        {
            let charsLimit = 5
            
            let startingLength = textField.text?.characters.count ?? 0
            let lengthToAdd = string.characters.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            return newLength <= charsLimit
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
extension PaymentDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        let details = cards[indexPath.row]
        let image = details["name"]
        cell.imgVwCard.image = UIImage(named: image as! String)
        let tag = details["tag"] as? Int
            if SelectedTag == tag
            {
                cell.lblSelected.isHidden = false
            }
            else
            {
                cell.lblSelected.isHidden = true
            }
        return cell
        
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 70);
        
    }
}
