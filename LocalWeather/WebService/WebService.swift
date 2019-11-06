//
//  WebService.swift
//  LocalWeather
//
//  Created by Rab Gábor on 2019. 11. 06..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation

protocol WebService {
    func request<Req: Request>(request: Req, completion: @escaping (Result<Req.Resp, LocalWeatherError>) -> ())
}
