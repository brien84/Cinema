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
    
    private func decode(_ data: Data) -> Result<[Movie], Error> {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let movies = try decoder.decode([Movie].self, from: data)
            return .success(movies)
        } catch {
            print("MovieManager.decode: \(error.localizedDescription)")
            return .failure(FetchError.decoding)
        }
    }
    
    private func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        
        URLSession.shared.dataTask(with: Constants.URLs.api) { data, response, error in
            if let error = error {
                print("MovieManager.fetchData: \(error.localizedDescription)")
                completion(.failure(FetchError.networkError))
            }
            
            guard let data = data else { return completion(.failure(FetchError.noData)) }
            
            completion(self.decode(data))
        }.resume()
    }
    
    func getMovies(in city: City, at date: Date) -> [Movie] {
        return movies.filter { $0.isShown(in: city) && $0.isShown(at: date) }
    }
    
    func getShowings(in city: City, at date: Date) -> [Showing] {
        return movies.flatMap { $0.getShowings(in: city, at: date) }
    }
}

extension Movie {
    fileprivate func isShown(in city: City) -> Bool {
        return self.showings.contains { $0.isShown(in: city) }
    }
    
    fileprivate func isShown(at date: Date) -> Bool {
        return self.showings.contains { $0.isShown(at: date) }
    }
    
    func getShowings(in city: City) -> [Showing] {
        return self.showings.filter { $0.isShown(in: city) }
    }
    
    func getShowings(in city: City, at date: Date) -> [Showing] {
        return self.showings.filter { $0.isShown(in: city) && $0.isShown(at: date) }
    }
}

extension Showing {
    fileprivate func isShown(in city: City) -> Bool {
        if self.date.isInThePast() { return false }
        
        return self.city == city.rawValue
    }
    
    fileprivate func isShown(at date: Date) -> Bool {
        if self.date.isInThePast() { return false }
        
        let calendar = Calendar.current
        return calendar.isDate(self.date, inSameDayAs: date)
    }
}
