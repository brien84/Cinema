//
//  MovieManager.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation
import UIKit

private enum FetchError: Error {
    case networkError
    case noData
    case decoding
}

class MovieManager {
    private var movies = [Movie]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fetchMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                NotificationCenter.default.post(name: .didFinishFetching, object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovies(shownAt date: Date) -> [Movie] {
        let calendar = Calendar.current
        
        return movies.filter { movie in
            movie.showings.contains { showing in
                calendar.isDate(showing.date, inSameDayAs: date)
            }
        }
    }
    
    func getShowings(shownAt date: Date) -> [Showing] {
        let calendar = Calendar.current
        
        return getMovies(shownAt: date).flatMap { movie in
            movie.showings.filter { showing in
                calendar.isDate(showing.date, inSameDayAs: date)
            }
        }
    }
    
    private func decode(_ data: Data) -> Result<[Movie], Error> {
        guard let userInfoContext = CodingUserInfoKey.context else { fatalError("MovieManager.decode(...): Could not get CodingUserInfoKey") }
        
        let decoder = JSONDecoder()
        decoder.userInfo[userInfoContext] = context
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let movies = try decoder.decode([Movie].self, from: data)
            return .success(movies)
        } catch {
            print("MovieManager.decode(...): \(error.localizedDescription)")
            return .failure(FetchError.decoding)
        }
    }
    
    private func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:8080/movies") else { fatalError("MovieManager.fetchData(...): Invalid URL provided") }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("MovieManager.fetchData(...): \(error.localizedDescription)")
                completion(.failure(FetchError.networkError))
            }
            
            guard let data = data else { return completion(.failure(FetchError.noData)) }
            
            completion(self.decode(data))
        }.resume()
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
