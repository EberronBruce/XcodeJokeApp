//
//  JokeTextViewController.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/27/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit

class JokeTextViewController: UIViewController {
    
    //Connect the textView from the storyboard
    @IBOutlet weak var textView: UITextView!
    
    //A property to hold the joke
    var joke : Joke?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textView.text = self.joke?.text
    }

}
