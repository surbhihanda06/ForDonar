//
//  QuickDonationController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 11/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuickDonationController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwOneDollar: UIView!
    @IBOutlet weak var vwFiveDollar: UIView!
    @IBOutlet weak var vwTenDollar: UIView!
    @IBOutlet weak var vwTwentyDollar: UIView!
    @IBOutlet weak var vwMore: UIView!
    
    @IBOutlet weak var vwTransparent: UIView!
    
    var amount: String = ""
    var campaignId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwTransparent.addGestureRecognizer(tap)
        
        setViewBorder(vw: vwOneDollar)
        setViewBorder(vw: vwFiveDollar)
        setViewBorder(vw: vwTenDollar)
        setViewBorder(vw: vwTwentyDollar)
        setViewBorder(vw: vwMore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = "Quick Donations".localized
    }
    
    // MARK: - Action
    
    func setViewBorder(vw: UIView)
    {
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = vw.frame.size.height / 2
        vw.layer.shadowColor = UIColor.darkGray.cgColor
        vw.layer.shadowOffset = CGSize(width: 0, height: 0)
        vw.layer.shadowRadius = 2
        vw.layer.shadowOpacity = 1.0
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnDollarOnePressed(_ sender: Any)
    {
        amount = "1"
        saveCardDetails()
        
    }
    @IBAction func btnFiveDollarPressed(_ sender: Any)
    {
        amount = "5"
        saveCardDetails()
        
    }
    @IBAction func btnTendollarPressed(_ sender: Any)
    {
        amount = "10"
        saveCardDetails()
        
    }
    @IBAction func btnTwentyDollarPressed(_ sender: Any)
    {
        amount = "20"
        saveCardDetails()
        
    }
    @IBAction func btnMorePressed(_ sender: Any)
    {
        dismissController()
    }
    
    func dismissController()
    {
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = PaymentDetailsController()
                pvc.present(vc, animated: true, completion: nil)
                vc.strAmount = self.amount
                vc.campaignId = self.campaignId
            })
        }
    }
    //MARK: - Service Call
    
    func saveCardDetails()
    {
        
        //http://fordonor.us-west-2.elasticbeanstalk.com/api/payment/charge/create
        SVProgressHUD.show()
        let userId = UserDefaults.standard.object(forKey: "userId") ?? ""
        let prefs = UserDefaults.standard
        let fname: String = prefs.string(forKey: "FName") ?? ""
        let lname: String = prefs.string(forKey: "LName") ?? ""
        let userName = fname + " " + lname
        
        let campaign = String(campaignId)
        
        //        let prmList:[String: Any] = ["userId":"\(userId)", "campaignId":campaign, "type": "card", "amount": tfAmount.text ?? "", "currency":"USD", "number":tfCardNumber.text ?? "","exp_month": gateMonth, "exp_year": gateYear, "cvc": tfCVV.text!, "description": "This is for test"]
        
        
        var invoice:Dictionary = [String: Any]()
        invoice["amount"]="500"
        
        var contribution:Dictionary = [String: Any]()
        contribution["contributorId"]="\(userId)"
        contribution["campaignId"]=campaign
        contribution["alias"]=userName
        contribution["invoice"]=invoice
        
        var paymentCard:Dictionary = [String: Any]()
        paymentCard["type"]=""
        paymentCard["number"]=""
        paymentCard["exp_month"]=""
        paymentCard["exp_year"]=""
        paymentCard["cvc"]=""
        paymentCard["description"]=""
        
        var prmList:Dictionary = [String: Any]()
        prmList["contribution"]=contribution
        //prmList["paymentCard"]=paymentCard
        
        
        
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/payment/charge/create")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: PaymentDetailsResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                if getMyData?.data != nil
                {
                    
                    Alert.disPlayAlertMessage(titleMessage: "Done!", alertMsg: "You have paid successfully")
                }
                else
                {
                    self.dismissController()
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
