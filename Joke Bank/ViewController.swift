//
//  ViewController.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/26/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fillJokeBank()
    }
    
    //Function used to fill in the joke bank and set up core data
    func fillJokeBank(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let collectionDescription = NSEntityDescription.entityForName("Collection", inManagedObjectContext: context)
        let jokeDescription = NSEntityDescription.entityForName("Joke", inManagedObjectContext: context)
        let yoMamma = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        yoMamma.title = "Yo Mamma"
        yoMamma.purchased = true
        
        let taxiJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        taxiJoke.title = "Taxi"
        taxiJoke.text = "Yo Mamma so fat that when she wears a yellow dress people chase after her and yell \"TAXI\""
        taxiJoke.collection = yoMamma
        
        do{
            try context.save()
        } catch {
            
        }
    }
    



}

