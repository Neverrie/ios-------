import UIKit
import MapKit
import CoreLocation



protocol ActivitySelectionDelegate: AnyObject {
    func didStartActivity(type: String)
}

protocol ActivityCompletionDelegate: AnyObject {
    func didFinishActivity(distance: String, duration: String, type: String)
}

protocol ActivityInProgressDelegate: AnyObject {
    func didCompleteActivity(distance: String, duration: String, type: String)
}

class ActivityInProgressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    weak var delegate: ActivityInProgressDelegate?
    
    var activityType: String?
    private var isTracking = false
    private var timer: Timer?
    private var elapsedTime : Int = 0
    private var distance: Double = 0.0
    private var previousLocation: CLLocation?
    
    private var locationManager = CLLocationManager()
    private var routeCoordinates: [CLLocationCoordinate2D] = []
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let activitySelectionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis  = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let bikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🚴‍♂️ Велосипед", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let runButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🏃‍♂️ Бег", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    private let infoPanel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let distanceLabe: UILabel = {
        let label = UILabel()
        label.text = "0.00 км"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Стоп", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Финиш", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupLocationManager()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(activitySelectionStack)
        view.addSubview(infoPanel)
        
        activitySelectionStack.addArrangedSubview(bikeButton)
        activitySelectionStack.addArrangedSubview(runButton)
        
        infoPanel.addArrangedSubview(distanceLabe)
        infoPanel.addArrangedSubview(timeLabel)
        infoPanel.addArrangedSubview(stopButton)
        infoPanel.addArrangedSubview(finishButton)
        
        bikeButton.addTarget(self, action: #selector(startBikeActivity), for: .touchUpInside)
        runButton.addTarget(self, action: #selector(startRunActivity), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopActivity), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishActivity), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: activitySelectionStack.topAnchor),
            
            activitySelectionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activitySelectionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activitySelectionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            activitySelectionStack.heightAnchor.constraint(equalToConstant: 50),
            
            infoPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            infoPanel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    @objc private func startBikeActivity() {
        startActivity(type: "Велосипед")
    }
    
    @objc private func startRunActivity() {
        startActivity(type: "Бег")
    }
    
    private func startActivity(type : String) {
        activityType = type
        isTracking = true
        elapsedTime = 0
        distance = 0.0
        routeCoordinates = []
        activitySelectionStack.isHidden = true
        infoPanel.isHidden = false
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in self.elapsedTime += 1
            self.updateInfoPanel()}
    }
    
    private func updateInfoPanel(){
        let minutes = elapsedTime/60
        let seconds = elapsedTime%60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        distanceLabe.text = String(format: "%.2f км", distance)
    }
    
    @objc private func stopActivity() {
        isTracking = false
        timer?.invalidate()
    }
    
    @objc private func finishActivity() {
        stopActivity()
        let formattedDistance = String(format: "%.2f км", distance)
            let formattedDuration = String(format: "%02d:%02d", elapsedTime / 60, elapsedTime % 60)
            delegate?.didCompleteActivity(distance: formattedDistance, duration: formattedDuration, type: activityType ?? "Неизвестно")
        navigationController?.popViewController(animated: true)
    }
    
    func LocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isTracking, let newLocation = locations.last else {return}
        if let previousLocation = previousLocation {
            let deltaDistance = previousLocation.distance(from: newLocation) / 1000
            distance += deltaDistance
            routeCoordinates.append(newLocation.coordinate)
            
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)
        }
        previousLocation = newLocation
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
