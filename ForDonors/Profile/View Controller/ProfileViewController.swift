//
//  ProfileViewController.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 15/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var lblSocialConnection: UILabel!
    @IBOutlet weak var connectntTypTblVw: UITableView!
   @IBOutlet weak var userImgVw: UIImageView!
   @IBOutlet weak var removeDonrBtn: UIButton!
   @IBOutlet weak var organImgVw: UIImageView!
   @IBOutlet weak var specializatnLbl: UILabel!
   @IBOutlet weak var ageLbl: UILabel!
   @IBOutlet weak var phnNoLbl: UILabel!
   @IBOutlet weak var locationLbl: UILabel!
   @IBOutlet weak var userNameLbl: UILabel!
    var fnameString :String = ""
    var lnameString :String = ""
    
    var fbId: String!
    var gplusId: String!
    var tweeterId: String!
    var linkdinId: String!
    var instagramId: String!
    
   // let conntnType: [String] = ["Connected Via Facebook", "Not Connected Via Facebook", "Not Connected Via Linkedin", "Not Connected Via Facebook"]
    
    let conntnType: [String] = ["Facebook", "Twitter", "Linkedin",  "Instagram", "google Plus"]
    let ImageArr: [String] = ["facebook-logo", "twitter-logo", "linkedin-1", "instagram-1", "google-plus"]
    var arrConnectd: [Bool] = [false, false, false, false,false]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        connectntTypTblVw.delegate=self
        connectntTypTblVw.dataSource=self
        connectntTypTblVw.register(UINib(nibName: "ConnectionTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "ConnectionTypeCell")
        userImgVw.layer.cornerRadius = userImgVw.frame.size.height/2
        userImgVw.clipsToBounds = true
        removeDonrBtn.layer.cornerRadius = 10.0
    }
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Profile".localized
        lblSocialConnection.text = "Social Connection".localized
        removeDonrBtn.setTitle("Remove DonorPro".localized, for: .normal)
        
        let prefs = UserDefaults.standard
        let fname: String = prefs.string(forKey: "FName") ?? ""
        let lname: String = prefs.string(forKey: "LName") ?? ""
        let emailstr: String = prefs.string(forKey: "email") ?? ""
        self.userNameLbl.text = fname + " " + lname
        self.phnNoLbl.text = prefs.string(forKey: "phoneNumber") ?? ""
        //self.userEmail.text = emailstr
        
        let city: String = prefs.string(forKey: "city") ?? ""
        let state: String = prefs.string(forKey: "state") ?? ""
        let country: String = prefs.string(forKey: "country") ?? ""
        self.locationLbl.text = city + ", " + state + ", " + country
        if let expireDate = prefs.string(forKey: "birthDate"), expireDate.count > 0
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateOnlyFormat
            let now = Date()
            let birthday: Date = dateFormatter.date(from: expireDate)!
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year ?? 0
            self.ageLbl.text = String(age) + " yrs"
        }
        
        if let userImage = prefs.string(forKey: "profileImg")
        {
            let getImage = UrlUtil.getUserImage(image: userImage)
            userImgVw.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
        }
        else
        {
            userImgVw.image = UIImage(named: Default_Image)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: backBtnAction
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func removeDonarAction(_ sender: Any) {
        
        
    }
    @IBAction func editProfileAction(_ sender: Any) {
        //let userdic = ["Name": self.userNameLbl.text ?? "", "Phone": self.phnNoLbl.text ?? "", "location": self.locationLbl.text ?? "", "Age": self.ageLbl.text ?? "", "designation": self.specializatnLbl.text ?? "", "fname": fnameString, "lname": lnameString, "userImage": userImgVw.image ?? "", "fbId": fbId, "tweeterId": tweeterId, "linkdinId": linkdinId, "instagramId": instagramId, "googleId": gplusId ] as [String : Any]
        let vc = EditProfileViewController ()
        //vc.userdetails = userdic as NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchUserInfo()
    {
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        let prmList:[String: Any] = [:]
        let apiName = "/user/\(userId)"
        let request = MakePostRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: UserDetailsResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                let fname = getMyData?.first_name
                let lname = getMyData?.last_name
                let phnNo = getMyData?.phnNo
                self.fnameString = fname!
                self.lnameString = lname!
                self.userNameLbl.text = fname! + " " + lname!
                self.phnNoLbl.text = phnNo!
                //let street = getMyData?.street!
                let city = getMyData?.city!
                let state = getMyData?.state!
                
                let profileImgURL = UrlUtil.getUserImage(image:(getMyData?.profileImg!)!)
                
                if let userImage = getMyData?.profileImg
                {
                    let getImage = UrlUtil.getUserImage(image: userImage)
                    self.userImgVw.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: Default_Image))
                }
                else
                {
                    self.userImgVw.image = UIImage(named: Default_Image)
                }

                
                //self.userImgVw.sd_setImage(with: URL(string: profileImgURL ), placeholderImage: UIImage(named: Default_Image))
                
                /*Alamofire.request(profileImgURL).responseImage { response in
                    if let image = response.result.value {
                        self.userImgVw.image = image
                    }
                }*/
                    
                    
                //self.locationLbl.text = street! + "," + city! + "," + state!
                /*
                if (getMyData?.age != nil)
                {
                    self.ageLbl.text = getMyData?.age
                }
                else{
                    self.ageLbl.text = "Age Not Set."
                }
                if (getMyData?.designation != nil)
                {
                    self.specializatnLbl.text = getMyData?.designation
                }
                else{
                    
                    self.specializatnLbl.text = "Designation Not Available."
                }
                if (getMyData?.imageUrlstr != nil)
                {
                    self.userImgVw.sd_setImage(with: URL(string: (getMyData?.imageUrlstr!)! ), placeholderImage: UIImage(named: Default_Image))
                }
                
                print("facebok id is",getMyData?.fb_id ?? "")
                self.fbId = getMyData?.fb_id ?? ""
                if (getMyData?.fb_id != nil && self.fbId != "")
                {
                    self.arrConnectd[0] = true
                }
                else{
                    self.arrConnectd[0] = false
                }
                
                print("twitter id is",getMyData?.twitter_id ?? "")
                self.tweeterId = getMyData?.twitter_id ?? ""
                if (getMyData?.twitter_id != nil && self.tweeterId != "")
                {
                    self.arrConnectd[1] = true
                }
                else{
                    self.arrConnectd[1] = false
                }
                
                print("instagram id is",getMyData?.instagram_id ?? "")
                self.instagramId = getMyData?.instagram_id ?? ""
                if (getMyData?.instagram_id != nil && self.instagramId != "")
                {
                    self.arrConnectd[3] = true
                }
                else{
                    self.arrConnectd[3] = false
                }
                
                print("linkedin id is",getMyData?.linkedin_id ?? "")
                self.linkdinId = getMyData?.linkedin_id ?? ""
                if (getMyData?.linkedin_id != nil && self.linkdinId != "")
                {
                    self.arrConnectd[2] = true
                }
                else{
                    self.arrConnectd[2] = false
                }
                
                print("google id is",getMyData?.google_id ?? "")
                self.gplusId = getMyData?.google_id ?? ""
                if (getMyData?.google_id != nil && self.gplusId != "")
                {
                    self.arrConnectd[4] = true
                }
                else{
                    self.arrConnectd[4] = false
                }
                */
                UserDefaults.standard.set(getMyData?.id, forKey:
                    "userId")
                UserDefaults.standard.set(getMyData?.first_name, forKey:
                    "FName")
                UserDefaults.standard.set(getMyData?.last_name, forKey:
                    "LName")
                UserDefaults.standard.set(getMyData?.email, forKey:
                    "Email")
                self.connectntTypTblVw.reloadData()
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
extension ProfileViewController:UITableViewDataSource, UITableViewDelegate
{
    // MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionTypeCell", for: indexPath) as! ConnectionTypeCell
        
        if arrConnectd[indexPath.row]
        {
            cell.connectionTypeName.text = "Connected Via " +  self.conntnType[indexPath.row]
            cell.connectionTypeName.textColor = UIColor.black
            cell.switchLogo?.isOn = true
            cell.connectionLogo?.image = cell.connectionLogo?.image?.withRenderingMode(.alwaysTemplate)
            cell.connectionLogo?.tintColor =  UIColor (red: 0/255.0, green: 166/255.0, blue: 222/255.0, alpha: 1.0)
            cell.connectionLogo?.image=UIImage.init(named: ImageArr[indexPath.row])
        }
        else{
            cell.connectionTypeName.textColor = UIColor.lightGray
            cell.switchLogo?.isOn = false
            cell.connectionTypeName.text = "Not Connected Via " +  self.conntnType[indexPath.row]
            cell.connectionLogo?.image=UIImage.init(named: ImageArr[indexPath.row])
            cell.connectionTypeName.text =  self.conntnType[indexPath.row]
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}
