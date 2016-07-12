//
//  PollsTableViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/6/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit
import Firebase

class PollsTableViewController: UITableViewController {
    
    var polls: [Poll] = []
    var currentUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //edit button provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //set the current user name
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            self.currentUsername = currentUser
            
            // load the polls data
            let userPath = DataService.dataService.CURRENT_USER_REF
            let userPollsPath = userPath.childByAppendingPath("polls")
            userPollsPath.observeSingleEventOfType(.Value, withBlock: { snapshot in
                var tempItems = [Poll]()
                for poll in snapshot.children{
                    let child = poll as! FDataSnapshot
                    let dict = child.value as! NSDictionary
                    let tempPoll = Poll(question: dict["question"] as! String, textOptions: dict["options"] as! [String], votes: dict["votes"] as! Int, userName: self.currentUsername)
                    tempItems.append(tempPoll!)
                }
                
                self.polls = tempItems
                self.tableView.reloadData()
            })
            }, withCancelBlock: { error in
                print(error.description)
        })
        
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
        let cellIdentifier = "PollCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PollTableViewCell
        
        let poll = polls[indexPath.row]
        cell.questionLabel.text = poll.question
        cell.userLabel.text = "By \(poll.userName)"
        cell.votesLabel.text = "\(poll.votes)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let question = polls[indexPath.row].question
            
            polls.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.tableView.reloadData()
            
            //Remove from firebase database
            DataService.dataService.CURRENT_USER_REF.childByAppendingPath("polls/\(question)").removeValueWithCompletionBlock({(error: NSError?, ref: Firebase!) in
                if error != nil {
                    let alert = UIAlertController(title: "Add poll", message: "Poll deletion failed. Please try again", preferredStyle: .Alert)
                    let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(actionOK)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Add poll", message: "Poll deleted successfully", preferredStyle: .Alert)
                    let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(actionOK)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        else if  editingStyle == .Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedPoll = polls[indexPath.row]
//        
//        let destinationViewController = PollDetailViewController()
//        destinationViewController.poll = selectedPoll
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("openDetailViewController", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = nil
        if segue.identifier == "openDetailViewController" {
            let controller = segue.destinationViewController as! PollDetailViewController
            let row = (sender as! NSIndexPath).row
            controller.poll = polls[row]
        }
    }
    
    @IBAction func unwindToPollList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddPollViewController, poll = sourceViewController.poll {
            // Add a new poll
            let newIndexPath = NSIndexPath(forRow: polls.count, inSection: 0)
            polls.append(poll)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
            //Add to firebase database
            let userPath = DataService.dataService.CURRENT_USER_REF
            let userPollsPath = userPath.childByAppendingPath("polls")
            let pollData = ["question": poll.question, "options": poll.textOptions, "votes": poll.votes]
            
            userPollsPath.childByAppendingPath("\(poll.question)").setValue(pollData, withCompletionBlock: {
                (error: NSError?, ref: Firebase!) in
                if error != nil {
                    let alert = UIAlertController(title: "Create poll", message: "Poll creation failed. Please try again", preferredStyle: .Alert)
                    let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(actionOK)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Create poll", message: "Poll created successfully", preferredStyle: .Alert)
                    let actionOK = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(actionOK)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
}