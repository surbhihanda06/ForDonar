//
//  ChatListController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 11/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ChatListController: UIViewController
{
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var tblVwChatList: UITableView!
    @IBOutlet weak var colVwCampaign: UICollectionView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var arrTopicList = [SubTopicList]()
    var selCatId : Int = 0
    var ref: DatabaseReference!
    var chatArray = [ChatResponse]()
    var selectedTopicID = Int()
    var listArray = [String]()
    var dictionaryChatUser = [String : [ChatResponse]]()
    var messageArray = [ChatResponse]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vwSearch.layer.masksToBounds = true
        vwSearch.layer.cornerRadius = 20
        tblVwChatList.register(UINib(nibName: "ChatListCell", bundle: Bundle.main), forCellReuseIdentifier: "ChatListCell")
        colVwCampaign.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCell")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        lblPageTitle.text = "Chat List".localized
        selectedTopicID = 57518
        getTopicList(topicId: 0)
    }
    
    func getUserData(topicID : Int , campaignID : Int)
    {
        //SVProgressHUD.show()
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
        Database.database().reference().child("message").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]
            {
                let key = snapshot.key
                let temporaryKey = snapshot.key.replacingOccurrences(of: senderID, with: "")
                let temporaryKey1 = temporaryKey.replacingOccurrences(of: "USER", with: "")
                let finalKey = temporaryKey1.replacingOccurrences(of: "_", with: "")
                //                if snapshot.key.contains(senderID) && self.listArray.contains(key.replacingOccurrences(of: senderID, with: ""))
                //                {
                if snapshot.key.contains(senderID) && self.listArray.contains(finalKey)
                {
                    Database.database().reference().child("message").child(snapshot.key).child("chats").observe(.childAdded, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String : AnyObject]
                        {
                            //SVProgressHUD.dismiss()
                            var arr = [ChatResponse]()
                            let message = ChatResponse()
                            message.idReceiver = dictionary["idReceiver"] as? String
                            message.idReceivername = dictionary["idReceivername"] as? String
                            message.idSender = dictionary["idSender"] as? String
                            message.idSendername = dictionary["idSendername"] as? String
                            message.timestamp = dictionary["timestamp"] as? Double
                            message.text = dictionary["text"] as? String
                            message.campaignName = dictionary["campaignName"] as? String
//                            if self.dictionaryChatUser.keys.contains(key.replacingOccurrences(of: senderID, with: ""))
//                            {
//                                arr = self.dictionaryChatUser[key.replacingOccurrences(of: senderID, with: "")]!
//                            }
//                            else
//                            {
//                                arr = [ChatResponse]()
//                            }
//                            arr.append(message)
//                            self.dictionaryChatUser[key.replacingOccurrences(of: senderID, with: "")] = arr
                            if self.dictionaryChatUser.keys.contains(finalKey)
                            {
                                arr = self.dictionaryChatUser[finalKey]!
                            }
                            else
                            {
                                arr = [ChatResponse]()
                            }
                            arr.append(message)
                            self.dictionaryChatUser[finalKey] = arr
                            DispatchQueue.main.async {
                                self.tblVwChatList.reloadData()
                            }
                        }
                    })
                }
            }
        })
    }
    
    func getData(topicID : Int , campaignID : Int)
    {
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
        //SVProgressHUD.show()
        Database.database().reference().child("message").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]
            {
                //SVProgressHUD.dismiss()
                let key : String = snapshot.key
                if key.contains(senderID)
                {
                    print("Success")
                    let temporaryKey = snapshot.key.replacingOccurrences(of: senderID, with: "")
                    let temporaryKey1 = temporaryKey.replacingOccurrences(of: "USER", with: "")
                    let finalKey = temporaryKey1.replacingOccurrences(of: "_", with: "")
                    //let abc : String = key.replacingOccurrences(of: senderID, with: "")
                    let abc : String = finalKey
                    self.listArray.append(abc)
                    self.listArray = Array(Set(self.listArray))
                    DispatchQueue.main.async {
                        self.tblVwChatList.reloadData()
                    }
                }
            }
        })
    }

    // MARK: - Action
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func btnEditPressed(_ sender: Any)
    {
        
    }
    
    func getTopicList(topicId: Int)
    {
        //SVProgressHUD.show()
        let prmList:[String: Any] = [:]
        let apiName = String(format:"/topic/%d",topicId)
        let request = MakeGetRequest.init(parameterList: prmList, APIName: apiName)
        RequestExecutor.executeRequest(request, completion:{ (error: Error?, getMyData: TopicListResponse?) in
            //SVProgressHUD.dismiss()
            if let response = getMyData
            {
                if let dictTopicList = response.topicList, dictTopicList.subTopic.count > 0
                {
                    self.listArray.removeAll()
                    self.dictionaryChatUser.removeAll()
                    self.arrTopicList = dictTopicList.subTopic
                    self.selectedTopicID = self.arrTopicList[0].id
                    self.selectedTopicID = 57518
                    self.getData(topicID: self.selectedTopicID , campaignID: 57518)
                    self.getUserData(topicID: self.selectedTopicID , campaignID: 57518)
                    self.colVwCampaign.reloadData()
                }
            }
            else
            {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    if let vc = UIApplication.topViewController()
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Validation.showTransparentWindow(sender: vc, strMsg: "No Internet Connection!")
                        }
                    }
                }
                else
                {
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

extension ChatListController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
        cell.selectionStyle = .none
        cell.vwUserName.layer.masksToBounds = true
        cell.vwUserName.layer.cornerRadius = cell.vwUserName.frame.size.height / 2
        
        if dictionaryChatUser.keys.contains(listArray[indexPath.row])
        {
            var arr = [ChatResponse]()
            arr = dictionaryChatUser[listArray[indexPath.row]]!
            let sortedArray = arr.sorted(by: { $0.timestamp! > $1.timestamp! })
            dictionaryChatUser[listArray[indexPath.row]]! = sortedArray
            
            let date = Date(timeIntervalSince1970: sortedArray[0].timestamp!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            
            cell.lblTyme.text = dateFormatter.string(from: date)
            cell.messagelabel.text = sortedArray[0].text!
            if sortedArray[sortedArray.count - 1].idSender! != String(describing: UserDefaults.standard.object(forKey: "userId")!)
            {
                cell.lblName.text = sortedArray[sortedArray.count - 1].idSendername
            }
            else
            {
                cell.lblName.text = sortedArray[sortedArray.count - 1].idReceivername
            }
            cell.lblCategoryName.text = sortedArray[sortedArray.count - 1].campaignName
            cell.lblFirstChar.text = (cell.lblName.text?.first?.description)!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let vc = ChatDetailsController()
//        vc.messageArray = dictionaryChatUser[listArray[indexPath.row]]!
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = ChatDetailsuserController()
        var abc = [ChatResponse]()
        abc = dictionaryChatUser[listArray[indexPath.row]]!
        vc.campaignPosterId = Int(abc[abc.count - 1].idSender!)
        vc.campaignId = 58015
        vc.selectedTopicID = 53636
        vc.receiverName = abc[abc.count - 1].idSendername
        vc.campaignName = abc[abc.count - 1].campaignName
        if abc[abc.count - 1].idSender! == String(describing: UserDefaults.standard.object(forKey: "userId")!)
        {
            vc.campaignPosterId = Int(abc[abc.count - 1].idReceiver!)
            vc.receiverName = abc[abc.count - 1].idReceivername
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChatListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrTopicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let topicDetails = arrTopicList[indexPath.row]
        let catName = topicDetails.name
        let catId = topicDetails.id
        cell.lblCategoryName.text = catName.uppercased()
        if selCatId == catId
        {
            cell.lblSelected.isHidden = false
            cell.lblCategoryName.textColor = UIColor.white
        }
        else
        {
            cell.lblSelected.isHidden = true
            cell.lblCategoryName.textColor = UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let selCategory = arrTopicList[indexPath.row]
        selCatId = selCategory.id
        selectedTopicID = arrTopicList[indexPath.row].id
        self.colVwCampaign.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let topicDetails = arrTopicList[indexPath.row]
        let text = topicDetails.name
        let width = text.width(withConstrainedHeight: 47, font: CategoryCell.locationNameFont)
        return CGSize(width: width + 10, height: 47)
    }
}
