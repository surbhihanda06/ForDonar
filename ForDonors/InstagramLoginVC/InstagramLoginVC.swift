//
//  InstagramLoginVC.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 05/04/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
import SwiftInstagram
struct INSTAGRAM_IDS {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "7c7259f9a16542d0891cb29bda8f1dae"
    
    static let INSTAGRAM_CLIENTSERCRET = "91ddc549240843d1a01ba7e5fe59a6db"
    
    static let INSTAGRAM_REDIRECT_URI = "http://www.google.com"
    
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "basic"//"likes+comments+relationships"
    
}


protocol InstagramLoginVCDelegate: class {
    func instagramUser(instagramUser: [String:Any])
}
class InstagramLoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    var delegate: InstagramLoginVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginWebView.delegate = self
        unSignedRequest()
    }
    @IBAction func back(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        print(requestURLString)
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
        
        if authToken.count > 0
        {
            let urlString = String(format:"https://api.instagram.com/v1/users/self/?access_token=%@",authToken)
            let url = NSURL(string: urlString)!
            
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            if let dictUser = jsonDataDict["data"] as? [String: AnyObject]
                            {
                                let dictToSend = [
                                    "id": String(format:"%d",dictUser["id"] as! CVarArg),
                                    "username": dictUser["username"] ?? "",
                                    "fullName": dictUser["full_name"] ?? "",
                                    "bio": dictUser["bio"] ?? "",
                                    "profilePicture": dictUser["profile_picture"] ?? "",
                                    "website": dictUser["website"] ?? ""
                                    ] as [String : Any]
                                
                                self.delegate.instagramUser(instagramUser: dictToSend)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                    
                    self.dismiss(animated: true, completion: nil)
                    Alert.disPlayAlertMessage(titleMessage: "Sorry", alertMsg: err.debugDescription)
                    
                }
            }
            
            task.resume()
        }
        
        
        
        

        /*let urlString = "https://api.instagram.com/oauth/access_token"
        let url = NSURL(string: urlString)!
        //let paramString  = "client_id=\(INSTAGRAM_CLIENT_ID)&client_secret=\(INSTAGRAM_CLIENTSERCRET)&grant_type=authorization_code&redirect_uri=\(INSTAGRAM_REDIRECT_URI)&code=\(authToken)&scope=basic+public_content"
        
        let paramString = String(format:"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@&scope=basic+public_content",INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_CLIENTSERCRET,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI,authToken)
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = paramString.data(using: String.Encoding.utf8)!
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        
        task.resume()*/
        
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
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
