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

    init() {
        loadMovies()
    }
    
    func loadMovies() {
        fetchMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                NotificationCenter.default.post(name: .moviesDidFetchSuccessfully, object: nil)
            case .failure(let error):
                print("MovieManager.loadMovies: \(error.localizedDescription)")
                NotificationCenter.default.post(name: .moviesDidFetchWithError, object: nil)
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
            return .failure(error)
        }
    }
    
    private func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        URLSession.shared.dataTask(with: Constants.URLs.api) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return completion(.failure(URLError(.badServerResponse))) }
            
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
