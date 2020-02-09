//
//  MovieManager.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import Foundation

typealias MovieManageable = MovieFetchable & MovieFilterable

protocol MovieFetchable: AnyObject {
    var movies: [Movie] { get set }
    
    func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> ())
}

protocol MovieFilterable {
    var movies: [Movie] { get }
    
    func filterMovies(in city: City, at date: Date) -> [Movie]
    func filterShowings(in city: City, at date: Date) -> [Showing]
}

extension MovieFetchable {
    func fetch(using session: URLSession = .shared, completion: @escaping (Result<Void, Error>) -> ()) {
        let task = session.dataTask(with: .api) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(self.decode(data))
            }
        }
        
        task.resume()
    }
    
    private func decode(_ data: Data) -> Result<Void, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            movies = try decoder.decode([Movie].self, from: data)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

extension MovieFilterable {
    func filterMovies(in city: City, at date: Date) -> [Movie] {
        return movies.flatMap { $0.getShowings(in: city, at: date).compactMap { $0.parentMovie } }.uniqued()
    }
    
    func filterShowings(in city: City, at date: Date) -> [Showing] {
        return movies.flatMap { $0.getShowings(in: city, at: date) }
    }
}

extension Movie {
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
