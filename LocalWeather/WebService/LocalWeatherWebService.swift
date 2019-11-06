//
//  LocalWeatherWebService.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

extension Dictionary where Key == String, Value == String {
    var queryString: String {
        return map({ "\($0.0)=\($0.1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }).joined(separator: "&")
    }
}

protocol Request {
    associatedtype Resp: Response

    static var path: String { get }
    static var httpMethod: HTTPMethod { get }

    var query: [String: String] { get }
}

protocol Response: Decodable {}

struct ResponseWrapper<Resp: Response>: Decodable {
    let response: Resp
}

class LocalWeatherWebService {

    // MARK: - Properties

    private let apiBaseURL = "http://worksample-api.herokuapp.com"
    private let apiKey: String

    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    private let urlSession = URLSession(configuration: .default)

    // MARK: - Object lifecycle

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension LocalWeatherWebService: WebService {
    func request<Req: Request>(request: Req, completion: @escaping (Result<Req.Resp, LocalWeatherError>) -> ()) {
        var queryDict = request.query

        queryDict["key"] = apiKey

        let queryString = queryDict.queryString
        let urlString = "\(apiBaseURL)/\(Req.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)?\(queryString)"

        guard let url = URL(string: urlString) else {
            completion(.failure(LocalWeatherError(code: .invalidURL, message: "Invalid URL", cause: nil)))
            return
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = Req.httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")

        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in

            if error != nil {
                completion(.failure(LocalWeatherError(code: .httpError, message: "Failed to send request", cause: error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(LocalWeatherError(code: .httpError, message: "Bad response", cause: error)))
                return
            }

            if response.statusCode < 200 || 300 <= response.statusCode {
                completion(.failure(LocalWeatherError(code: .httpError, message: "Bad response", cause: error)))
            }

            guard let data = data else {
                completion(.failure(LocalWeatherError(code: .httpError, message: "No data received", cause: nil)))
                return
            }

            let responseObj: Req.Resp
            do {
                responseObj = try self.jsonDecoder.decode(Req.Resp.self, from: data)
            } catch {
                completion(.failure(LocalWeatherError(code: .invalidURL, message: "Invalid JSON", cause: error)))
                return
            }
            completion(.success(responseObj))
        }
        task.resume()
    }
}
