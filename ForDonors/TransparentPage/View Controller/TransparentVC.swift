
//
//  TransparentVC.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import UIKit
import ReachabilitySwift
var reachability: Reachability?
class TransparentVC: UIViewController
{
    
    @IBOutlet var lblText: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var imgvwUser: UIImageView!
    var message:String!
    var type: String!
    var strUsrId: String!
    var tmrClose:Timer!
    var dictUser:NSMutableDictionary!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        tmrClose = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(closeController), userInfo: nil, repeats: false)
        
        if type == "1"
        {
            imgvwUser.image = UIImage(named: "heartBeat")
            lblTitle.text = "ForDonor"
            lblText.text = message
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnMessageTapped(_ sender: Any)
    {
        if type == "1"
        {
            closeController()
        }
    }
    
    @IBAction func CloseView ()
    {
        closeController()
    }
    @objc func closeController()
    {
        tmrClose.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func reAllocateTimer(strMsg: String, strType: String, strUserId: String)
    {
        tmrClose.invalidate()
        tmrClose = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(closeController), userInfo: nil, repeats: false)
        
        message = strMsg
        type = strType
        strUsrId = strUserId
        
        if type == "1"
        {
            imgvwUser.image = UIImage(named: "heartBeat")
            lblTitle.text = "ForDonor"
            lblText.text = message
        }
    }
    
    
    
}



