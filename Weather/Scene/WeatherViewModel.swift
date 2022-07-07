//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation
import CoreLocation

protocol WeatherViewModelProtocol: AnyObject {
	typealias handler = (Result<WeatherModel, Error>) -> Void
	
	var getName: String? { get }
	var getTemp: String? { get }
	var getImage: String? { get }
	
	func updateModel(with weather:WeatherModel)
	func setDataOnStart(completion: @escaping handler)
	func setLocationOnSearch(with city: String, completion: @escaping handler)
	func setDataOnTapLocationButton(lat: Double, lon: Double, completion: @escaping handler)
}

final class WeatherViewModel: NSObject {
	
	private var service: APICallerProtocol
	private var model: WeatherModel
	
	init(service: APICallerProtocol, model: WeatherModel) {
		self.service = service
		self.model = model
		super.init()
	}
}

extension WeatherViewModel: WeatherViewModelProtocol {
	
	public var getName: String? {
		model.name
	}
	
	public var getTemp: String? {
		guard let temp = model.main?.temp else { return "" }
		
		let result = String(Int(temp))
		return result
	}
	
	public var getImage: String? {
		let index = (model.weather?.count ?? 0) - 1
		guard let weatherID = model.weather![index].id else { return "" }
		
		switch weatherID {
		case 200...232:
			return "cloud.bolt.rain"
			
		case 300...321:
			return "cloud.drizzle"
			
		case 500...531:
			return "cloud.heavyrain"
			
		case 600...622:
			return "snowflake"
			
		case 701...781:
			return "sun.max.circle.fill"
			
		case 800:
			return "sun.max"
			
		case 801...804:
			return "cloud.sun"
			
		default:
			return "sun.max"
		}
	}
	
	public func updateModel(with weather:WeatherModel) {
		model = weather
	}
	
	public func setDataOnStart(completion: @escaping handler) {
		service.fetchDataOnStart(completion: completion)
	}
	
	public func setLocationOnSearch(with city: String, completion: @escaping handler) {
		service.fetchLocationOnSearch(with: city, completion: completion)
	}
	
	public func setDataOnTapLocationButton(lat: Double, lon: Double, completion: @escaping handler) {
		service.fetchDataOnTapLocationButton(latitude: String(lat),
											 longitude: String(lon),
											 completion: completion)
	}
}

