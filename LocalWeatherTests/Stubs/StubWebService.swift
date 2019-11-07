//
//  StubWebService.swift
//  LocalWeatherTests
//
//  Created by Rab Gábor on 2019. 11. 07..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation
@testable import LocalWeather

class StubWebService: WebService {
    func request<Req>(request: Req, completion: @escaping (Result<Req.Resp, LocalWeatherError>) -> ()) where Req : Request {
        let response = MappingHelper.mapLocalJSONNamed("weather", toType: Req.Resp.self)
        completion(.success(response))
    }
}
