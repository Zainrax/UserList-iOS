//
//  Location+CoreDataProperties.swift
//  UserList
//
//  Created by abra on 5/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var user: UserData?

}
