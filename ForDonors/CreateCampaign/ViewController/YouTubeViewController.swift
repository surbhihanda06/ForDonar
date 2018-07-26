//
//  YouTubeViewController.swift
//  ForDonors
//
//  Created by NITS_Mac3 on 30/03/18.
//  Copyright © 2018 NATIT. All rights reserved.
//

import UIKit
//import YouTubePlayer
import youtube_ios_player_helper
class YouTubeViewController: UIViewController {

    @IBOutlet var videoPlayer: YTPlayerView!
    @IBOutlet weak var btnClose: UIButton!
    var youtubeID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //videoPlayer.loadVideoID(youtubeID)
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: youtubeID)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnCloseTapped(_ sender: Any)
    {
        videoPlayer.stopVideo()
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

extension YouTubeViewController: YTPlayerViewDelegate
{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView!) {
        playerView.playVideo()
    }
}
//extension YouTubeViewController: YouTubePlayerDelegate
//{
//    func playerReady(_ videoPlayer: YouTubePlayerView)
//    {
//        videoPlayer.play()
//    }
//}

