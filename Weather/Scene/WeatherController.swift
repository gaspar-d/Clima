//
//  WeatherController.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import UIKit

final class WeatherController: UIViewController {
	
	private var customView: WeatherView?
	private var viewModel: WeatherViewModelProtocol
	private var service: APICallerProtocol
	
	init(viewModel: WeatherViewModelProtocol, service: APICallerProtocol) {
		self.viewModel = viewModel
		self.service = service
		super.init(nibName: nil, bundle: nil)
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
	
	private func setupData() {
		viewModel.fetchData { [weak self] result in
			switch result {
			case .success(let weather):
				
				self?.viewModel.updateModel(with: weather)
				
				DispatchQueue.main.async {
					
					self?.customView?.setCityLabel(with: self?.viewModel.getName ?? "em branco")
					self?.customView?.setTemperatureLabel(with: self?.viewModel.getTemp ?? "em branco tbm")
				}
				
			case .failure(let error):
				print(error)
			}
		}
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
		print("Button tapped")
	}
}

// MARK: - Extensions
extension WeatherController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let inputedName = searchBar.text, !inputedName.isEmpty else { return }
		
		viewModel.searchCity(with: inputedName) { [weak self] result in
			switch result {
			case .success(let weather):
				self?.viewModel.updateModel(with: weather)
				
				DispatchQueue.main.async {
					self?.customView?.setCityLabel(with: self?.viewModel.getName ?? "")
					self?.customView?.setTemperatureLabel(with: self?.viewModel.getTemp ?? "")
				}
				
			case .failure(let error):
				print(error)
			}
		}
		searchBar.text = ""
	}
}

