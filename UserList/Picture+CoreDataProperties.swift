//
//  Picture+CoreDataProperties.swift
//  UserList
//
//  Created by abra on 4/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var thumbnailURL: String?
    @NSManaged public var mediumURL: String?
    @NSManaged public var largeURL: String?
    @NSManaged public var user: UserData?

}
