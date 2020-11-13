//
//  URLSession+Testable.swift
//  CinemaTests
//
//  Created by Marius on 2020-11-13.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

private final class URLProtocolMock: URLProtocol {
    static var testData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    /// As soon as loading starts, sends back `testData` or an `URLError`, then ends loading.
    override func startLoading() {
        if let data = URLProtocolMock.testData {
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: URLError.init(.notConnectedToInternet))
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}

extension URLSession {
    /// - Parameter data: Data returned by `URLSession`.
    /// If `nil` value is provided, then `URLSession` will return `URLError.notConnectedToInternet`.
    static func makeMockSession(with data: Data?) -> URLSession {
        URLProtocolMock.testData = data

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: config)
    }
}
