//
//  ViewController.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/26/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //connect the stoyboard table view
    @IBOutlet weak var tableView: UITableView!
    
    //Set up a property
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //fillJokeBank()
        grabCollections()
    }
    
    //Sets up the number of rows in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }
    
    //sets up the cells for the table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let collection = self.collections[indexPath.row]
        cell.textLabel!.text = collection.title
        return cell
    }
    //When the cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let collection = self.collections[indexPath.row]
        self.performSegueWithIdentifier("CollectionToJokeSegue", sender: collection)
    }
    //Just before the transition to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let jokesVC = segue.destinationViewController as! JokesViewController
        jokesVC.collection = sender as? Collection
    }
    
    //get the colelctions from core data
    func grabCollections(){
        //getting the context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //doing a fetch request of the collections entity
        let collectionRequest = NSFetchRequest(entityName: "Collection")
        do{
            try self.collections = context.executeFetchRequest(collectionRequest) as! [Collection]
            self.tableView.reloadData()
            
        } catch {
            
        }
        
    }
    
    //Function used to fill in the joke bank and set up core data
    func fillJokeBank(){
        //Addes a context to manage core data
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //Set up the collection and joke entities for core data
        let collectionDescription = NSEntityDescription.entityForName("Collection", inManagedObjectContext: context)
        let jokeDescription = NSEntityDescription.entityForName("Joke", inManagedObjectContext: context)
        //Set up Yo Mamma jokes
        let yoMamma = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        yoMamma.title = "Random Jokes"
        yoMamma.purchased = true
        
        let taxiJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        taxiJoke.title = "Taxi"
        taxiJoke.text = "Yo Mamma so fat that when she wears a yellow dress people chase after her and yell \"TAXI\""
        taxiJoke.collection = yoMamma
        
        let lameJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        lameJoke.title = "Lame"
        lameJoke.text = "This is a lame joke"
        lameJoke.collection = yoMamma

        
        do{
            try context.save()
        } catch {
            
        }
    }



}

