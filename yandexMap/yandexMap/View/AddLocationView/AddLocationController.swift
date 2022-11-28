//
//  AddLocationController.swift
//  yandexMap
//
//  Created by emil kurbanov on 18.11.2022.
//

import UIKit
class AddLocationController: UIViewController {

      let slideIdicator: UIView = {
                let slide = UIView()
        slide.backgroundColor = .black
                slide.translatesAutoresizingMaskIntoConstraints = false
                return slide
            }()
        let infoLabel: UILabel = {
                let label = UILabel()
               
                label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
        

        let addLocationButton: UIButton = {
                let button = UIButton()
            button.title(for: .normal)
            button.titleColor(for: .normal)
            button.backgroundColor = .gray
            button.setTitle("Сохранить", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
    // MARK: - Properties
    // Для хранения адресов, сделать массивом если захотим передать в личный кабинет пользовтаеля
    var infoTitle: String?
    // Animation Properties
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(slideIdicator)
        view.addSubview(infoLabel)
        view.addSubview(addLocationButton)
        setConstraints()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        //choiseSearch()
        slideIdicator.roundCorners(.allCorners, radius: 10)
        addLocationButton.roundCorners(.allCorners, radius: 10)
        
       /* if let locations = UserDefaults.standard.array(forKey: "locations") as? [String] {
            for location in locations {
                if infoTitle! == location {
                    addLocationButton.setTitle("Already added", for: .normal)
                    addLocationButton.isUserInteractionEnabled = false
                }
            }
        }*/
        
          infoLabel.text = infoTitle
        choiseSearch()
    }
    
    
    func choiseSearch() {
        if infoLabel.text == "Россия, Москва" {
            let alert = UIAlertController(title: "Есть такой горд", message: "есть такой город", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
           present(alert, animated: true,completion: nil)
        } else {
            let alert = UIAlertController(title: "нет", message: "есть такой город", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
            present(alert, animated: true,completion: nil)
        }
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
            print("ПЕРЕДАЛИ ИНФОРМАЦИЮ НА СЕРВЕР")
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    func setConstraints() {
            NSLayoutConstraint.activate([
                slideIdicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                slideIdicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 177),
                slideIdicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 177),
                slideIdicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 49),
                slideIdicator.heightAnchor.constraint(equalToConstant: 4),
                slideIdicator.widthAnchor.constraint(equalToConstant: 60),
                
                infoLabel.topAnchor.constraint(equalTo: slideIdicator.bottomAnchor, constant: 10),
                infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
                infoLabel.bottomAnchor.constraint(equalTo: addLocationButton.topAnchor, constant: 10),
                infoLabel.heightAnchor.constraint(equalToConstant: 52),
                infoLabel.widthAnchor.constraint(equalToConstant: 394),
                
                addLocationButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
                addLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 170),
                addLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 198),
                addLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
                addLocationButton.heightAnchor.constraint(equalToConstant: 40),
                addLocationButton.widthAnchor.constraint(equalToConstant: 46),
            ])
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
