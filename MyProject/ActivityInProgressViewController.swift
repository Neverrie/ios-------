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

struct ActivityData: Codable {
    let date: String
    let distance: Double
    let duration: Double
}

class ActivityInProgressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    weak var delegate: ActivityInProgressDelegate?
    
    private var userAnnotation: MKPointAnnotation = MKPointAnnotation()
    
    var activityType: String?
    private var isTracking = false
    private var timer: Timer?
    private var elapsedTime: Int = 0
    private var distance: Double = 0.0
    private var previousLocation: CLLocation?
    
    private var locationManager = CLLocationManager()
    private var routeCoordinates: [CLLocationCoordinate2D] = []
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let activitySelectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Погнали?"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activitySelectionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 12
        stack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOpacity = 0.1
        stack.layer.shadowOffset = CGSize(width: 0, height: -2)
        stack.layer.shadowRadius = 4
        return stack
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let bikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Велосипед", for: .normal)
        button.setImage(UIImage(systemName: "bicycle"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let runButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Бег", for: .normal)
        button.setImage(UIImage(systemName: "figure.run"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    private let infoPanel: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let activityTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let distanceTimeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00 км"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()

    private let pauseResumeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause"), for: .normal)
        button.layer.cornerRadius = 40
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flag"), for: .normal)
        button.layer.cornerRadius = 50
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pauseFinishStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        setupUI()
        setupLocationManager()
    }

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(activitySelectionStack)
        view.addSubview(infoPanel)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)

        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.heightAnchor.constraint(equalToConstant: 20).isActive = true

        activitySelectionStack.addArrangedSubview(topSpacer)
        activitySelectionStack.addArrangedSubview(activitySelectionTitle)
        activitySelectionStack.addArrangedSubview(buttonsStack)

        buttonsStack.addArrangedSubview(bikeButton)
        buttonsStack.addArrangedSubview(runButton)

        infoPanel.addArrangedSubview(activityTypeLabel)
        infoPanel.addArrangedSubview(distanceTimeStack)
        distanceTimeStack.addArrangedSubview(distanceLabel)
        distanceTimeStack.addArrangedSubview(timeLabel)
        infoPanel.addArrangedSubview(pauseFinishStack)

        pauseFinishStack.addArrangedSubview(pauseResumeButton)
        pauseFinishStack.addArrangedSubview(finishButton)
        
        pauseResumeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pauseResumeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true

        finishButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        finishButton.widthAnchor.constraint(equalToConstant: 60).isActive = true

        bikeButton.addTarget(self, action: #selector(startBikeActivity), for: .touchUpInside)
        runButton.addTarget(self, action: #selector(startRunActivity), for: .touchUpInside)
        pauseResumeButton.addTarget(self, action: #selector(togglePauseResume), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishActivity), for: .touchUpInside)

        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: activitySelectionStack.topAnchor),

            activitySelectionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activitySelectionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activitySelectionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            activitySelectionTitle.topAnchor.constraint(equalTo: activitySelectionStack.topAnchor, constant: 20),
            activitySelectionTitle.centerXAnchor.constraint(equalTo: activitySelectionStack.centerXAnchor),

            buttonsStack.leadingAnchor.constraint(equalTo: activitySelectionStack.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: activitySelectionStack.trailingAnchor, constant: -20),
            buttonsStack.topAnchor.constraint(equalTo: activitySelectionTitle.bottomAnchor, constant: 70),

            distanceTimeStack.leadingAnchor.constraint(equalTo: infoPanel.leadingAnchor, constant: 20),
            distanceTimeStack.trailingAnchor.constraint(equalTo: infoPanel.trailingAnchor, constant: -20),

            infoPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            pauseResumeButton.heightAnchor.constraint(equalToConstant: 70),
            pauseResumeButton.widthAnchor.constraint(equalToConstant: 70),
            finishButton.heightAnchor.constraint(equalToConstant: 70),
            finishButton.widthAnchor.constraint(equalToConstant: 70),

            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomOutButton.bottomAnchor.constraint(equalTo: activitySelectionStack.topAnchor, constant: -50),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 40),

            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -10),
            zoomInButton.widthAnchor.constraint(equalToConstant: 40),
            zoomInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func startBikeActivity() {
        activitySelectionTitle.text = "На велике!"
        startActivity(type: "Велосипед")
    }

    @objc private func startRunActivity() {
        activitySelectionTitle.text = "На ногах!"
        startActivity(type: "Бег")
    }

    private func startActivity(type: String) {
        activityType = type
        isTracking = true
        elapsedTime = 0
        distance = 0.0
        routeCoordinates = []
        activitySelectionStack.isHidden = true
        infoPanel.isHidden = false
        activityTypeLabel.text = type == "Велосипед" ? "На велике!" : "На ногах!"
        
        let startTime = Date()
        
        UserDefaults.standard.set(startTime, forKey: "activityStartTime")
        
        startTimer()
        startSimulation()
    }

    private func setupLocationManager() {
        tabBarController?.tabBar.isHidden = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let dvfuCoordinate = CLLocationCoordinate2D(latitude: 43.0228, longitude: 131.8925)
        let region = MKCoordinateRegion(center: dvfuCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        userAnnotation.title = "Вы здесь"
        mapView.addAnnotation(userAnnotation)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
            self?.updateInfoPanel()
        }
    }
    
    private func updateInfoPanel() {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        distanceLabel.text = String(format: "%.2f км", distance)
    }

    private var isPaused = false
    
    @objc private func togglePauseResume() {
        isPaused.toggle()
        if isPaused {
            pauseResumeButton.setImage(UIImage(systemName: "play"), for: .normal)
            stopTimer()
        } else {
            pauseResumeButton.setImage(UIImage(systemName: "pause"), for: .normal)
            startTimer()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" 
        return formatter.string(from: date)
    }
    
    @objc private func finishActivity() {
        stopTimer()
        let formattedDistance = String(format: "%.2f км", distance)
        let formattedDuration = String(format: "%02d:%02d", elapsedTime / 60, elapsedTime % 60)
        delegate?.didCompleteActivity(distance: formattedDistance, duration: formattedDuration, type: activityType ?? "Неизвестно")
        
        
        let activityData = ActivityData(date: formatDate(Date()), distance: distance, duration: Double(elapsedTime))
        saveActivityData(activityData)
        
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    private func saveActivityData(_ activityData: ActivityData) {
        var activities = loadActivities()
        activities.append(activityData)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(activities) {
            UserDefaults.standard.set(encoded, forKey: "activities")
        }
    }

    private func loadActivities() -> [ActivityData] {
        if let data = UserDefaults.standard.data(forKey: "activities") {
            let decoder = JSONDecoder()
            if let activities = try? decoder.decode([ActivityData].self, from: data) {
                return activities
            }
        }
        return []
    }
    
    @objc private func zoomIn() {
        var region = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func zoomOut() {
        var region = mapView.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isTracking, let newLocation = locations.last else { return }
        if let previousLocation = previousLocation {
            let deltaDistance = previousLocation.distance(from: newLocation) / 1000
            distance += deltaDistance
            routeCoordinates.append(newLocation.coordinate)
            
            userAnnotation.coordinate = newLocation.coordinate
            
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

extension ActivityInProgressViewController {
    private func startSimulation() {
        let simulatedRoute = [
            CLLocationCoordinate2D(latitude: 43.0232, longitude: 131.8915),
            CLLocationCoordinate2D(latitude: 43.0238, longitude: 131.8918),
            CLLocationCoordinate2D(latitude: 43.0242, longitude: 131.8920),
            CLLocationCoordinate2D(latitude: 43.0248, longitude: 131.8923),
            CLLocationCoordinate2D(latitude: 43.0252, longitude: 131.8928),
            CLLocationCoordinate2D(latitude: 43.0255, longitude: 131.8932),
            CLLocationCoordinate2D(latitude: 43.0250, longitude: 131.8938),
            CLLocationCoordinate2D(latitude: 43.0245, longitude: 131.8935),
            CLLocationCoordinate2D(latitude: 43.0240, longitude: 131.8930),
            CLLocationCoordinate2D(latitude: 43.0235, longitude: 131.8925),
            CLLocationCoordinate2D(latitude: 43.0232, longitude: 131.8915)
        ]

        var currentIndex = 0

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.isPaused {
                return
            }
            
            if currentIndex >= simulatedRoute.count {
                timer.invalidate()
                return
            }
            
            let simulatedLocation = CLLocation(
                coordinate: simulatedRoute[currentIndex],
                altitude: 0,
                horizontalAccuracy: 1,
                verticalAccuracy: 1,
                timestamp: Date()
            )
            self.locationManager(self.locationManager, didUpdateLocations: [simulatedLocation])
            
            currentIndex += 1
        }
    }
}
