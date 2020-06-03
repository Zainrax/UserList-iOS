//
//  Name+CoreDataClass.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Name)
public class Name: NSManagedObject, Decodable {
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    required convenience public init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Name", in: context) else { fatalError() }

    
        self.init(entity: entity, insertInto: nil)
        let values = try decoder.container(keyedBy: NameKeys.self)
        title = try values.decode(String.self, forKey: .title)
        first = try values.decode(String.self, forKey: .first)
        last = try values.decode(String.self, forKey: .last)
    }
}
