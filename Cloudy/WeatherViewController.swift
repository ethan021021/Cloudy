//
//  ViewController.swift
//  Cloudy
//
//  Created by Ethan Thomas on 9/13/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentWeatherConditionLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var currentWeather: CurrentWeather!
    
    var forecast: Forecast!
    
    var forecasts = [Forecast]()
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        currentWeather = CurrentWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for the tableview
        let forecastURL = URL(string: FORECAST_URL)!
        
        Alamofire.request(forecastURL).responseJSON { (response) in
            let result = response.result
            
            if let dict = result.value as? [String: Any] {
                if let list = dict["list"] as? [[String: Any]] {
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.weatherTableView.reloadData()
                }
            }
            completed()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = String(currentWeather.currentTemperature)
        currentWeatherConditionLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImageView.image = UIImage(named: currentWeather.weatherType)
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.first {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                currentLocation = currentLoc
                locationManager.stopUpdatingLocation()
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                currentWeather.downloadWeatherDetails {
                    self.downloadForecastData {
                        self.updateMainUI()
                    }
                }
            } else {
                locationManager.requestWhenInUseAuthorization()
                locationAuthStatus()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherTableViewCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherTableViewCell()
        }
    }
}

