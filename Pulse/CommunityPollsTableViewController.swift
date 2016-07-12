//
//  CommunityPollsTableViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/10/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit
import Firebase

class CommunityPollsTableViewController: UITableViewController {
    
    var polls: [Poll] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the polls data
        DataService.dataService.USER_REF.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var tempItems = [Poll]()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        if key != (NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String) {
                            for pollElement in postDict["polls"] as! NSDictionary{
                                let poll = pollElement.value
                                let tempPoll = Poll(question: poll["question"] as! String, textOptions: poll["options"] as! [String], votes: poll["votes"] as! Int, userName: postDict["username"] as! String)
                                tempItems.append(tempPoll!)
                            }
                        }
                    }
                }
            }
            self.polls = tempItems
            //print(self.polls)
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CommunityPollCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CommunityPollTableViewCell
        
        let poll = polls[indexPath.row]
        cell.questionLabel.text = poll.question
        cell.userLabel.text = "By \(poll.userName)"
        cell.votesLabel.text = "\(poll.votes)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPoll = polls[indexPath.row]
        
        let destinationViewController = PollDetailViewController()
        destinationViewController.poll = selectedPoll
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("openCommunityDetailViewController", sender: indexPath)
        // destinationViewController.performSegueWithIdentifier("openDetailViewController", sender: self)
        //navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = nil
        if segue.identifier == "openCommunityDetailViewController" {
            let controller = segue.destinationViewController as! CommunityPollDetailViewController
            let row = (sender as! NSIndexPath).row
            controller.poll = polls[row]
        }
    }
    
    @IBAction func unWindToVote(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? CommunityPollDetailViewController, updatedUser = sourceViewController.updatedUser, updatedPoll = sourceViewController.updatedPoll {
            DataService.dataService.USER_REF.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    for snap in snapshots {
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            if postDict["username"] as! String == updatedUser{
                                for pollElement in postDict["polls"] as! NSDictionary{
                                    if pollElement.key as! String == updatedPoll.question{
                                        let pollKey = pollElement.key
                                        let poll = pollElement.value
                                        var votes = poll["votes"] as! Int
                                        votes += 1
                                        DataService.dataService.USER_REF.childByAppendingPath("\(key)").childByAppendingPath("polls").childByAppendingPath("\(pollKey)").childByAppendingPath("votes").setValue(votes)
                                        
                                        self.tableView.reloadData()
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
}