//
//  APICaller.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation

protocol APICallerProtocol: AnyObject {
	func fetchDataOnStart(completion: @escaping (Result<WeatherModel, Error>) -> Void)
	func searchCity(with query: String?, completion: @escaping (Result<WeatherModel, Error>) -> Void)
}

final class APICaller {
	
	private var baseUrl = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?appid=4931272735a9eca3899ff6aaed5a2a01&units=metric&q=Osasco")
	
	private var baseUrl2: String = "https://api.openweathermap.org/data/2.5/weather?appid=4931272735a9eca3899ff6aaed5a2a01&units=metric&q="
	
	private var searchURL: String = "https://api.openweathermap.org/data/2.5/weather?"
	
	
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
	
	public func fetchDataOnStart(completion: @escaping (Result<WeatherModel, Error>) -> Void) {
		guard let url = baseUrl?.url else { return }
		defaultRequest(url: url, completion: completion)
	}
	
	public func searchCity(with query: String?, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
		guard let city = query, !city.isEmpty else { return }
//		city.trimmingCharacters(in: .whitespaces)
		
		let searchQuery = [URLQueryItem(name: "appid", value: "4931272735a9eca3899ff6aaed5a2a01"),
						   URLQueryItem(name: "units", value: "metric"),
						   URLQueryItem(name: "q", value: city)]
		
		var urlWithQueries = URLComponents(string: searchURL)
		urlWithQueries?.queryItems = searchQuery
		
		guard let url = urlWithQueries?.url else { return }
		
		self.defaultRequest(url: url, completion: completion)
	}
}
