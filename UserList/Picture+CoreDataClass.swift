//
//  Picture+CoreDataClass.swift
//  UserList
//
//  Created by abra on 4/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Picture)
public class Picture: NSManagedObject, Decodable {
    enum PictureKeys: String, CodingKey {
        case thumbnail
        case medium
        case large
    }
    required convenience public init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Picture", in: context) else { fatalError() }
    
        self.init(entity: entity, insertInto: context)
        do {
            let values = try decoder.container(keyedBy: PictureKeys.self)
            thumbnailURL = try values.decode(String.self, forKey: .thumbnail)
            mediumURL = try values.decode(String.self, forKey: .medium)
            largeURL = try values.decode(String.self, forKey: .large)
        } catch let error as NSError {
            print("Picture initilization error: \(error)")
        }
    }
}
