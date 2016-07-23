//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/21/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let getSession = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "oOWhmGev3elTBmVeBqDkrflFh", consumerSecret: "qKMBEWaxYNnmp2hRYrEA8nctGGASbe4lvhTUxTPUFdYN73UKPU")
    var loginSuccess: (()->())?     //indicate login success, set in
    var loginFailure: (NSError -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        self.loginSuccess = success
        self.loginFailure = failure
            deauthorize()
            fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "TwitteringLife://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
          
            // TODO: redirect to authrization url
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) in
            
           self.loginFailure?(error)
        }
        
    }
    func logout(){
        deauthorize()
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName("TweetUserDidLogOut", object: nil)
    }
    func handleUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.getSession.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.loginSuccess?()
            self.currentAccount({ (user: User) in
                User.currentUser = user
                }, failure: { (error: NSError) in
                    print("cannot save current user")
            })
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    
    func currentAccount(success: (User)-> (), failure: (NSError)->()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
                failure(error)
        })

    }
    func homeTimeline(success: ([Tweet]) -> (),failure: (NSError) -> () ) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            print("\(dictionaries)")
            let tweets =  Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    func postTweet(statusString: String, success: (NSDictionary)->(), faiture:(NSError)->()){
        

        var params = [String : AnyObject]()
        params["status"] = statusString
        
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask?, response: AnyObject?) -> Void in
            
            
            print("aa")
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError?) -> Void in
                print("error updating new tweet")
                
        })
        
//        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask?, response: AnyObject?) in
//            print("aa")
//        }) { (task: NSURLSessionDataTask?, error: NSError) in
//                print("error here")
//        }

        
//        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//            let data = response as! NSDictionary
//            print(data)
//            success(data)
//        }) { (task: NSURLSessionDataTask?, error: NSError) in
//        faiture(error)
//        }
    }
    
}
