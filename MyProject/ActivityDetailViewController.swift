import UIKit

class ActivityDetailViewController: UIViewController {
    
    var activity: Activity?
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Добавить комментарий"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        configureWithActivity()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = activity?.type
    }
    
    private func setupUI() {
        view.addSubview(distanceLabel)
        view.addSubview(timeRangeLabel)
        view.addSubview(typeLabel)
        view.addSubview(timeAgoLabel)
        view.addSubview(commentTextField)
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            timeRangeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            timeRangeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            typeLabel.topAnchor.constraint(equalTo: timeRangeLabel.bottomAnchor, constant: 32),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            timeAgoLabel.topAnchor.constraint(equalTo: timeRangeLabel.bottomAnchor, constant: 32),
            timeAgoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            commentTextField.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 32),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureWithActivity() {
        guard let activity = activity else { return }
        
        distanceLabel.text = activity.distance
        timeRangeLabel.text = formatTimeRange(activity.startTime, endTime: activity.endTime)
        typeLabel.text = activity.type
        timeAgoLabel.text = formatTimeAgo(activity.endTime)
    }
    
    private func formatTimeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) год назад"
        } else if let month = components.month, month > 0 {
            return "\(month) месяц назад"
        } else if let day = components.day, day > 0 {
            return "\(day) день назад"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) час назад"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) минут назад"
        } else {
            return "Только что"
        }
    }
    
    private func formatTimeRange(_ startTime: Date, endTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)
        
        return "Старт: \(startTimeString) - Финиш: \(endTimeString)"
    }
}
