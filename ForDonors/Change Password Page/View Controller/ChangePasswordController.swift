//
//  ChangePasswordController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {

    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwOldPassword: UIView!
    @IBOutlet weak var vwNewPassword: UIView!
    @IBOutlet weak var vwConfirmPassword: UIView!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var imgVwOldPassword: UIImageView!
    
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var imgVwNewPassword: UIImageView!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var imgVwConfirmPassword: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vwOldPassword.layer.masksToBounds = true
        vwOldPassword.layer.borderWidth = 2
        vwOldPassword.layer.borderColor = UIColor(red: 65/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1).cgColor
        vwOldPassword.layer.cornerRadius = 4
        
        vwNewPassword.layer.masksToBounds = true
        vwNewPassword.layer.borderWidth = 2
        vwNewPassword.layer.borderColor = UIColor(red: 65/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1).cgColor
        vwNewPassword.layer.cornerRadius = 4
        
        vwConfirmPassword.layer.masksToBounds = true
        vwConfirmPassword.layer.borderWidth = 2
        vwConfirmPassword.layer.borderColor = UIColor(red: 65/255.0, green: 164/255.0, blue: 225/255.0, alpha: 1).cgColor
        vwConfirmPassword.layer.cornerRadius = 4
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Change Password".localized
    }
    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOldPasswordPressed(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            imgVwOldPassword.image = UIImage(named: "visible")
            sender.tag = 1
            tfOldPassword.isSecureTextEntry = false
        }
        else
        {
            imgVwOldPassword.image = UIImage(named: "notVisible")
            sender.tag = 0
            tfOldPassword.isSecureTextEntry = true
        }
    }
    @IBAction func btnNewPasswordPressed(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            imgVwNewPassword.image = UIImage(named: "visible")
            sender.tag = 1
            tfNewPassword.isSecureTextEntry = false
        }
        else
        {
            imgVwNewPassword.image = UIImage(named: "notVisible")
            sender.tag = 0
            tfNewPassword.isSecureTextEntry = true
        }
    }
    @IBAction func btnCofirmPasswordPressed(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            imgVwConfirmPassword.image = UIImage(named: "visible")
            sender.tag = 1
            tfConfirmPassword.isSecureTextEntry = false
        }
        else
        {
            imgVwConfirmPassword.image = UIImage(named: "notVisible")
            sender.tag = 0
            tfConfirmPassword.isSecureTextEntry = true
        }
    }
    
}
