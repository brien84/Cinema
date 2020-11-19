//
//  MovieFetcher.swift
//  Cinema
//
//  Created by Marius on 2020-11-15.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MovieFetcher {
    private var movies = [Movie]()

    func fetch(using session: URLSession = .shared, completion: @escaping (Result<Void, Error>) -> Void) {
        if CommandLine.arguments.contains("ui-testing") {
            guard let data = NSDataAsset(name: "UITestData")?.data else {
                fatalError("Cannot load UITestData!")
            }

            completion(decode(data))
        } else {
            let city = UserDefaults.standard.readCity()

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

    private func decode(_ data: Data) -> Result<Void, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            self.movies = try decoder.decode([Movie].self, from: data)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

extension Showing {
    func isShown(at date: Date) -> Bool {
        // Is `self.date` in the past.
        if self.date < Date() { return false }

        let calendar = Calendar.current
        return calendar.isDate(self.date, inSameDayAs: date)
    }
}
