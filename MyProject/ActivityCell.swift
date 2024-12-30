import UIKit

class ActivityCell: UITableViewCell {
    
    static let identifier = "ActivityCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(distanceLabel)
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(durationLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(timeAgoLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            distanceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            distanceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            nicknameLabel.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            durationLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            typeLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            timeAgoLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 16),
            timeAgoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with activity: Activity, showNickname: Bool = false, nickname: String? = nil) {
        distanceLabel.text = activity.distance
        durationLabel.text = formatDuration(activity.duration)
        typeLabel.text = activity.type
        timeAgoLabel.text = formatTimeAgo(activity.date)
        
        nicknameLabel.isHidden = !showNickname
        nicknameLabel.text = nickname
    }
    
    private func formatDuration(_ duration: String) -> String {
        let components = duration.components(separatedBy: ":")
        guard components.count == 3 else { return duration }
        
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[1]) ?? 0
        
        if hours > 0 {
            return "\(hours) час \(minutes) минут"
        } else {
            return "\(minutes) минут"
        }
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
}
