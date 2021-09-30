//
//  WeatherManager.swift
//  Clima
//
//  Created by Victor Colen on 29/09/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b2d55347e3caada7329bd843886e7456&units=metric&q="
    
    func fetchWeather(cityName: String) {
        let urlString = weatherURL + cityName
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URL session
            let session = URLSession(configuration: .default)
            //3. Perform task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
}
