//
//  Location+CoreDataClass.swift
//  UserList
//
//  Created by abra on 5/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Decodable {
    enum LocationKeys: String, CodingKey {
        case city
        case street
        case coordinates
    }
    enum CoordKeys: String, CodingKey {
        case latitude
        case longitude
    }
    enum StreetKeys: String, CodingKey {
        case number
        case name
    }
    required convenience public init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Location", in: context) else { fatalError() }
    
        self.init(entity: entity, insertInto: context)
        do {
            let values = try decoder.container(keyedBy: LocationKeys.self)
            city = try values.decode(String.self, forKey: .city)
            let streetValues = try values.nestedContainer(keyedBy: StreetKeys.self, forKey: .street)
            let number = try streetValues.decode(Int.self, forKey: .number)
            let name = try streetValues.decode(String.self, forKey: .name)
            street = "\(number) \(name)"
            let coordValues = try values.nestedContainer(keyedBy: CoordKeys.self, forKey: .coordinates)
            latitude = Float(try coordValues.decode(String.self, forKey: .latitude))!
            longitude = Float(try coordValues.decode(String.self, forKey: .longitude))!
        } catch let error as NSError {
            print("Location initilization error: \(error)")
        }
    }
    
    func getFullAddress() -> String {
        return "\(street!), \(city!.capitalized)"
    }
}
