import UIKit
import DGCharts

class ProfileViewController: UIViewController {
    
    private let loginLabel = UILabel()
    private let nameLabel = UILabel()
    private let passwordLabel = UILabel()
    private let genderLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let activityChartView = LineChartView()
    private let distanceLabel = UILabel() // Для отображения "Дистанция" и километража
    private let chartContainerView = UIView() // Контейнер для графика
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Профиль"
        
        setupUI()
        setupChart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем график каждый раз, когда экран появляется
        setupChart()
    }

    private func loadUserData() -> User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser") {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: userData) {
                return user
            }
        }
        return nil
    }
    
    private func setupUI() {
        guard let user = loadUserData() else {
            print("Пользователь не найден")
            return
        }
        
        let userInfoContainer = createRoundedContainer()
        let loginContainer = createInfoLabel(title: "Логин", value: user.login)
        let nameContainer = createInfoLabel(title: "Имя или никнейм", value: user.name)
        let passwordContainer = createInfoLabel(title: "Пароль", value: "********")
        let genderContainer = createInfoLabel(title: "Пол", value: user.gender)
        
        let userInfoStackView = UIStackView(arrangedSubviews: [
            loginContainer,
            nameContainer,
            passwordContainer,
            genderContainer
        ])
        userInfoStackView.axis = .vertical
        userInfoStackView.spacing = 10
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        userInfoContainer.addSubview(userInfoStackView)
        
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        let activityTitleLabel = UILabel()
        activityTitleLabel.text = "Активности"
        activityTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        activityTitleLabel.textAlignment = .center
        activityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка distanceLabel
        distanceLabel.text = "Дистанция: 0.00 км"
        distanceLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        distanceLabel.textAlignment = .center
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка контейнера для графика
        chartContainerView.backgroundColor = .white
        chartContainerView.layer.cornerRadius = 12
        chartContainerView.layer.shadowColor = UIColor.black.cgColor
        chartContainerView.layer.shadowOpacity = 0.1
        chartContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chartContainerView.layer.shadowRadius = 4
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        chartContainerView.addSubview(activityChartView)
        
        view.addSubview(userInfoContainer)
        view.addSubview(activityTitleLabel)
        view.addSubview(distanceLabel)
        view.addSubview(chartContainerView)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            userInfoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userInfoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userInfoStackView.topAnchor.constraint(equalTo: userInfoContainer.topAnchor, constant: 16),
            userInfoStackView.leadingAnchor.constraint(equalTo: userInfoContainer.leadingAnchor, constant: 16),
            userInfoStackView.trailingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: -16),
            userInfoStackView.bottomAnchor.constraint(equalTo: userInfoContainer.bottomAnchor, constant: -16),
            
            activityTitleLabel.topAnchor.constraint(equalTo: userInfoContainer.bottomAnchor, constant: 20),
            activityTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем по горизонтали
            
            distanceLabel.topAnchor.constraint(equalTo: activityTitleLabel.bottomAnchor, constant: 10),
            distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            distanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            chartContainerView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20), // Сдвигаем график ниже
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartContainerView.heightAnchor.constraint(equalToConstant: 220), // Увеличиваем высоту контейнера
            
            activityChartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: 10),
            activityChartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: 10),
            activityChartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -10),
            activityChartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -10),
            
            logoutButton.topAnchor.constraint(greaterThanOrEqualTo: chartContainerView.bottomAnchor, constant: 20),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createRoundedContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    private func createInfoLabel(title: String, value: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .gray
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueLabel.textColor = .black
        valueLabel.textAlignment = .right
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return stackView
    }
    
    @objc private func logout() {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in
            UserDefaults.standard.removeObject(forKey: "currentUser")
            let mainVC = MainViewController()
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: mainVC)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func groupActivitiesByDate(_ activities: [ActivityData]) -> [ActivityData] {
        var groupedActivities: [String: ActivityData] = [:]
        
        for activity in activities {
            let dateString = activity.date
            
            if let existingActivity = groupedActivities[dateString] {
                let totalDistance = existingActivity.distance + activity.distance
                groupedActivities[dateString] = ActivityData(date: dateString, distance: totalDistance, duration: existingActivity.duration + activity.duration)
            } else {
                groupedActivities[dateString] = activity
            }
        }
        
        return Array(groupedActivities.values)
    }

    private func setupChart() {
        activityChartView.translatesAutoresizingMaskIntoConstraints = false
        activityChartView.noDataText = "Нет данных для отображения"
        activityChartView.clear()

        // Убираем легенду (синий квадратик)
        activityChartView.legend.enabled = false

        let activities = loadActivities()
        
        // Фильтруем последние 6 дней
        let lastSixDaysActivities = filterLastSixDaysActivities(activities)
        
        let groupedActivities = groupActivitiesByDate(lastSixDaysActivities)

        let entries = groupedActivities.enumerated().map { (index, activity) in
            ChartDataEntry(x: Double(index), y: activity.distance)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "") // Убираем надпись "Дистанция (км)"
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.circleColors = [NSUIColor.systemBlue]
        dataSet.circleRadius = 5
        dataSet.lineWidth = 2
        dataSet.valueColors = [NSUIColor.black]
        dataSet.valueFont = NSUIFont.boldSystemFont(ofSize: 12)

        let data = LineChartData(dataSet: dataSet)
        activityChartView.data = data

        activityChartView.xAxis.labelPosition = .bottom
        activityChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: groupedActivities.map { $0.date })
        activityChartView.xAxis.granularity = 1
        activityChartView.xAxis.labelFont = NSUIFont.systemFont(ofSize: 10)
        activityChartView.xAxis.labelTextColor = NSUIColor.gray

        activityChartView.leftAxis.axisMinimum = 0
        activityChartView.rightAxis.enabled = false

        // Добавляем обработчик нажатия на точки графика
        activityChartView.delegate = self

        activityChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
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

    private func filterLastSixDaysActivities(_ activities: [ActivityData]) -> [ActivityData] {
        // Сортируем активности по дате в порядке убывания
        let sortedActivities = activities.sorted { $0.date > $1.date }
        
        // Берем первые 6 активностей (последние 6 дней)
        let lastSixDaysActivities = Array(sortedActivities.prefix(6))
        
        return lastSixDaysActivities
    }
}

extension ProfileViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // Получаем индекс выбранной точки
        let index = Int(entry.x)
        
        // Получаем данные о активностях
        let activities = loadActivities()
        let groupedActivities = groupActivitiesByDate(activities)
        
        // Обновляем текст distanceLabel
        if index < groupedActivities.count {
            let activity = groupedActivities[index]
            // Форматируем значение до двух знаков после запятой
            let formattedDistance = String(format: "%.2f", activity.distance)
            distanceLabel.text = "Дистанция: \(formattedDistance) км"
        }
    }
}
