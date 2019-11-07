//
//  StubWebServiceFailing.swift
//  LocalWeatherTests
//
//  Created by Rab Gábor on 2019. 11. 07..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation
@testable import LocalWeather

class StubWebServiceFailing: WebService {
    func request<Req>(request: Req, completion: @escaping (Result<Req.Resp, LocalWeatherError>) -> ()) where Req : Request {
        completion(.failure(LocalWeatherError(code: .httpError, message: "No internet")))
    }
}
