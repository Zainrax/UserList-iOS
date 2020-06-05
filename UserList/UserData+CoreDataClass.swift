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
import UIKit

@objc(UserData)
public class UserData: NSManagedObject, Decodable {
    let df = DateFormatter()
    enum UserKeys: String, CodingKey {
        case gender
        case dob
        case id
        case name
        case picture
        case location
    }

    enum  DobKeys: String, CodingKey {
        case dateOfBirth = "date"
        case age
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
            guard let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        // Read https://randomuser.me/documentation for json struct.
        do {
            let values = try decoder.container(keyedBy: UserKeys.self)
            let dobValues = try values.nestedContainer(keyedBy: DobKeys.self, forKey: .dob)
            
            gender = try values.decode(String.self, forKey: .gender)
            let dob = try dobValues.decode(String.self, forKey: .dateOfBirth)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: dob)!
            dateOfBirth = date
            name = try values.decode( Name.self, forKey: .name)
            picture = try values.decode(Picture.self, forKey: .picture)
            location = try values.decode(Location.self, forKey: .location)
            
        } catch let error as NSError {
            print("UserData initilazation error: \(error)")
        }
    }
    
    func getDateString() -> String {
        df.dateFormat = "dd-MM-yyyy"
        return df.string(from: self.dateOfBirth!)
    }
    
    func getAge() -> Int {
        let calender = Calendar.current
        let components = calender.dateComponents([.day,.month,.year], from: self.dateOfBirth!, to: Date())
        return components.year ?? 0
    }
}

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}
