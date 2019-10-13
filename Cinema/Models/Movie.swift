//
//  Movie.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject, Decodable {
    @NSManaged var title: String?
    @NSManaged var originalTitle: String?
    @NSManaged var duration: String?
    @NSManaged var ageRating: String?
    @NSManaged var genre: String?
    @NSManaged var country: String?
    @NSManaged var releaseDate: String?
    @NSManaged var poster: String?
    @NSManaged var plot: String?
    @NSManaged var showings: Set<Showing>
    
    private enum CodingKeys: String, CodingKey {
        case title
        case originalTitle
        case duration
        case ageRating
        case genre
        case country
        case releaseDate
        case poster
        case plot
        case showings
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard
            let userInfoContext = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[userInfoContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedObjectContext)
        else {
            fatalError("Failed to decode Movie!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try? values.decode(String.self, forKey: .title)
        originalTitle = try? values.decode(String.self, forKey: .originalTitle)
        duration = try? values.decode(String.self, forKey: .duration)
        ageRating = try? values.decode(String.self, forKey: .ageRating)
        genre = try? values.decode(String.self, forKey: .genre)
        country = try? values.decode(String.self, forKey: .country)
        releaseDate = try? values.decode(String.self, forKey: .releaseDate)
        poster = try? values.decode(String.self, forKey: .poster)
        plot = try? values.decode(String.self, forKey: .plot)
        
        showings = try values.decode(Set<Showing>.self, forKey: .showings)
    }
}
