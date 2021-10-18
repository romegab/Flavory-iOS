//
//  Step+CoreDataProperties.swift
//  Flavory
//
//  Created by Ivan Stoilov on 15.10.21.
//
//

import Foundation
import CoreData


extension Step {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Step> {
        return NSFetchRequest<Step>(entityName: "Step")
    }

    @NSManaged public var number: Int
    @NSManaged public var step: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var origin: RecipeModel?

}

extension Step : Identifiable {

}
