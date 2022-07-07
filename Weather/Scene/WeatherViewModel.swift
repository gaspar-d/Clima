//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation

protocol WeatherViewModelProtocol: AnyObject {
	var getName: String? { get }
	var getTemp: String? { get }
	
	func updateModel(with weather:WeatherModel)
	func fetchData(completion: @escaping (Result<WeatherModel, Error>) -> Void)
	func searchCity(with city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void)
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
	
	public var getTemp: String? {
		guard let temp = model.main?.temp else { return "" }
		
		let result = String(Int(temp))
		return result
	}
	
	public func updateModel(with weather:WeatherModel) {
		model = weather
	}
	
	public func fetchData(completion: @escaping (Result<WeatherModel, Error>) -> Void) {
		service.fetchDataOnStart(completion: completion)
	}
	
	public func searchCity(with city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
		service.searchCity(with: city, completion: completion)
	}
	
	public var getName: String? {
		model.name
	}
}

//
