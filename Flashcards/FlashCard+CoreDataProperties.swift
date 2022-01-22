//
//  FlashCard+CoreDataProperties.swift
//  Flashcards
//
//  Created by Omar Diab on 1/9/22.
//
//

import Foundation
import CoreData


extension FlashCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlashCard> {
        return NSFetchRequest<FlashCard>(entityName: "FlashCard")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var subject: String?

}

extension FlashCard : Identifiable {

}
