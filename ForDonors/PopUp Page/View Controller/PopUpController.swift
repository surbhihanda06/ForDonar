//
//  PopUpController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 30/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class PopUpController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStaticDesc: UILabel!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var btnIdentity: UIButton!
    @IBOutlet weak var btnBankingInformation: UIButton!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var vwTransparent: UIView!
    
    var isVerified = Bool()
    var existBankAccount = ""
    var creatorImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwTransparent.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        vwBg.layer.cornerRadius = 10
        vwBg.layer.masksToBounds = true
        
        imgVwUser.layer.cornerRadius = imgVwUser.frame.size.height / 2
        imgVwUser.layer.masksToBounds = true
        
        vwImage.layer.cornerRadius = vwImage.frame.size.height / 2
        vwImage.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = "Campaign is Published".localized
        lblStaticDesc.text = "Note that Verified Campaigns get more attention. User is required to verify identity and banking information to receive funding when Campaign ends. Funding is deposit after 2 weeks closing of campaign.".localized
        btnIdentity.setTitle("Verify Identity".localized, for: .normal)
        btnBankingInformation.setTitle("Enter Banking Information".localized, for: .normal)
        
        let getImage = UrlUtil.getUserImage(image: self.creatorImage)
        self.imgVwUser.sd_setImage(with: URL(string: getImage), placeholderImage: UIImage(named: "defaultImage"))
        
        btnBankingInformation.layer.masksToBounds = true
        btnBankingInformation.layer.cornerRadius = 18
        
        btnIdentity.layer.masksToBounds = true
        btnIdentity.layer.cornerRadius = 18
        let isBankAdded: Bool = (UserDefaults.standard.bool(forKey: "isBanking"))
        let isVerified: Bool = (UserDefaults.standard.bool(forKey: "isVerified"))
        
        if isVerified == true
        {
            btnIdentity.layer.borderWidth = 1
            btnIdentity.layer.borderColor =  UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1).cgColor
            btnIdentity.setTitleColor(UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1), for: .normal)
            btnIdentity.isUserInteractionEnabled = false
        }
        else
        {
            btnIdentity.backgroundColor = UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1)
            btnIdentity.setTitleColor(.white, for: .normal)
            btnIdentity.isUserInteractionEnabled = true
        }
        
        if isBankAdded == true
        {
            btnBankingInformation.layer.borderWidth = 1
            btnBankingInformation.layer.borderColor =  UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1).cgColor
            btnBankingInformation.setTitleColor(UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1), for: .normal)
            btnBankingInformation.isUserInteractionEnabled = false
        }
        else
        {
            btnBankingInformation.backgroundColor = UIColor(red: 64/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1)
            btnBankingInformation.setTitleColor(.white, for: .normal)
            btnBankingInformation.isUserInteractionEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnVerifyIdentityPressed(_ sender: Any)
    {
        print("Verify")
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = VerificationController()
                pvc.present(vc, animated: true, completion: nil)
                vc.fromPage = "PopUp"
            })
        }
        
    }
    @IBAction func btnBankingPressed(_ sender: Any)
    {
        print("Banking")
        if let pvc = self.presentingViewController
        {
            self.dismiss(animated: true, completion: {
                let vc = BankingInfoController()
                pvc.present(vc, animated: true, completion: nil)
            })
        }
 
    }
    func dismissController()
    {
        if let pvc = self.presentingViewController as? UINavigationController
        {
            self.dismiss(animated: true, completion: {
                
                var inLoop = false
                for vc in pvc.viewControllers
                {
                    if vc.isKind(of: PaymentDetailsController.self)
                    {
                        inLoop = true
                        pvc.popToViewController(vc, animated: true)
                        break
                    }
                }
                if !inLoop
                {
                    let homevc = PaymentDetailsController()
                    pvc.navigationController?.pushViewController(homevc, animated: true)
                }
            })
        }
    }

}
