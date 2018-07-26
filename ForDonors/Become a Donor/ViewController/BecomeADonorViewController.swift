//
//  BecomeADonorViewController.swift
//  ForDonors
//
//  Created by NITS_Mac6 on 29/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class BecomeADonorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblVwBecomeADonor: UITableView!
    var arrOrgans: NSMutableArray = NSMutableArray()
    var arrHealthList = [HealthTypeDetails]()
    var arrBloodList = [BloodTypeDetails]()
    var selectedHealth = [HealthTypeDetails]()
    var selectedName: NSMutableArray = NSMutableArray()
    
    var userGender = ""
    var userBlood = ""
    var userHeight = ""
    var userWeight = ""
    
    var isTermsConditionCheck = -1
    
     let imagePicker = UIImagePickerController()
    
    var pkrvw: UIPickerView = UIPickerView()
    let pickOption = ["Male", "Female", "Other"]
    
    var pkrvwBlood: UIPickerView = UIPickerView()
    let arrBloodType = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
    
    var pkrvwHeight: UIPickerView = UIPickerView()
    let arrHeight = ["5’0”", "5’1”", "5’2”", "5’3”", "5’4”", "5’5”", "5’6”", "5’7”", "5’8”", "5’9”", "5’10”", "5’11”", "6’0”", "6’1”", "6’2”", "6’3”", "6’4”", "6’5”", "6’6”", "6’7”", "6’8”", "6’9”", "6’10”", "6’11”", "7’0”"]
    
    let borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cellRegistration()
        getBloodTypeList()
        getHealthTypeList()
        
        pkrvw.delegate = self
        pkrvwBlood.delegate = self
        pkrvwHeight.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let prefs = UserDefaults.standard
        userGender = prefs.string(forKey: "Gender") ?? ""
        
        lblPageTitle.text = "Select Donation".localized
        btnSkip.setTitle("Skip".localized, for: .normal)
        btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    func setViewBorder(vw: UIView)
    {
        vw.layer.borderColor = borderColor.cgColor
        vw.layer.borderWidth = 1.0
        vw.clipsToBounds = true
    }
    
    //MARK:- Cell Registration
    func cellRegistration()   {
        
        self.tblVwBecomeADonor.register(UINib(nibName: "BecomeADonorImageCell", bundle: Bundle.main), forCellReuseIdentifier: "BecomeADonorImageCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "BecomeADonorGenderCell", bundle: Bundle.main), forCellReuseIdentifier: "BecomeADonorGenderCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "BecomeADonorBloodCell", bundle: Bundle.main), forCellReuseIdentifier: "BecomeADonorBloodCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "BecomeADonorHeightCell", bundle: Bundle.main), forCellReuseIdentifier: "BecomeADonorHeightCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "BecomeADonorWeightCell", bundle: Bundle.main), forCellReuseIdentifier: "BecomeADonorWeightCell")
        
        
        self.tblVwBecomeADonor.register(UINib(nibName: "OrganTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganTitleCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "OrganCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganCell")
        
        self.tblVwBecomeADonor.register(UINib(nibName: "TermsConditionsCell", bundle: Bundle.main), forCellReuseIdentifier: "TermsConditionsCell")
        
    }
    
    //MARK: Action
    @objc func btnCheckPressed(sender: UIButton!)
    {
        self.isTermsConditionCheck =  self.isTermsConditionCheck ==  sender.tag ? -1 : sender.tag
        self.tblVwBecomeADonor.reloadData()
    }
    @IBAction func btnSkipPressed(_ sender: Any)
    {
        dismissController()
    }
    
    func dismissController()
    {
        let pvc = self.presentingViewController as? UINavigationController
        self.dismiss(animated: false, completion: {
            let homevc = HomeController()
            pvc?.navigationController?.pushViewController(homevc, animated: true)
        })
        /*
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
        }*/
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any)
    {
        
        if userGender.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Gender", alertMsg: "Please select gender!")
            return
        }
        if userBlood.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Blood Type", alertMsg: "Please select blood type!")
            return
        }
        if userHeight.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Height", alertMsg: "Please enter height!")
            return
        }
        if userWeight.isEmpty
        {
            Alert.disPlayAlertMessage(titleMessage: "Weight", alertMsg: "Please enter weight!")
            return
        }
        if self.isTermsConditionCheck == -1
        {
            Alert.disPlayAlertMessage(titleMessage: "Terms & Conditions", alertMsg: "Please accept Terms & Conditions!")
            return
        }
        //var prmList:[String: Any] = [:]
        var paramToPass = ""
        for i in 0..<self.arrHealthList.count
        {
            let details = self.arrHealthList[i]
            var name = details.name
            
            if selectedName.contains(name as Any)
            {
                name = name?.lowercased()
                let key = String(format:"donor.%@",name!)
                let value = "true"
                let valueToSend = key + "=" + value
                paramToPass = paramToPass.count > 0 ? paramToPass + "&" + valueToSend :  valueToSend
                //prmList[key] = value
            }
            else
            {
                name = name?.lowercased()
                let key = String(format:"donor.%@",name!)
                let value = "false"
                let valueToSend = key + "=" + value
                paramToPass = paramToPass.count > 0 ? paramToPass + "&" + valueToSend : valueToSend
                //prmList[key] = value
            }
        }
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let apiName = String(format:"/user/\(userId)/donor/update?userHealthInfo.gender=%@&userHealthInfo.bloodType=%@&userHealthInfo.height=%@&userHealthInfo.weight=%@&%@",userGender,userBlood,userHeight,userWeight,paramToPass)
        let request = MakePostRequest.init(parameterList: [:], APIName: apiName)
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: UserAPIResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let userDetails = response.data
                {
                    Validation.saveUserToUserDefaults(userDetails: userDetails)
                    self.dismissController()
                }
                else
                {
                    let message = response.message ?? "Some error occured, please try again"
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: message)
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
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Service Call
    func getHealthTypeList()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/healthtype/list")
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: HealthTypeResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                self.arrHealthList = response.healthList
                self.tblVwBecomeADonor.reloadData()
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
    func getBloodTypeList()
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/bloodtype/list")
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: BloodTypeResponse?) in
            SVProgressHUD.dismiss()
            if let response = getMyData
            {
                self.arrBloodList = response.allBlood
                self.pkrvwBlood.reloadAllComponents()
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
    func AllCampaignListCall(selectedCategoryId: Int)
    {
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/donor/edit
        
        /*{
        "blood": true,
        "heart": true,
        "id": 0,
        "kidney": true,
        "lung": true,
        "skin": true,
        "userId": 0
    }*/
        
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let prmList:[String: Any] = [:]//["blood":true, "heart":isHeart, "id": "", "kidney": isKedney, "lung":isLung, "skin":isSkins,"userId": userId]
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/donor/edit")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: MyCampaignListResponse?) in
            SVProgressHUD.dismiss()
            if let myData = getMyData
            {
                
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
extension BecomeADonorViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = arrHealthList.count
        return count + 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            return 134
        }
        else if indexPath.row==1
        {
            return 70
        }
        else if indexPath.row==2
        {
            return 70
        }
        else if indexPath.row==3
        {
            return 70 //140
        }
        else if indexPath.row==4
        {
            return 70
        }
        else if indexPath.row==5
        {
            return 90
        }
        if indexPath.row > 5 && arrHealthList.count > 0
        {
            if indexPath.row <= arrHealthList.count + 5
            {
                return 50
            }
            else
            {
                return 170
            }
        }
        else
        {
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row==0
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "BecomeADonorImageCell", for: indexPath) as! BecomeADonorImageCell
            cell.imgVwUser.layer.masksToBounds = true
            cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.height / 2
            let prefs = UserDefaults.standard
            let userImage = prefs.string(forKey: "profileImg") ?? ""
            if userImage != ""
            {
                let getImage = UrlUtil.getUserImage(image: userImage)
                cell.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
                
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeADonorGenderCell") as! BecomeADonorGenderCell
            cell.tfGender.tag = indexPath.row
            cell.tfGender.delegate = self
            cell.selectionStyle = .none
            cell.tfGender.inputView = pkrvw
            cell.tfGender.text = userGender
            setViewBorder(vw: cell.vwGender)
            return cell
        }
        else if indexPath.row==2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeADonorBloodCell") as! BecomeADonorBloodCell
            cell.tfBloodType.tag = indexPath.row
            cell.tfBloodType.delegate = self
            cell.selectionStyle = .none
            cell.tfBloodType.inputView = pkrvwBlood
            cell.tfBloodType.text = userBlood
            setViewBorder(vw: cell.vwBloodType)
            return cell
        }
            
        else if indexPath.row==3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeADonorHeightCell") as! BecomeADonorHeightCell
            cell.tfHeight.tag = indexPath.row
            cell.tfHeight.delegate = self
            cell.selectionStyle = .none
            setViewBorder(vw: cell.vwHeight)
            return cell
        }
        else if indexPath.row==4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeADonorWeightCell") as! BecomeADonorWeightCell
            cell.tfWeight.tag = indexPath.row
            cell.tfWeight.delegate = self
            setViewBorder(vw: cell.vwWeight)
            return cell
        }
        else if indexPath.row==5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganTitleCell") as! OrganTitleCell
            cell.lblTitle.text = "Select Organs".localized
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row > 5 && arrHealthList.count > 0
        {
            print("indexPath.row", indexPath.row)
            print("arrPerkList.count", arrHealthList.count)
            
            if indexPath.row <= arrHealthList.count + 5
            {
                let details = arrHealthList[indexPath.row-6]
                let  cell = tableView.dequeueReusableCell(withIdentifier: "OrganCell", for: indexPath) as! OrganCell
                cell.lblOrganName.text = details.name
                let name = details.name
                if selectedName.contains(name)
                {
                    cell.imgVwCheck.image = UIImage(named: "tick")
                }
                else
                {
                    cell.imgVwCheck.image = UIImage(named: "")
                }
                
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TermsConditionsCell") as! TermsConditionsCell
                cell.lblTerms.text = "By checking you're agreeing to all terms & conditions".localized
                cell.selectionStyle = .none
                cell.btnCheck?.addTarget(self, action: #selector(self.btnCheckPressed), for: UIControlEvents.touchUpInside)
                cell.btnCheck.tag = indexPath.row
                if isTermsConditionCheck == indexPath.row
                {
                    cell.imgVwCheck.image = UIImage(named: "tick")
                }
                else
                {
                    cell.imgVwCheck.image = UIImage(named: "")
                }
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TermsConditionsCell") as! TermsConditionsCell
            cell.lblTerms.text = "By checking you're agreeing to all terms & conditions".localized
            cell.selectionStyle = .none
            cell.btnCheck?.addTarget(self, action: #selector(self.btnCheckPressed), for: UIControlEvents.touchUpInside)
            cell.btnCheck.tag = indexPath.row
            if isTermsConditionCheck == indexPath.row
            {
                cell.imgVwCheck.image = UIImage(named: "tick")
            }
            else
            {
                cell.imgVwCheck.image = UIImage(named: "")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row==0
        {
            
        }
        else if indexPath.row==1
        {
            
        }
        else if indexPath.row==2
        {
            
        }
            
        else if indexPath.row==3
        {
            
        }
        else if indexPath.row==4
        {
            
        }
        else if indexPath.row==5
        {
            
        }
        if indexPath.row > 5 && arrHealthList.count > 0
        {
            
            if indexPath.row <= arrHealthList.count + 5
            {
                let details = arrHealthList[indexPath.row-6]
                
                let name = details.name
                if selectedName .contains(name)
                {
                    selectedName.remove(name)
                }
                else
                {
                    selectedName.add(name)
                }
                tblVwBecomeADonor.reloadData()
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    }
}
// MARK: - UITextField Delegates
extension BecomeADonorViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! // check textfield contains value or not
        {
            if textField.tag == 3
            {
                userHeight = textField.text!
            }
            else if textField.tag == 4
            {
                userWeight = textField.text!
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
// MARK: - PickerView Datasource and Delegates
extension BecomeADonorViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pkrvw
        {
            return pickOption.count
        }
        else
        {
            return arrBloodList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == pkrvw
        {
            return pickOption[row]
        }
        else
        {
            let details = arrBloodList[row]
            return details.name
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pkrvw
        {
            userGender = pickOption[row]
            let indexPath = NSIndexPath(row: 1, section: 0)
            self.tblVwBecomeADonor.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
        else
        {
            let details = arrBloodList[row]
            userBlood = details.name!
            let indexPath = NSIndexPath(row: 2, section: 0)
            self.tblVwBecomeADonor.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
