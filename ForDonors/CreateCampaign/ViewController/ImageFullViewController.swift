//
//  ImageFullViewController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController {

    @IBOutlet weak var imgvwPreview: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    var urlImg:URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgvwPreview.sd_setImage(with: urlImg, placeholderImage: UIImage(named: No_Image))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnCloseTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
