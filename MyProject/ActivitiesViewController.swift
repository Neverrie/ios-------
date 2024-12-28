import UIKit


extension ActivitiesViewController : ActivitySelectionDelegate {
    func didStartActivity(type: String) {
        let activityInProgressVC = ActivityInProgressViewController()
        activityInProgressVC.activityType = type
        activityInProgressVC.delegate = self
        navigationController?.pushViewController(activityInProgressVC, animated: true)
    }
}

extension ActivitiesViewController : ActivityCompletionDelegate {
    func didFinishActivity(distance : String, duration: String, type: String) {
        let actibityString = "\(type) - \(distance) | \(duration)"
        activities.insert(actibityString, at: 0)
        updateUI()
    }
}

extension ActivitiesViewController: ActivityInProgressDelegate {
    func didCompleteActivity(distance: String, duration: String, type: String) {
        let activityString = "\(type) - \(distance) | \(duration)"
        activities.insert(activityString, at: 0)
        updateUI()
    }
}


class ActivitiesViewController: UIViewController {
    
    
    private var activities: [String] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Активности"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Время потренить\nНажимай на кнопку ниже и начинаем\nтрекать активность"
        label.isHidden = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        return tableView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Старт", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        updateUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        guard emptyStateLabel.superview == nil else {
            print("Ошибка: emptyStateLabel уже добавлен в иерархию view")
            return
        }
        print("Добавляем emptyStateLabel в иерархию")
        view.addSubview(emptyStateLabel)
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -10),
            
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
    }
    
    private func updateUI() {
        if activities.isEmpty {
            emptyStateLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    
}


extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        cell.textLabel?.text = activities[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .white
        detailVC.title = "Детали активности"
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func startTracking() {
        let activitySelectionVC = ActivityInProgressViewController()
        activitySelectionVC.delegate = self
        navigationController?.pushViewController(activitySelectionVC, animated: true)
        
    }
    
    
}


