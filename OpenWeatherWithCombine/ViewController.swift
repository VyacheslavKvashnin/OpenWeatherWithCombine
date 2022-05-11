//
//  ViewController.swift
//  OpenWeatherWithCombine
//
//  Created by Вячеслав Квашнин on 11.05.2022.
//

import UIKit
import Combine

enum WeatherError: Error {
    case invalidData
}

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    private let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}"
    private let keyAPI = "2f30fa8890e957cad6b72824a417b042"
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func newButton(_ sender: Any) {
        view.endEditing(true)
        guard let cityName = cityTextField.text else { return }
        getTemperature(for: cityName)
    }
    
    
    private func getTemperature(for cityName: String) {
        guard let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(keyAPI)&units=metric") else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: weatherURL)
            .tryMap { data, response -> Data in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw WeatherError.invalidData
                    }
                return data
            }
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .catch { error in
                return Just(WeatherModel.placeholder)
            }
            .map { $0.main?.temp ?? 0.0 }
            .map { "\($0)℃" }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [self] temp in
                temperatureLabel.text = "\(temp)"
            })
    }
}

