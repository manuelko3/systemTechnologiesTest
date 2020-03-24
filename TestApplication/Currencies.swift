//
//  Currencies.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import Foundation

struct Currencies: Codable {
    let disclaimer, license: String
    let timestamp: Int
    let rates: [String: Double]
}
