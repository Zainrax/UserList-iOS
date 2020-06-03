//
//  UserData+CoreDataClass.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserData)
public class UserData: NSManagedObject, Decodable {
    enum UserKeys: String, CodingKey {
        case gender
        case dob
        case id
        case name
    }

    enum  DobKeys: String, CodingKey {
        case dateOfBirth = "date"
        case age
    }

    enum IdKeys: String, CodingKey {
        case name
        case id
    }
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
            guard let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: UserKeys.self)
        
        gender = try values.decode(String.self, forKey: .gender)
        
        let dobValues = try values.nestedContainer(keyedBy: DobKeys.self, forKey: .dob)
        let dob = try dobValues.decode(String.self, forKey: .dateOfBirth)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-yy'T'HH:mm:ssZ"
        dateOfBirth = dateFormatter.date(from: dob)
        
        name = try values.decode( Name.self, forKey: .name)
    }
}

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}
