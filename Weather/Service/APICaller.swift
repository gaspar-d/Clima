//
//  APICaller.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation

protocol APICallerProtocol: AnyObject {
	typealias handler = (Result<WeatherModel, Error>) -> Void
	
	func fetchDataOnStart(completion: @escaping handler)
	func fetchDataOnTapLocationButton(latitude: String, longitude: String, completion: @escaping handler)
	func fetchLocationOnSearch(with query: String?, completion: @escaping handler)
}

final class APICaller {
	
	private var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
	var appId = "4931272735a9eca3899ff6aaed5a2a01"
	var units = "metric"
	var query = "london"
	
	private func defaultRequest(url: URL, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				completion(.failure(error))
				
			} else if let data = data {
				do {
					let result = try JSONDecoder().decode(WeatherModel.self, from: data)
					completion(.success(result))
					
				} catch {
					completion(.failure(error))
				}
			}
		}
		task.resume()
	}
}

extension APICaller: APICallerProtocol {
	
	public func fetchDataOnStart(completion: @escaping handler) {
		let startQuery = [URLQueryItem(name: "appid", value: appId),
						  URLQueryItem(name: "units", value: units),
						  URLQueryItem(name: "q", value: "london")]
		
		baseURL?.queryItems = startQuery
		guard let url = baseURL?.url else { return }
		
		defaultRequest(url: url, completion: completion)
	}
	
	public func fetchDataOnTapLocationButton(latitude: String, longitude: String, completion: @escaping handler) {
		let coordinatesQuery = [URLQueryItem(name: "appid", value: appId),
								URLQueryItem(name: "units", value: units),
								URLQueryItem(name: "lat", value: latitude),
								URLQueryItem(name: "lon", value: longitude)]
		
		baseURL?.queryItems = coordinatesQuery
		guard let url = baseURL?.url else { return }
		
		defaultRequest(url: url, completion: completion)
	}
	
	public func fetchLocationOnSearch(with query: String?, completion: @escaping handler) {
		guard let inputedLocation = query, !inputedLocation.isEmpty else { return }
		
		let searchQuery = [URLQueryItem(name: "appid", value: appId),
						   URLQueryItem(name: "units", value: units),
						   URLQueryItem(name: "q", value: inputedLocation)]
		
		baseURL?.queryItems = searchQuery
		guard let url = baseURL?.url else { return }
		
		self.defaultRequest(url: url, completion: completion)
	}
}

