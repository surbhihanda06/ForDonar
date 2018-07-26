//
//  AddCommentController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 06/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class AddCommentController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tvText: UITextView!
    @IBOutlet weak var btnDone: UIButton!
    
    var userId: Int!
    var CampaignId: Int!
    var campaignPosterId: Int!
    var strPurpose = ""
    var userImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userId = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        tvText.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        tvText.delegate = self
        btnDone.layer.cornerRadius = 4
        btnDone.layer.masksToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tvText.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Service Call
    func addComment(campaignId: Int)
    {
        
        SVProgressHUD.show()
        let id = String(campaignId)
        
        let prmList:[String: Any] = ["campaignId":campaignId,"message": tvText.text,"userId": userId]
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/campaign/\(id)/comment")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: PostCommentResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData?.ack != nil
            {
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
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
    func addUpdate(campaignId: Int)
    {
        SVProgressHUD.show()
        let id = String(campaignId)
        
        let prmList:[String: Any] = ["campaignId":campaignId,"message": tvText.text,"userId": userId]
        let request = MakePostRequest.init(parameterList: prmList, APIName: "/campaign/\(id)/update")
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: PostCommentResponse?) in
            
            SVProgressHUD.dismiss()
            if getMyData?.ack != nil
            {
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
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

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDonePressed(_ sender: Any)
    {
        if strPurpose == "Comment"
        {
            addComment(campaignId: CampaignId)
        }
        else
        {
            addUpdate(campaignId: CampaignId)
        }
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        print("your code when clicked on done")
    }
    
    //MARK: - TextView Delegate Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            
            return false
            
        }
        
        return true
    }
    
}
