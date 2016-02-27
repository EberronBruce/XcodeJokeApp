//
//  JokesViewController.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/26/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit

class JokesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Property to keep the collection 
    var collection : Collection?
    
    var jokes = [Joke]()

    //Connection of the table view from the storyboard
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //store the jokes int an arrow
        self.jokes = self.collection?.jokes?.allObjects as! [Joke]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    //return the account of jokes to make table rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokes.count
    }
    //populated that table with the jokes
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let joke = self.jokes[indexPath.row]
        cell.textLabel?.text = joke.title
        return cell
    }
    //Take selected joke and pass it
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let joke = self.jokes[indexPath.row]
        self.performSegueWithIdentifier("JokeToTextSegue", sender: joke)
    }
    //take the joke and pass it to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let jokeTextVC = segue.destinationViewController  as! JokeTextViewController
        jokeTextVC.joke = sender as? Joke
    }



}
