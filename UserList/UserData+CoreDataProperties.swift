//
//  UserData+CoreDataProperties.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var picture: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: Name?

}
