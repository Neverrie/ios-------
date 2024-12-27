import UIKit
import MapKit

class ActivityInProgressViewController: UIViewController, MKMapViewDelegate{
    
    var activityType: String?
    
    private let mapView = MKMapView()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.text = "На велике"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "0 км | 00:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flag.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flag.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureActivityType()
    }
    
    private func setupUI() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        
        view.addSubview(activityLabel)
        view.addSubview(infoLabel)
        view.addSubview(pauseButton)
        view.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pauseButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            pauseButton.widthAnchor.constraint(equalToConstant: 50),
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stopButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 50),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureActivityType() {
        if let activityType = activityType {
            activityLabel.text = "На \(activityType.lowercased())"
        }
    }
}
