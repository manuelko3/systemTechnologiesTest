//
//  Network.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import Foundation

struct Network {
    
    static func getCurrencyRates(baseCurrency: String, completion: @escaping (_ result: Currencies) -> Void, failed: @escaping (_ result: String) -> Void) {
        
        let session = URLSession(configuration: .default)
        var urlComponent = URLComponents(string: Constants.baseUrl + Constants.latest)!
        urlComponent.queryItems = [
            URLQueryItem(name: "app_id", value: Constants.apiKey),
            URLQueryItem(name: "base", value: baseCurrency),
        ]
        
        let task = session.dataTask(with: urlComponent.url!, completionHandler: { data, response, error in

            if let error = error {
                failed("Error \(error.localizedDescription)")
                print(error)
                return
            }
            do {
                let json = try JSONDecoder().decode(Currencies.self, from: data!)
                completion(json)
            } catch {
                failed("Error \(error.localizedDescription)")
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    static func getAllCurrencies(completion: @escaping (_ result: [String:String]) -> Void, failed: @escaping (_ result: String) -> Void) {
        
        let session = URLSession(configuration: .default)
        let url = URL(string: Constants.baseUrl + "currencies.json")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
 
            if let error = error {
                failed("Error \(error.localizedDescription)")
                print(error)
                return
            }
            do {
                let json = try JSONDecoder().decode([String:String].self, from: data!)
                completion(json)
                
            } catch {
                failed("Error \(error.localizedDescription)")
                print(error.localizedDescription)
            }   
        })
        task.resume()
    }
}

