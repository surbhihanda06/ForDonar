//
//  ChatDetailsController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 16/05/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatDetailsController: JSQMessagesViewController
{
    private let imageURLNotSetKey = "NOTSET"
    var userId = ""
    var grpNmId: String = ""
    var messageRef: DatabaseReference!
    var receiverId: String!
    //var campaignId = ""
    var messageArray = [ChatResponse]()
    var campaignId: Int = 0
    var campaignPosterId: Int?
    var receiverName : String?
    var campaignName : String?
    
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "https://fordonor-196411.firebaseio.com/")
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    
    var arrMessages = [[String: String]]()
    
    var messages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var campId = ""
    
    var channelRef: DatabaseReference?
    
    lazy var outgoingBubble: JSQMessagesBubbleImage =
        {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage =
        {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //messageRef = Database.database().reference()
        
        let user_Id = UserDefaults.standard.object(forKey: "userId") as? Int ?? 0
        userId = String(format:"%d",user_Id)
        campId = "camp" + userId
        let fname: String = UserDefaults.standard.string(forKey: "FName") ?? ""
        let lname: String = UserDefaults.standard.string(forKey: "LName") ?? ""
        self.senderDisplayName = fname + " " + lname
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.senderId = (String(format:"%d",user_Id))
//        tableViewChatList.register(UINib(nibName: "SenderCell", bundle: Bundle.main), forCellReuseIdentifier: "SenderCell")
//        tableViewChatList.register(UINib(nibName: "ReceiverCell", bundle: Bundle.main), forCellReuseIdentifier: "ReceiverCell")
        messageRef = Database.database().reference().child("message")
        let query = messageRef?.queryLimited(toLast: 100)
        _ = query?.observe(.childAdded, with: { [weak self] snapshot in
            
            if self?.campId == snapshot.key
            {
                let data1: NSMutableDictionary = (snapshot.value as? NSMutableDictionary)!
                let allKeys = data1.allKeys
                for strMyId in allKeys
                {
                    if let strId = strMyId as? String
                    {
                        if strId == self?.userId
                        {
                            let data = data1[strId]
                            print(data)
                            //let getdata: NSMutableDictionary = data.childByAutoId() as! NSMutableDictionary
                            //messageRef.child(campId).child(userId).childByAutoId().setValue(messageItem)
                            
                            if let data3 = data as? NSMutableDictionary
                            {
                                print(data3)
                                
                                let allKeysIner = data3.allKeys
                                for key1 in allKeysIner
                                {
                                    if let object = data3[key1] as? [String:Any]
                                    {
                                        let senderId: String = object["idSender"] as! String
                                        let text: String = object["text"] as! String
                                        let rcvrId: String = object["idReceiver"] as! String
                                        let timestamp = object["timestamp"]
                                        
                                        //let senderId = String(format: "%d",sid)
                                        //let rcvrId = String(format: "%d",idReceiver)
                                        //MARK: One to One chat quary
                                        if self?.userId == senderId && self?.receiverId == rcvrId
                                        {
                                            if let message = JSQMessage(senderId: senderId, displayName: "", text: text)
                                            {
                                                self?.messages.append(message)
                                                
                                                self?.finishReceivingMessage()
                                            }
                                        }
                                        else if self?.receiverId == senderId && self?.userId == rcvrId
                                        {
                                            if let message = JSQMessage(senderId: senderId, displayName: "", text: text)
                                            {
                                                self?.messages.append(message)
                                                
                                                self?.finishReceivingMessage()
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                let id = allKeys[0]
                print("allKeys",allKeys)
                
            }
        })
    }
    
    private func addMessage(withId id: String, name: String, text: String)
    {
        if let message = JSQMessage(senderId: id, displayName: name, text: text)
        {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId
        {
            cell.textView?.textColor = UIColor.white
        }
        else
        {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        //let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "idSender": senderId!,
            "timestamp": senderDisplayName!,
            "text": text!,
            "idReceiver":receiverId
        ]
        messageRef.child(campId).child(userId).childByAutoId().setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        //messageRef?.setValue(messageItem)
        finishSendingMessage() // 5
        //isTyping = false
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(textView.text != "")
        //isTyping = textView.text != ""
    }
    
    /*
     private lazy var userIsTypingRef: DatabaseReference =
     self.channelRef!.child("typingIndicator").child(self.senderId) // 1
     private var localTyping = false // 2
     var isTyping: Bool {
     get {
     return localTyping
     }
     set {
     // 3
     localTyping = newValue
     userIsTypingRef.setValue(newValue)
     }
     }
     
     private func observeTyping() {
     let typingIndicatorRef = channelRef!.child("typingIndicator")
     userIsTypingRef = typingIndicatorRef.child(senderId)
     userIsTypingRef.onDisconnectRemoveValue()
     }
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //observeTyping()
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
    
}
