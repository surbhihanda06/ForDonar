//
//  DescriptionController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 11/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class DescriptionController: UIViewController {

    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    var strDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDescription.text = strDescription

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Description".localized
    }
    
    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
}
