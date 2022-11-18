//
//  ViewController.swift
//  yandexMap
//
//  Created by emil kurbanov on 16.11.2022.
//

import UIKit
import YandexMapsMobile
class ViewController: UIViewController {

    @IBOutlet weak var mapYandex: YMKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapYandex.mapWindow.map.move(
              with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
              animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
              cameraCallback: nil)
        
    }


}

