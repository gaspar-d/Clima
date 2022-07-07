//
//  WeatherView.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import UIKit

final class WeatherView: UIView {
	
	private lazy var searchBar: UISearchController = {
		let search = UISearchController(searchResultsController: nil)
		search.hidesNavigationBarDuringPresentation = false
		search.searchBar.sizeToFit()
		search.searchBar.tintColor = .label
		search.searchBar.placeholder = "Busque por sua cidade..."
		
		return search
	}()
	
	private lazy var backgroundImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "background")
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.masksToBounds = true
		
		return imageView
	}()
	
	private lazy var weatherImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(systemName: "cloud.rain")
		imageView.tintColor = .label
		
		return imageView
	}()
	
	private lazy var temperatureNumberLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "20"
		label.font = .systemFont(ofSize: 88, weight: .heavy)
		
		return label
	}()
	
	private lazy var temperatureCelsiusLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "˚C"
		label.font = .systemFont(ofSize: 88, weight: .light)
		
		return label
	}()
	
	private lazy var temperatureStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [temperatureNumberLabel, temperatureCelsiusLabel])
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .horizontal
		stack.distribution = .equalSpacing
		stack.alignment = .center
		
		return stack
	}()
	
	
	private lazy var cityLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Location"
		label.font = .systemFont(ofSize: 24, weight: .medium)
		
		return label
	}()
	
	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [weatherImage, temperatureStack, cityLabel])
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.distribution = .equalSpacing
		stack.spacing = 20
		stack.alignment = .trailing
		
		return stack
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - methods
	
	
	public var setSearchBar: UISearchBar {
		return searchBar.searchBar
	}
	
	public func setLocationLabel(with text: String) {
		cityLabel.text = text
	}
	
	public func setTemperatureLabel(with temp: String) {
		temperatureNumberLabel.text = temp
	}
	
	public func setWeatherImage(with temp: String) {
		weatherImage.image = UIImage(systemName: temp)
	}
}

// MARK: - extensions


extension WeatherView: ViewCodeTemplate {
	func setupComponents() {
		addSubview(backgroundImage)
		addSubview(stack)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			backgroundImage.heightAnchor.constraint(equalTo: heightAnchor),
			backgroundImage.widthAnchor.constraint(equalTo: widthAnchor),
			
			weatherImage.heightAnchor.constraint(equalToConstant: 100),
			weatherImage.widthAnchor.constraint(equalToConstant: 100),
			
			stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
		])
	}
	
	func setupExtraConfiguration() {
		backgroundColor = .systemYellow
	}
}
