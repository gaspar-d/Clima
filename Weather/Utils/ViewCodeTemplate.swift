//
//  ViewCodeTemplate.swift
//  Weather
//
//  Created by Diogo Gaspar on 06/07/22.
//

import Foundation

import UIKit

protocol ViewCodeTemplate {
	func setup()
	func setupComponents()
	func setupConstraints()
	func setupExtraConfiguration()
}

extension ViewCodeTemplate {
	func setup() {
		setupComponents()
		setupConstraints()
		setupExtraConfiguration()
	}
	
	func setupExtraConfiguration() {}
}
