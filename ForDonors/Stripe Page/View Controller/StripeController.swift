//
//  StripeController.swift
//  DigitalDentalStaff
//
//  Created by NITS Mac2 on 10/07/17.
//  Copyright © 2017 NITS Mac2. All rights reserved.
//

import UIKit
import Stripe

class StripeController: UIViewController, STPPaymentCardTextFieldDelegate{

    var strStripeToken: String?
    var strUserId: String?
    var strUserType: String?
    var paymentField = STPPaymentCardTextField()
    var buyButton = UIButton()
    var vwBack = UIView()
    var backButton = UIButton()
    
    var strPlanId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        paymentField = STPPaymentCardTextField(frame: CGRect(x: 20, y: 70, width:self.view.frame.size.width - 40, height: 44))
        paymentField.delegate = self
        self.view.addSubview(paymentField)
        paymentField.cardParams.number = "564478797446"
        paymentField.cardParams.expMonth = 02
        paymentField.cardParams.expYear = 19
        
        buyButton.backgroundColor = UIColor.red
        buyButton = UIButton(frame: CGRect(x: self.view.frame.size.width / 2 - 30, y: paymentField.frame.origin.y + paymentField.frame.size.height + 10, width: 60, height: 44))
        buyButton.setTitle("Done", for: UIControlState.normal)
        buyButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        self.view.addSubview(buyButton)
        
        vwBack = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40))
        
        backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        let image = UIImage(named: "left-arrow")
        backButton.setBackgroundImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        vwBack.addSubview(backButton)
        self.view.addSubview(vwBack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print("Card number: \(textField.cardParams.number) Exp Month: \(textField.cardParams.expMonth) Exp Year: \(textField.cardParams.expYear) CVC: \(textField.cardParams.cvc)")
        self.buyButton.isEnabled = textField.isValid
    }
    
    @objc func buyButtonTapped()
    {
        let cardParams = STPCardParams()
        cardParams.number = self.paymentField.cardNumber
        cardParams.expMonth = 10
        cardParams.expYear = 2018
        cardParams.cvc = "123"
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                print(error)
            } else if let token = token {
                self.strStripeToken = token.tokenId
                print(self.strStripeToken ?? "")
                
                let request = PaymentStripeRequest(user_id: self.strUserId!, memberShipID: self.strUserType!, tokenID: self.strStripeToken!, planID: self.strPlanId!)
                RequestExecutor.executeRequest(request, completion: {(error: Error?, stripeResponse: PaymentStripeResponse?) in
                    if stripeResponse != nil
                    {
                        let request = ChooseMembershipRequest(user_id: self.strUserId!, memberShipID: self.strUserType!, tokenID: (stripeResponse?.strTxnId)!, planID: self.strPlanId!)
                        RequestExecutor.executeRequest(request, completion: {(error: Error?, membershipResponse: ChooseMembershipResponse?) in
                            if membershipResponse != nil
                            {
                                Alert.disPlayAlertMessage(titleMessage: "", alertMsg: "You have choosen your membership")
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                            else
                            {
                                
                                
                            }
                        })
                    }
                    else
                    {
                        
                        
                    }
                })
            }
        }
    }
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        paymentMethodsViewController.dismiss(completion: nil)
    }
    
    @objc func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
