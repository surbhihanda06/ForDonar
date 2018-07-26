//
//  ChatDetailsuserController.swift
//  ForDonors
//
//  Created by NITS_Mac5 on 29/06/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ChatDetailsuserController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var tableViewChatList: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var chatTextview: UITextView!
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var messageArray = [ChatResponse]()
    var selectedTopicID : Int?
    var campaignId: Int = 0
    var campaignPosterId: Int?
    var listArray = [String]()
    var dictionaryChatUser = [String : [ChatResponse]]()
    var ref: DatabaseReference!
    var receiverName : String?
    var topicID : Int?
    var campaignName : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewChatList.register(UINib(nibName: "SenderCell", bundle: Bundle.main), forCellReuseIdentifier: "SenderCell")
        tableViewChatList.register(UINib(nibName: "ReceiverCell", bundle: Bundle.main), forCellReuseIdentifier: "ReceiverCell")
        
        chatTextview.layer.borderColor = UIColor.darkGray.cgColor
        chatTextview.layer.borderWidth = 1.0
        sendButton.layer.borderColor = UIColor.darkGray.cgColor
        sendButton.layer.borderWidth = 1.0
        attachmentButton.layer.borderColor = UIColor.darkGray.cgColor
        attachmentButton.layer.borderWidth = 1.0
        
        headerLabel.text = self.receiverName
        listArray.append(String(format: "%d", campaignPosterId!))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.messageArray.removeAll()
        self.dictionaryChatUser.removeAll()
        self.getUserData(topicID: self.selectedTopicID! , campaignID: campaignId)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData(topicID : Int , campaignID : Int)
    {
        chatTextview.text = ""
        //SVProgressHUD.show()
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
       
        self.messageArray.removeAll()
        self.dictionaryChatUser.removeAll()
        Database.database().reference().child("message").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]
            {
                let key = snapshot.key
                let temporaryKey = snapshot.key.replacingOccurrences(of: senderID, with: "")
                let temporaryKey1 = temporaryKey.replacingOccurrences(of: "USER-", with: "")
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
                            print(message.text!)
//                            if self.dictionaryChatUser.keys.contains(key.replacingOccurrences(of: senderID, with: ""))
//                            {
//                                arr = self.dictionaryChatUser[key.replacingOccurrences(of: senderID, with: "")]!
//                            }
//                            else
//                            {
//                                arr = [ChatResponse]()
//                            }
                            if self.dictionaryChatUser.keys.contains(finalKey)
                            {
                                arr = self.dictionaryChatUser[finalKey]!
                            }
                            else
                            {
                                arr = [ChatResponse]()
                            }
                            arr.append(message)
                            //self.dictionaryChatUser[key.replacingOccurrences(of: senderID, with: "")] = arr
                            self.dictionaryChatUser[finalKey] = arr
                            let sortedArray = arr.sorted(by: { $0.timestamp! < $1.timestamp! })
                            self.dictionaryChatUser[self.listArray[0]]! = sortedArray
                            self.messageArray = self.dictionaryChatUser[self.listArray[0]]!
                            DispatchQueue.main.async
                                {
                                self.tableViewChatList.reloadData()
                            }
                        }
                    })
                }
            }
        })
    }
    
    func appendData(topicID : Int , campaignID : Int)
    {
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
        let receiverID : String = String(describing: campaignPosterId)
        
        Database.database().reference().child("message").child("USER-" + senderID + "_" + receiverID).observe(.childChanged, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]
            {
                let message = ChatResponse()
                message.idReceiver = dictionary["idReceiver"] as? String
                message.idReceivername = dictionary["idReceivername"] as? String
                message.idSender = dictionary["idSender"] as? String
                message.idSendername = dictionary["idSendername"] as? String
                message.timestamp = dictionary["timestamp"] as? Double
                message.text = dictionary["text"] as? String
                self.messageArray.append(message)
                DispatchQueue.main.async
                    {
                        self.tableViewChatList.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func enterData(topicID : Int , campaignID : Int)
    {
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
        let fname: String = UserDefaults.standard.string(forKey: "FName") ?? ""
        let lname: String = UserDefaults.standard.string(forKey: "LName") ?? ""
        let userName : String = fname + " " + lname
        let concatID = "USER-" + senderID + "_" + String(format: "%d", self.campaignPosterId!)
        let receiverID = String(format: "%d", self.campaignPosterId!)
        //let ref = Database.database().reference().child("message").child(String(topicID)).child(String(campaignID)).child(concatID).child("chats")
        let ref = Database.database().reference().child("message").child(concatID).child("chats")
        let childRef = ref.childByAutoId()
        let dict = ["idReceiver" : receiverID , "idReceivername" : receiverName! , "idSender" :  senderID , "idSendername" : userName , "text" : chatTextview.text! , "timestamp" : Int((NSDate().timeIntervalSince1970) * 1000) , "campaignName" : campaignName! , "campaignId" : campaignId] as [String : Any]
        chatTextview.text = ""
        childRef.updateChildValues(dict)
    }
    
    //TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let senderID : String = String(describing: UserDefaults.standard.object(forKey: "userId")!)
        if messageArray[indexPath.row].idSender == senderID
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell
            cell?.lblSendingMessage.text = messageArray[indexPath.row].text
            let date = Date(timeIntervalSince1970: messageArray[indexPath.row].timestamp!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            cell?.lblMsgSendTime.text = dateFormatter.string(from: date)
            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell
            cell?.lblMessage.text = messageArray[indexPath.row].text
            let date = Date(timeIntervalSince1970: messageArray[indexPath.row].timestamp!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            cell?.lblMsgRcvTime.text = dateFormatter.string(from: date)
            return cell!
        }
    }
    
    @IBAction func attachmentButtonAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton)
    {
        if chatTextview.text != ""
        {
            enterData(topicID: 57518, campaignID: campaignId)
            appendData(topicID: 57518, campaignID: campaignId)
        }
        else
        {
            Alert.disPlayAlertMessage(titleMessage: "Sorry.", alertMsg: "Please enter some text")
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
