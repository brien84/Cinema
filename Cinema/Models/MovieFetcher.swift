//
//  MovieFetcher.swift
//  Cinema
//
//  Created by Marius on 2020-11-15.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

struct MovieFetcher {
    var movies = [Movie]()

    func fetchMovies(in city: City, using session: URLSession = .shared, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if CommandLine.arguments.contains("ui-testing") {
            guard let data = NSDataAsset(name: "UITestData")?.data else {
                fatalError("Cannot load UITestData!")
            }

            completion(decode(data))
        } else {
            let task = session.dataTask(with: city.api) { data, _, error in
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
}
