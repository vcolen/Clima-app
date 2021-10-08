//
//  WeatherManager.swift
//  Clima
//
//  Created by Victor Colen on 29/09/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}
struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    func fetchWeather(cityName: String) {
        let openWeatherAPIKey = ProcessInfo.processInfo.environment["openWeatherAPIKey"]
        
        //in case the city name has 2 or more words
        let newCityName = cityName.components(separatedBy: " ")
        let urlString = weatherURL + "&appid=\(openWeatherAPIKey!)&q=\(newCityName.joined(separator: "%20"))"
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
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            
            let weather = WeatherModel(cityName: cityName, conditionId: id, temperature: temperature)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
