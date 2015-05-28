//
//  MemeTableViewController.swift
//  MemeMeApp
//
//  Created by Shirley Hang on 5/17/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the next meme add button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "+",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "sendMoreMemes")
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    
        //check if there are sent memes, if not send an alert view 
        if self.memes.count == 0
        {
            let alertController = UIAlertController()
            alertController.title = "No sent Memes"
            alertController.message = "Please create memes by clicking the '+' button"
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                {action  in self.dismissViewControllerAnimated(true, completion: nil)}
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.memes!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        
        let meme = self.memes[indexPath.row]
        
        // Set the text and image
        
        cell.textLabel?.text = meme.memeTopText
        
        cell.imageView?.image = meme.memedImage
        // If the cell has a detail label, we will put the bottom tex in.
        if let detailTextLabel = cell.detailTextLabel
        {
            detailTextLabel.text = meme.memeBottomText
        }

        return cell
    }
    //go back to the meme editor screen
    func sendMoreMemes()
    {
        var memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        //let navController = UINavigationController(rootViewController: memeEditor)
        self.presentViewController(memeEditor, animated: true, completion: nil)
    }
    //select a row to go to the meme detail view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController")!
        
        let detailViewController = object as! memeDetailViewController
        //populate view controller with data from the selected item
        
        detailViewController.memeDetail = self.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailViewController, animated: true)
        
    }
}
