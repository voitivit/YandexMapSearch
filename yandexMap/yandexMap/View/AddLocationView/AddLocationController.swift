//
//  AddLocationController.swift
//  yandexMap
//
//  Created by emil kurbanov on 18.11.2022.
//

import UIKit
class AddLocationController: UIViewController {
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var addLocationButton: UIButton! {
        didSet {
            addLocationButton.title(for: .normal)
            addLocationButton.titleColor(for: .normal)
            addLocationButton.backgroundColor = .gray
            addLocationButton.setTitle("Сохранить", for: .normal)
        }
    }
    
    // MARK: - Properties
    // Для хранения адресов, сделать массивом если захотим передать в личный кабинет пользовтаеля
    var infoTitle: String?
    // Animation Properties
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        addLocationButton.roundCorners(.allCorners, radius: 10)
        
        if let locations = UserDefaults.standard.array(forKey: "locations") as? [String] {
            for location in locations {
                if infoTitle! == location {
                    addLocationButton.setTitle("Already added", for: .normal)
                    addLocationButton.isUserInteractionEnabled = false
                }
            }
        }
        infoLabel.text = infoTitle
    }
    init(infoTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.infoTitle = infoTitle
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @IBAction func addLocationTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Сохранить адрес в профиль", message: infoTitle, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            // Сохраняем локацию, можно через UserDefaults
            /*if var locations = UserDefaults.standard.array(forKey: "locations") as? [String],
               let infoTitle = self?.infoTitle {
                locations.append(infoTitle)
                UserDefaults.standard.set(locations, forKey: "locations")
            }*/
            print("СОХРАНИЛИ В ЛИЧНОМ КАБИНЕТЕ ПОЛЬЗОВАТЕЛЯ")
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
extension AddLocationController {
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Чтобы юзер не перетаскивал вид вверх
        guard translation.y >= 0 else { return }
        
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Контроллер просмотра в исходное положение
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
