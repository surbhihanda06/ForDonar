//
//  SettingsController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 04/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var lblPageTitle: UILabel!
    
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblEditAccount: UILabel!
    @IBOutlet weak var lblAddDonor: UILabel!
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblPreference: UILabel!
    @IBOutlet weak var lblLocalization: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    
    
    @IBOutlet weak var vwLanguage: UIView!
    @IBOutlet weak var vwTransparent: UIView!
    @IBOutlet weak var vwOptions: UIView!
    @IBOutlet weak var lblCountryName: UILabel!
    
    var navController:UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Settings".localized
        lblAccount.text = "Account".localized
        lblEditAccount.text = "Edit Account".localized
        lblAddDonor.text = "Add Donor".localized
        lblChangePassword.text = "Change Password".localized
        lblPreference.text = "Preference".localized
        lblLocalization.text = "Localization".localized
        lblRegion.text = "Region".localized
        
        vwLanguage.isHidden = true
        vwOptions.layer.masksToBounds = true
        vwOptions.layer.cornerRadius = 4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAccountPressed(_ sender: Any) {
    }
    @IBAction func btnEditAccountPressed(_ sender: Any) {
    }
    @IBAction func btnAddDonorPressed(_ sender: Any)
    {
        let moveViewController = VerificationController()
        self.navigationController?.present(moveViewController, animated: false, completion: nil)
    }
    @IBAction func btnChangePasswordPressed(_ sender: Any) 
    {
        let moveViewController = ChangePasswordController()
        self.navigationController?.pushViewController(moveViewController, animated: true)
    }
    @IBAction func btnPreferencePressed(_ sender: Any) {
    }
    @IBAction func btnLocalizationPressed(_ sender: Any)
    {
        vwLanguage.isHidden = false
    }
    @IBAction func btnRegionPressed(_ sender: Any)
    {
        let moveViewController = CountryListController()
        self.present(moveViewController, animated: true, completion: nil)
        moveViewController.delegate = self
    }
    @IBAction func btnEnglishPressed(_ sender: Any)
    {
        vwLanguage.isHidden = true
        UserDefaults.standard.set("en-US", forKey:"AppleLanguages")
        Locale.preferredLanguage = "en-US"
        
        lblPageTitle.text = "Settings".localized
        lblAccount.text = "Account".localized
        lblEditAccount.text = "Edit Account".localized
        lblAddDonor.text = "Add Donor".localized
        lblChangePassword.text = "Change Password".localized
        lblPreference.text = "Preference".localized
        lblLocalization.text = "Localization".localized
        lblRegion.text = "Region".localized
        
        
    }
    @IBAction func btnJapanesePressd(_ sender: Any)
    {
        
        vwLanguage.isHidden = true
        UserDefaults.standard.set("ja", forKey:"AppleLanguages")
        Locale.preferredLanguage = "ja"
        
        lblPageTitle.text = "Settings".localized
        lblAccount.text = "Account".localized
        lblEditAccount.text = "Edit Account".localized
        lblAddDonor.text = "Add Donor".localized
        lblChangePassword.text = "Change Password".localized
        lblPreference.text = "Preference".localized
        lblLocalization.text = "Localization".localized
        lblRegion.text = "Region".localized
 
        /*
        UIApplication.topViewController()?.dismiss(animated: true, completion:
            {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let NextController = HomeController(nibName: "HomeController", bundle: nil)
                self.navController = UINavigationController(rootViewController: NextController)
                self.navController?.isNavigationBarHidden = true
                delegate.window?.rootViewController = self.navController
        })*/
    }
    @IBAction func btnVietnamesePressed(_ sender: Any)
    {
        vwLanguage.isHidden = true
        UserDefaults.standard.set("vi", forKey:"AppleLanguages")
        Locale.preferredLanguage = "vi"
        
        lblPageTitle.text = "Settings".localized
        lblAccount.text = "Account".localized
        lblEditAccount.text = "Edit Account".localized
        lblAddDonor.text = "Add Donor".localized
        lblChangePassword.text = "Change Password".localized
        lblPreference.text = "Preference".localized
        lblLocalization.text = "Localization".localized
        lblRegion.text = "Region".localized
    }
    
}
//MARK :- CountryPickerViewControllerDelegate
extension SettingsController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: CountryNew)
    {
        print("countryPickerViewControllerDidCancel: \(countryPickerViewController)")
        
        dismiss(animated: true, completion: {
            self.lblCountryName.text = country.name
        })
    }
    
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController) {
        print("countryPickerViewControllerDidCancel: \(countryPickerViewController)")
        
        dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country) {
        print("countryPickerViewController: \(countryPickerViewController) didSelectCountry: \(country)")
        
        dismiss(animated: true, completion: nil)
    }
}
extension SettingsController:CountryListDelegate
{
    func getCountryDetails(countryId: String, countryName: String,countrySortname: String)
    {
        self.lblCountryName.text = countryName
        UserDefaults.standard.set(countryId, forKey:"UserCountry")
//        strCountryId = countryId
//        self.tfState.text = ""
//        self.tfCity.text = ""
    }
}
