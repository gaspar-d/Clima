//
//  WeatherController.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import UIKit
import CoreLocation

final class WeatherController: UIViewController {
	
	private var customView: WeatherView?
	private var viewModel: WeatherViewModelProtocol
	private var service: APICallerProtocol
	private let location: CLLocationManager
	
	init(viewModel: WeatherViewModelProtocol,
		 service: APICallerProtocol,
		 location: CLLocationManager)
	{
		self.viewModel = viewModel
		self.service = service
		self.location = location
		super.init(nibName: nil, bundle: nil)
		
		location.delegate = self
		location.requestWhenInUseAuthorization()
		location.requestLocation()
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		setupNavigationBar()
		setupData()
	}
	
	// MARK: - Methods
	private func setupView() {
		customView = WeatherView()
		self.view = customView
	}
	
	private func setupNavigationBar() {
		customView?.setSearchBar.delegate = self
		
		navigationItem.titleView  = customView?.setSearchBar
		
		let buttonItem =  UIBarButtonItem(image: UIImage(systemName: "location.circle.fill"),
										  style: .done,
										  target: self,
										  action: #selector(didTapLocationButton))
		buttonItem.tintColor = .label
		navigationItem.leftBarButtonItem = buttonItem
	}
	
	@objc private func didTapLocationButton() {
		didTapRequestLocation()
	}
	
	private func setupData() {
		viewModel.setDataOnStart { [weak self] result in
			switch result {
			case .success(let weather):
				self?.defaultUpdateModel(with: weather)
				
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func defaultUpdateModel(with model: WeatherModel) {
		self.viewModel.updateModel(with: model)
		
		DispatchQueue.main.async {
			self.customView?.setLocationLabel(with: self.viewModel.getName ?? "Location")
			self.customView?.setTemperatureLabel(with: self.viewModel.getTemp ?? "XX")
			self.customView?.setWeatherImage(with: self.viewModel.getImage ?? "")
		}
	}
}

// MARK: - Extensions


extension WeatherController: UISearchBarDelegate {
	
	public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let inputedLocation = searchBar.text, !inputedLocation.isEmpty else { return }
		
		viewModel.setLocationOnSearch(with: inputedLocation) { [weak self] result in
			switch result {
			case .success(let weather):
				self?.defaultUpdateModel(with: weather)
				
			case .failure(let error):
				print(error)
			}
		}
		searchBar.text = ""
	}
}

extension WeatherController: CLLocationManagerDelegate {
	
	public func didTapRequestLocation() {
		location.requestLocation()
	}
	
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		
		let lat = location.coordinate.latitude
		let lon = location.coordinate.longitude
		
		viewModel.setDataOnTapLocationButton(lat: lat, lon: lon) { [weak self] result in
			switch result {
			case .success(let weather):
				self?.defaultUpdateModel(with: weather)
				
			case .failure(let error):
				print(error)
			}
		}
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to get user Location with: \(error)")
	}
}
