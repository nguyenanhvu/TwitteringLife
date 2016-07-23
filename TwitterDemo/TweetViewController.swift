//
//  TweetViewController.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
class TweetViewController: UIViewController {
    
    @IBOutlet weak var tweetNavigationBar: UINavigationItem!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var user: User?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TwitterClient.getSession.currentAccount({ (user: User) in
            self.user = user
            
            self.userName.text = user.name
            self.userScreenName.text = user.screenName
            self.userImage.setImageWithURL(user.profileImageUrl!)
            
        }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
        }
        

        }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetUpdate(sender: UIBarButtonItem) {
        let statusString = tweetText.text
        
        TwitterClient.getSession.postTweet(statusString, success: { (newTweetDic: NSDictionary) in
            print(newTweetDic)
        }) { (error: NSError) in
                print("Return error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onTweetCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

   
}

