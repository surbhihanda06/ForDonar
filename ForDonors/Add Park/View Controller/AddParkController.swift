//
//  AddParkController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 26/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol AddParkControllerDalegate: class {
    func getPerkData(PerkDetails: Perks!)
}

class AddParkController: UIViewController  {

    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var vwImage: UIImageView!
    @IBOutlet weak var btnAddItem: UIButton!
    
    @IBOutlet weak var tblVwAddPerk: UITableView!
    
    weak var delegate: AddParkControllerDalegate?
    
    var arrItems: NSMutableArray = NSMutableArray()
    
    var strImageUrl: String!
    
    var selectedDate : String = ""
    
    var perkTitle = ""
    var perkPrice = ""
    var perkDescription = ""
    var perkEstimatedDeliveryDate = ""
    var perkShippingPrice = ""
    var perkItem = ""
    
    var image = UIImage()
    
    var imagePickerController = UIImagePickerController()
    let staticRow = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cellRegistration()
        //btnAddItem.layer.masksToBounds = true
        //btnAddItem.layer.cornerRadius = 12
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblPageTitle.text = "Add Park".localized
        btnNext.setTitle("Next".localized, for: .normal)
    }
    
    func cellRegistration()   {
        
        self.tblVwAddPerk.delegate=self
        self.tblVwAddPerk.dataSource=self
        self.tblVwAddPerk.register(UINib(nibName: "PerkImageCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkImageCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkTitleCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkPriceCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkPriceCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkDescriptionCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkDescriptionCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkDeliveryDateCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkDeliveryDateCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkShippingPriceCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkShippingPriceCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "PerkItemsCell", bundle: Bundle.main), forCellReuseIdentifier: "PerkItemsCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "AddItemCell", bundle: Bundle.main), forCellReuseIdentifier: "AddItemCell")
        
        self.tblVwAddPerk.register(UINib(nibName: "AddPerkItemCell", bundle: Bundle.main), forCellReuseIdentifier: "AddPerkItemCell")
       
    }

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateOnlyFormat
        selectedDate = dateFormatter.string(from: sender.date)
        let indexPath = NSIndexPath(row: 4, section: 0)
        self.tblVwAddPerk.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    @objc func dateDoneButtonClicked(_ sender: UITextField) {
        //your code when clicked on done
        if selectedDate.isEmpty
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateOnlyFormat
            selectedDate = dateFormatter.string(from: Date())
        }
        self.tblVwAddPerk.reloadData()
        
    }
    @objc func gallaryClick(sender: UIButton!)
    {
        attachmentActionSheetForImage()
    }
    @objc func AddItem(sender: UIButton!)
    {
        arrItems.add("")
        self.tblVwAddPerk.reloadData()
        //attachmentActionSheetForImage()
    }
    private func attachmentActionSheetForImage()
    {
        /*let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Take Photo from Camera", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePickerForImage(type: "takePhoto")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Choose Photo from Album", style:UIAlertActionStyle.default, handler:{ action in
            self.showImagePickerForImage(type: "choosePhoto")
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)*/
        
        self.showImagePickerForImage(type: "choosePhoto")
    }
    func showImagePickerForImage(type:String)
    {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        if type == "takePhoto"
        {
            //imagePickerController.cameraCaptureMode = .photo
            if (UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                imagePickerController.sourceType = .camera
            }
            else
            {
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                present(
                    alertVC,
                    animated: true,
                    completion: nil)
            }
        }
        else
        {
            imagePickerController.sourceType = .photoLibrary
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnNextPressed(_ sender: Any)
    {
        if image == nil
        {
            Alert.disPlayAlertMessage(titleMessage: "Perk Image", alertMsg: "Please add an image!")
            return
        }
        else
            if perkTitle.isEmpty
            {
                Alert.disPlayAlertMessage(titleMessage: "Perk Title", alertMsg: "Please enter perk title!")
                return
            }
            else if perkPrice.isEmpty
            {
                Alert.disPlayAlertMessage(titleMessage: "Perk Price", alertMsg: "Please enter perk price!")
                return
            }
            else if perkDescription.isEmpty
            {
                Alert.disPlayAlertMessage(titleMessage: "Perk Description", alertMsg: "Please enter perk description!")
                return
            }
            else if selectedDate.isEmpty
            {
                Alert.disPlayAlertMessage(titleMessage: "Delivery Date", alertMsg: "Please enter estimated delivery date!")
                return
            }
//            else if perkShippingPrice.isEmpty
//            {
//                Alert.disPlayAlertMessage(titleMessage: "Shipping Price", alertMsg: "Please enter shipping price!")
//                return
//            }
            else
            {
                var allPerkList = [Perks]()
                let perk: Perks = Perks.init(title: perkTitle, description: perkDescription, price: perkPrice, date: selectedDate, image: image, items: arrItems, shippingPrice: perkShippingPrice)
                
                allPerkList.append(perk)
                delegate?.getPerkData(PerkDetails: perk)
                _ = self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnAddItemPressed(_ sender: Any)
    {
        
    }
    //MARK: - Service Call
    func imageUpload(file: Any)
    {
        SVProgressHUD.show()
        let prmList:[String: Any] = ["inputFile": file]
        let request = MakePostRequest.init(parameterList: prmList, APIName: "campaign/uploadfile")
        RequestExecutor.uploadRequest(request, completion:{ (error: Error?, getMyData: FileUploadResponse?) in
            SVProgressHUD.dismiss()
            if getMyData != nil
            {
                self.strImageUrl = getMyData?.url as! String
                
                //let username: String = getMyData!.Name!
                //let role: String = getMyData!.Role!
                
                self.view.endEditing(true)
                //_=self.navigationController?.popToRootViewController(animated: true)
                //Alert.disPlayAlertMessage(titleMessage: "Login Success", alertMsg: "Thank you \(username), for logging in as \(role)")
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
extension AddParkController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
//        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageView = UIImageView()
        imageView.image = selectedImage
        image = selectedImage
        self.tblVwAddPerk.reloadData()
        //imageUpload(file: selectedImage)
        dismiss(animated: true, completion: nil)
    }
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddParkController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = arrItems.count
        return count + staticRow
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row==0
        {
            return 180
        }
        else if indexPath.row==1
        {
            
            return 80
        }
        else if indexPath.row==2
        {
            
            return 104
        }
        else if indexPath.row==3
        {
            
            return 110
        }
        else if indexPath.row==4
        {
            
            return 103
        }
        else if indexPath.row==5
        {
            
            return 100
        }
        else if indexPath.row==6
        {
            return 46
        }
        if arrItems.count > 0 && indexPath.row > 6
        {
            if arrItems.count >= indexPath.row - 6
            {
                return 63
            }
            else
            {
                return 130
            }
        }
        else
        {
            //return 130
            //MALLIKA
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row==0
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PerkImageCell", for: indexPath) as! PerkImageCell
            cell.btnImage?.addTarget(self, action: #selector(self.gallaryClick), for: UIControlEvents.touchUpInside)
            cell.btnImage.tag = indexPath.row
           cell.imgVwPerkImage.image = image
            cell.cameraBorderImgVW.image = cell.cameraBorderImgVW.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.cameraBorderImgVW.tintColor = UIColor.lightGray
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkTitleCell") as! PerkTitleCell
            cell.tfTitle.tag = indexPath.row
            cell.tfTitle.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkPriceCell") as! PerkPriceCell
            cell.tfPrice.tag = indexPath.row
            cell.tfPrice.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkDescriptionCell") as! PerkDescriptionCell
            cell.tvDescription.tag = indexPath.row
            cell.tvDescription.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkDeliveryDateCell") as! PerkDeliveryDateCell
            
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.minimumDate = Date()
            if selectedDate.isEmpty
            {
                datePickerView.date = Date()
            }
            else
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateOnlyFormat
                let date = dateFormatter.date(from: selectedDate)
                datePickerView.date = date ?? Date()
            }
            
            datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            cell.tfDeliveryDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(dateDoneButtonClicked(_:)))
            
            cell.tfDeliveryDate.inputView = datePickerView
            cell.tfDeliveryDate.text = selectedDate
            cell.tfDeliveryDate.tag = indexPath.row
            cell.tfDeliveryDate.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkShippingPriceCell") as! PerkShippingPriceCell
            cell.tfShippingPrice.tag = indexPath.row
            cell.tfShippingPrice.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row==6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerkItemsCell") as! PerkItemsCell
            cell.selectionStyle = .none
            return cell
        }
        
        if arrItems.count > 0 && indexPath.row > 6
        {
            if arrItems.count >= indexPath.row - 6 //indexPath.row - 5 == arrPerkList.count
            {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
                cell.vwItem.layer.masksToBounds = true
                cell.vwItem.layer.cornerRadius = 1
                cell.vwItem.layer.borderWidth = 1.2
                //cell.vwItem.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 0.8).cgColor
                cell.vwItem.layer.borderColor = UIColor.lightGray.cgColor
                cell.tfItem.delegate = self
                /*
                let title = details.title
                let price = details.price
                let description = details.description
                cell.lblTitle.text = title
                cell.lblPrice.text = String(format: "$%@", price as! CVarArg)
                cell.tvDescription.text = description
                cell.lbldate.text = details.date
                */
                //cell.tfItem.text = ""
                cell.selectionStyle = .none
                return cell
            }
            
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddPerkItemCell") as! AddPerkItemCell
                
                cell.btnAddItem?.addTarget(self, action: #selector(self.AddItem), for: UIControlEvents.touchUpInside)
                cell.btnAddItem.tag = indexPath.row
                cell.selectionStyle = .none
                
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPerkItemCell") as! AddPerkItemCell
            
            cell.btnAddItem?.addTarget(self, action: #selector(self.AddItem), for: UIControlEvents.touchUpInside)
            cell.btnAddItem.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let count = arrItems.count + staticRow
        if indexPath.row > 6 && indexPath.row < count - 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("arrItems.count==",arrItems.count)
            //let count = arrItems.count
            //let indexPath = IndexPath(item: indexPath.row - 7, section: 0)
            //let removedDic: NSDictionary = arrItems[count - 9] as! NSDictionary
            let indexToRemove = indexPath.row - staticRow + 1
            arrItems.removeObject(at: indexToRemove)
            self.tblVwAddPerk.deleteRows(at: [indexPath], with: .automatic)
            self.tblVwAddPerk.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 0
        {
            
        }
        else
        {
        }
        
    }
}

extension AddParkController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //print("TextField did end editing method called")
        if !(textField.text?.isEmpty)! // check textfield contains value or not
        {
            if textField.tag == 1
            {
                perkTitle = textField.text!
            }
            else if textField.tag == 2
            {
                perkPrice = textField.text!
            }
            else if textField.tag == 4
            {
                perkEstimatedDeliveryDate = textField.text!
            }
            else if textField.tag == 5
            {
                perkShippingPrice = textField.text!
            }
            else
            {
                if arrItems.count > 0
                {
                    for index in 0..<arrItems.count+7
                    {
                        if textField.tag == index
                        {
                            perkItem = textField.text!
                            arrItems[index] = perkItem
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}
extension AddParkController: UITextViewDelegate
{
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if !(textView.text?.isEmpty)! // check textView contains value or not
        {
            if textView.tag == 3
            {
                perkDescription = textView.text!
            }
        }
    }
}
