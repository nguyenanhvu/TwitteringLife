//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        TwitterClient.getSession.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
                print("\(error.localizedDescription)")
        }
    }
    @IBAction func onLogOutButton(sender: UIBarButtonItem) {
        TwitterClient.getSession.logout()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count}
        else {
            return 0 }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweetLabel.text = tweets[indexPath.row].text
        
            
//        if let media = tweets[indexPath.row].entities!["media"] as? NSDictionary{
//            print("\(media)")
//            print(media["media_url_https"] as? String)
//        }
//        else {
//            print("no media")
//        }
        if let user = tweets[indexPath.row].user {
            cell.idLabel.text = "@" + user.screenName!
            cell.nameLabel.text =  user.name
            cell.avatarImage.setImageWithURL(user.profileImageUrl!)
        }
        else
        {
            cell.idLabel.text = "no name"
            cell.nameLabel.text =  "no name"
        }
        cell.timestampLabel.text = tweets[indexPath.row].timeSinceCreated
        
        
        
        return cell
    }
    
}
