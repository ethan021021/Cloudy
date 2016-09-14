//
//  WeatherTableViewCell.swift
//  Cloudy
//
//  Created by Ethan Thomas on 9/13/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var weatherDay: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var weatherHigh: UILabel!
    @IBOutlet weak var weatherLow: UILabel!

    func configureCell(forecast: Forecast) {
        weatherLow.text = String(forecast.lowTemp)
        weatherHigh.text = String(forecast.highTemp)
        weatherCondition.text = forecast.weatherType
        weatherImage.image = UIImage(named: forecast.weatherType)
        weatherDay.text = forecast.date
    }

}
