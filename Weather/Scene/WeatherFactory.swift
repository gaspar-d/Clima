//
//  WeatherFactory.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation
import CoreLocation

enum WeatherFactory {
	
	static func make() -> WeatherController {
		
		let location = CLLocationManager()
		let model = WeatherModel()
		let api = APICaller()
		let vm = WeatherViewModel(service: api, model: model)
		let vc = WeatherController(viewModel: vm , service: api, location: location)
		
		return vc
	}
}
