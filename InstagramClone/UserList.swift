//
//  UserList.swift
//  InstagramClone
//
//  Created by Maria on 6/13/17.
//  Copyright © 2017 Maria Notohusodo. All rights reserved.
//

import UIKit
import Parse

class UserList: UITableViewController {
    var users = [User]()
    var refresher: UIRefreshControl!
    
    @objc func refresh() {
        let query = PFUser.query()
        query?.findObjectsInBackground(block: { [weak self] (objects, error) in
            if let objects1 = objects {
                self?.users.removeAll(keepingCapacity: true)
                for object in objects1 {
                    if let user = object as? PFUser {
                        if user.objectId != PFUser.current()?.objectId {
                            var currentUserFollowing = User()
                            currentUserFollowing.username = user.username
                            currentUserFollowing.userId = user.objectId
                            
                            let query = PFQuery.init(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.current()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let objects = objects {
                                    if objects.count > 0 {
                                        currentUserFollowing.isFollowing = true
                                    } else {
                                        currentUserFollowing.isFollowing = false
                                    }
                                    self?.users.append(currentUserFollowing)
                                }
                                if self?.users.count == objects1.count-1
                                {
                                    self?.refresher.endRefreshing()
                                    self?.tableView.reloadData()
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl.init()
        refresher.attributedTitle = NSAttributedString.init(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refresher)
        
        refresh()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        if users[indexPath.row].isFollowing == true {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if users[indexPath.row].isFollowing == false {
            print("false selected")
            users[indexPath.row].isFollowing = true
            cell.accessoryType = .checkmark
            let following = PFObject.init(className: "followers")
            following["following"] = users[indexPath.row].userId
            following["follower"] = PFUser.current()?.objectId
            following.saveInBackground()
        } else {
            print("true selected")
            users[indexPath.row].isFollowing = false
            cell.accessoryType = .none
            let query = PFQuery.init(className: "followers")
            query.whereKey("follower", equalTo: PFUser.current()!.objectId!)
            query.whereKey("following", equalTo: users[indexPath.row].userId!)
            query.findObjectsInBackground(block: { (objects, error) in
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
        }
    }
}
