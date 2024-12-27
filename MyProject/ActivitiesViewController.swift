import UIKit



class ActivitiesViewController: UIViewController{
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Активности"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Старт", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18 , weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 120),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
    }
    
    @objc private func startTracking() {
        let activityInProgressVC = ActivityInProgressViewController()
        activityInProgressVC.activityType = "Велосипед"
        navigationController?.pushViewController(activityInProgressVC, animated: true)
    }
}
