//
//  Collection+CoreDataProperties.swift
//  Joke Bank
//
//  Created by Bruce Burgess on 2/26/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collection {

    @NSManaged var title: String?
    @NSManaged var purchased: NSNumber?
    @NSManaged var jokes: NSSet?

}
