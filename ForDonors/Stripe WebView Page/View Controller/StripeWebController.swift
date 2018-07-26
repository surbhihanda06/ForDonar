//
//  StripeWebController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 15/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class StripeWebController: UIViewController {
    @IBOutlet weak var wbVwStripe: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //http://192.168.1.65:8080/api/payment/payment_redirecturi
        // Do any additional setup after loading the view.
        wbVwStripe.loadRequest(URLRequest(url: URL(string: "http://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_CrMWjARhrupsRBm2PsqDBNfZmdDZ8J6p&redirect_uri=http://192.168.1.65:8080/api/payment/payment_redirecturi")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        dismissController()
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
    
}
extension NSURLRequest {
    #if DEBUG
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
    #endif
}
