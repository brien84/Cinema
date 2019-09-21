//
//  Showing.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation
import CoreData

class Showing: NSManagedObject, Decodable {
    @NSManaged var city: String
    @NSManaged var date: Date
    @NSManaged var venue: String
    @NSManaged var parentMovie: Movie
    
    private enum CodingKeys: String, CodingKey {
        case city
        case date
        case venue
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard
            let userInfoContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[userInfoContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Showing", in: managedObjectContext)
        else {
            fatalError("Failed to decode Showing!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        city = try values.decode(String.self, forKey: .city)
        date = try values.decode(Date.self, forKey: .date)
        venue = try values.decode(String.self, forKey: .venue)
    }
}
