//
//  WeatherModel.swift
//  OpenWeatherWithCombine
//
//  Created by Вячеслав Квашнин on 12.05.2022.
//

import Foundation

struct WeatherModel: Codable {
    let main: Main?
    
    static var placeholder: Self {
        return WeatherModel(main: nil)
    }
}

struct Main: Codable {
    let temp: Double?
}
