//
//  MappingHelper.swift
//  LocalWeatherTests
//
//  Created by Rab Gábor on 2019. 11. 07..
//  Copyright © 2019. Gabor Rab. All rights reserved.
//

import Foundation
@testable import LocalWeather

class MappingHelper {
    class func mapLocalJSONNamed<T: Decodable>(_ name: String, toType type: T.Type) -> T {

        func json(fromFileNamed name: String) -> Any {
            let path = Bundle(for: MappingHelper.self).path(forResource: name, ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            return try! JSONSerialization.jsonObject(with: data)
        }

        let data = try! JSONSerialization.data(withJSONObject: json(fromFileNamed: name), options: [])
        let decoder = JSONDecoder()
        return try! decoder.decode(type, from: data)
    }
}
