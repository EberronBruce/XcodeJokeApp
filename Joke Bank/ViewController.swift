//
//  ViewController.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/26/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate,  UITableViewDataSource, UITableViewDelegate, SKPaymentTransactionObserver {
    
    
    //connect the stoyboard table view
    @IBOutlet weak var tableView: UITableView!
    
    //Set up a property
    var collections = [Collection]()
    
    //Setting up an empty array of products
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //getting the context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //doing a fetch request of the collections entity
        let collectionRequest = NSFetchRequest(entityName: "Collection")
        do{
            try self.collections = context.executeFetchRequest(collectionRequest) as! [Collection]
            self.tableView.reloadData()
            
            if self.collections.count <= 0 {
                fillJokeBank()
            }
            
        } catch {
            
        }

        
        
        
        grabCollections()
        prepareForPurchase()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }
    
    //Checking itunes connect for the in app purchases
    func prepareForPurchase(){
        let productSet : Set<String> = ["com.redravencomputing.jokes.science", "com.redravencomputing.jokes.sports"]
        let request = SKProductsRequest(productIdentifiers: productSet)
        request.delegate = self
        request.start()
    }
    //Response for the SKProductRequest Delegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("products: \(response.products.count)")
        print("invalid: \(response.invalidProductIdentifiers.count)")
        self.products = response.products
        self.tableView.reloadData()
    }
    
    //To see if payment went through
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                print("Purchased")
                giveRewardForProduct(transaction.payment.productIdentifier)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Failed:
                print("Failed")
                break
            case .Restored:
                print("Restored")
                break
            case .Purchasing:
                print("Purchasing")
                break
            case .Deferred:
                print("Deferred")
                break
            }
        }
    }
    
    //Give the reward for the purchase
    func giveRewardForProduct(productID: String){
        for collection in self.collections {
            if productID == collection.inAppPurchaseID {
                collection.purchased = true
                self.tableView.reloadData()
            }
        }
    }
    
    
    //Sets up the number of rows in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }
    
    //sets up the cells for the table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let collection = self.collections[indexPath.row]
        
        if (collection.inAppPurchaseID?.isEmpty == nil){
            cell.textLabel!.text = collection.title
        } else {
            if collection.purchased!.boolValue {
                cell.textLabel!.text = collection.title
            } else {
                var currentProduct : SKProduct?
                for product in self.products {
                    if product.productIdentifier == collection.inAppPurchaseID {
                        currentProduct = product
                    }
                }
                if currentProduct != nil {
                    let formatter = NSNumberFormatter()
                    formatter.numberStyle = .CurrencyStyle
                    formatter.locale = currentProduct?.priceLocale
                    let priceString = formatter.stringFromNumber((currentProduct?.price)!)
                    cell.textLabel!.text = "LOCKED * \(collection.title!) * \(priceString!)"
                } else {
                    cell.textLabel!.text = "LOCKED * \(collection.title!)"
                }
            }
        }
        
        return cell
    }
    //When the cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let collection = self.collections[indexPath.row]
        if collection.purchased!.boolValue {
            self.performSegueWithIdentifier("CollectionToJokeSegue", sender: collection)
        } else {
            var currentProduct : SKProduct?
            for product in self.products {
                if product.productIdentifier == collection.inAppPurchaseID {
                    currentProduct = product
                }
            }
            let payment = SKPayment(product: currentProduct!)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
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
        
        //Collections
        let yoMamma = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        yoMamma.title = "Yo Mamma Jokes"
        yoMamma.purchased = true
        
        let animal = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        animal.title = "Animal Jokes"
        animal.purchased = true
        
        let sports = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        sports.title = "Sports Jokes"
        sports.inAppPurchaseID = "com.redravencomputing.jokes.sports"
        sports.purchased = false
        
        let science = Collection(entity: collectionDescription!, insertIntoManagedObjectContext: context)
        science.title = "Science Jokes"
        science.inAppPurchaseID = "com.redravencomputing.jokes.science"
        science.purchased = false
        
        
        //Jokes
        let taxiJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        taxiJoke.title = "Taxi"
        taxiJoke.text = "Yo Mamma so fat that when she wears a yellow dress people chase after her and yell \"TAXI\""
        taxiJoke.collection = yoMamma
        
        let lameJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        lameJoke.title = "Lame"
        lameJoke.text = "This is a lame joke"
        lameJoke.collection = animal
        
        let sportsJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        sportsJoke.title = "Sports Lame"
        sportsJoke.text = "This is a lame sports joke"
        sportsJoke.collection = sports
        
        let scienceJoke = Joke(entity: jokeDescription!, insertIntoManagedObjectContext: context)
        scienceJoke.title = "Science Lame"
        scienceJoke.text = "This is a lame science joke"
        scienceJoke.collection = science
        
        
        do{
            try context.save()
        } catch {
            
        }
    }
    
    
    
}

