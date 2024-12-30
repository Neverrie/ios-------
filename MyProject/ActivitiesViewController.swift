import UIKit

struct Activity {
    let type: String
    let distance: String
    let duration: String
    let date: Date
    let startTime: Date
    let endTime: Date
}

private var groupedActivities: [String: [Activity]] = [:]
private var groupedCommunityActivities: [String: [Activity]] = [:]

class ActivitiesViewController: UIViewController {
    
    private var activities: [Activity] = []
    private var communityActivities: [Activity] = [
        Activity(type: "Велосипед", distance: "5.32 км", duration: "1 часа 6 минут", date: Date(), startTime: Date(), endTime: Date()),
        Activity(type: "Велосипед", distance: "5.32 км", duration: "1 часа 6 минут", date: Date(), startTime: Date(), endTime: Date()),
        Activity(type: "Велосипед", distance: "10.99 км", duration: "2 часа 22 минуты", date: Date(), startTime: Date(), endTime: Date())
    ]
    
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
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.identifier)
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
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Мои активности", "Активности сообщества"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.identifier)
        setupUI()
        setupActions()
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(emptyStateLabel)
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
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
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    private func updateUI() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if activities.isEmpty {
                emptyStateLabel.text = "Время потренить\nНажимай на кнопку ниже и начинаем\nтрекать активность"
                emptyStateLabel.isHidden = false
                tableView.isHidden = true
            } else {
                emptyStateLabel.isHidden = true
                tableView.isHidden = false
                groupActivities()
                tableView.reloadData()
            }
        } else {
            if communityActivities.isEmpty {
                emptyStateLabel.text = "Активности сообщества\nЗдесь будут отображаться активности ваших сообществ"
                emptyStateLabel.isHidden = false
                tableView.isHidden = true
            } else {
                emptyStateLabel.isHidden = true
                tableView.isHidden = false
                groupCommunityActivities()
                tableView.reloadData()
            }
        }
    }
    
    private func groupActivities() {
        groupedActivities.removeAll()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        for activity in activities {
            let date = activity.date
            
            if calendar.isDateInToday(date) {
                groupedActivities["Сегодня", default: []].append(activity)
            } else if calendar.isDateInYesterday(date) {
                groupedActivities["Вчера", default: []].append(activity)
            } else {
                dateFormatter.dateFormat = "d MMMM yyyy"
                let dateString = dateFormatter.string(from: date)
                groupedActivities[dateString, default: []].append(activity)
            }
        }
        
        for (key, activities) in groupedActivities {
            groupedActivities[key] = activities.sorted(by: { $0.date > $1.date })
        }
    }
    
    private func groupCommunityActivities() {
        groupedCommunityActivities.removeAll()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        for activity in communityActivities {
            let date = activity.date
            
            if calendar.isDateInToday(date) {
                groupedCommunityActivities["Сегодня", default: []].append(activity)
            } else if calendar.isDateInYesterday(date) {
                groupedCommunityActivities["Вчера", default: []].append(activity)
            } else {
                dateFormatter.dateFormat = "d MMMM yyyy"
                let dateString = dateFormatter.string(from: date)
                groupedCommunityActivities[dateString, default: []].append(activity)
            }
        }
        
        for (key, activities) in groupedCommunityActivities {
            groupedCommunityActivities[key] = activities.sorted(by: { $0.date > $1.date })
        }
    }
    
    @objc private func startTracking() {
        let activitySelectionVC = ActivityInProgressViewController()
        activitySelectionVC.delegate = self
        navigationController?.pushViewController(activitySelectionVC, animated: true)
    }
}

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return groupedActivities.keys.count
        } else {
            return groupedCommunityActivities.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let sortedKeys = Array(groupedActivities.keys).sorted(by: { $0 > $1 })
            return sortedKeys[section]
        } else {
            let sortedKeys = Array(groupedCommunityActivities.keys).sorted(by: { $0 > $1 })
            return sortedKeys[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            let sortedKeys = Array(groupedActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[section]
            return groupedActivities[key]?.count ?? 0
        } else {
            let sortedKeys = Array(groupedCommunityActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[section]
            return groupedCommunityActivities[key]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.identifier, for: indexPath) as? ActivityCell else {
            return UITableViewCell()
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let sortedKeys = Array(groupedActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[indexPath.section]
            if let activity = groupedActivities[key]?[indexPath.row] {
                cell.configure(with: activity, showNickname: false)
            }
        } else {
            
            let sortedKeys = Array(groupedCommunityActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[indexPath.section]
            if let activity = groupedCommunityActivities[key]?[indexPath.row] {
                let nickname = "@van_darkholme"
                cell.configure(with: activity, showNickname: true, nickname: nickname)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let sortedKeys = Array(groupedActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[indexPath.section]
            if let activity = groupedActivities[key]?[indexPath.row] {
                let detailVC = ActivityDetailViewController()
                detailVC.activity = activity
                navigationController?.pushViewController(detailVC, animated: true)
            }
        } else {
            let sortedKeys = Array(groupedCommunityActivities.keys).sorted(by: { $0 > $1 })
            let key = sortedKeys[indexPath.section]
            if let activity = groupedCommunityActivities[key]?[indexPath.row] {
                let detailVC = ActivityDetailViewController()
                detailVC.activity = activity
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension ActivitiesViewController: ActivitySelectionDelegate {
    func didStartActivity(type: String) {
        let activityInProgressVC = ActivityInProgressViewController()
        activityInProgressVC.activityType = type
        activityInProgressVC.delegate = self
        navigationController?.pushViewController(activityInProgressVC, animated: true)
    }
}

extension ActivitiesViewController: ActivityCompletionDelegate {
    func didFinishActivity(distance: String, duration: String, type: String) {
        let startTime = Date()
        let endTime = Date()
        let activity = Activity(type: type, distance: distance, duration: duration, date: endTime, startTime: startTime, endTime: endTime)
        activities.insert(activity, at: 0)
        updateUI()
    }
}

extension ActivitiesViewController: ActivityInProgressDelegate {
    func didCompleteActivity(distance: String, duration: String, type: String) {
        let startTime = Date()
        let endTime = Date()
        let activity = Activity(type: type, distance: distance, duration: duration, date: endTime, startTime: startTime, endTime: endTime)
        activities.insert(activity, at: 0)
        updateUI()
    }
}
