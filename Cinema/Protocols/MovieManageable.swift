//
//  MovieManager.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

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

        if CommandLine.arguments.contains("ui-testing") {

            guard let data = NSDataAsset(name: "UITestData")?.data else {
                fatalError("Cannot load UITestData!")
            }

            completion(decode(data))

        } else {

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
    }

    private func decode(_ data: Data) -> Result<Void, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            movies = try decoder.decode([Movie].self, from: data)
            movies.forEach { $0.showings.forEach { print($0.date) }}
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
