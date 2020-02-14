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

    func fetch(using session: URLSession, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol MovieFilterable {
    var movies: [Movie] { get }

    func filterMovies(in city: City, at date: Date) -> [Movie]
    func filterShowings(in city: City, at date: Date) -> [Showing]
}

extension MovieFetchable {
    func fetch(using session: URLSession = .shared, completion: @escaping (Result<Void, Error>) -> Void) {
        let task = session.dataTask(with: .api) { data, _, error in
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
