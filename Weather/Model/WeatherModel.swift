//
//  WeatherModel.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation

struct WeatherModel: Decodable {
	var name: String?
	var main: Main?
	var weather: [Weather]?
}

struct Main: Decodable {
	var temp: Float?
}

struct Weather: Decodable {
	var id: Int?
}
