//
//  MovieManager.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation
import UIKit

class MovieManager {
    private var movies = [Movie]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        getData { data in
            self.movies = self.decode(data: data)
            print(self.movies.count)
        }
    }
    
    private func decode(data: Data) -> [Movie] {
        guard let userInfoContext = CodingUserInfoKey.context else { return [] }
        
        let decoder = JSONDecoder()
        decoder.userInfo[userInfoContext] = context
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([Movie].self, from: data)
        } catch {
            print("Error decoding [Movie]! \(error)")
        }
        
        return []
    }
    
    private func getData(completionHandler: @escaping (Data) -> ()) {
        guard let url = URL(string: "http://localhost:8080/hello") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            completionHandler(data)
        }.resume()
    }
}
