//
//  FeedTableViewController.swift
//  InstagramClone
//
//  Created by Maria on 6/16/17.
//  Copyright © 2017 Maria Notohusodo. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) -> Void in
            
            if let users = objects {
                
                self.messages.removeAll(keepingCapacity: true)
                self.users.removeAll(keepingCapacity: true)
                self.imageFiles.removeAll(keepingCapacity: true)
                self.usernames.removeAll(keepingCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
            }
            
            
            let getFollowedUsersQuery = PFQuery(className: "followers")
            
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()!.objectId!)
            
            getFollowedUsersQuery.findObjectsInBackground { (objects, error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        let followedUser = object["following"] as! String
                        
                        let query = PFQuery(className: "Post")
                        
                        query.whereKey("userId", equalTo: followedUser)
                        
                        query.findObjectsInBackground(block: { (objects, error) -> Void in
                            
                            if let objects = objects {
                                
                                for object in objects {
                                    
                                    self.messages.append(object["message"] as! String)
                                    
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    self.usernames.append(self.users[object["userId"] as! String]!)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) -> Void in
            if let downloadedImage = UIImage(data: data!) {
                myCell.postedImage.image = downloadedImage
            }
        }
        myCell.username.text = usernames[indexPath.row]
        myCell.message.text = messages[indexPath.row]
        return myCell
    }
}
