import UIKit

class ProfileViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
                titleLabel.text = "Профиль"
                titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                titleLabel.textAlignment = .center
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                
                
                let profileImageView = UIImageView()
                profileImageView.image = UIImage(named: "placeholder-avatar") // Добавьте заглушку для аватара
                profileImageView.contentMode = .scaleAspectFit
                profileImageView.layer.cornerRadius = 50
                profileImageView.clipsToBounds = true
                profileImageView.translatesAutoresizingMaskIntoConstraints = false
                
                
                let nameLabel = UILabel()
                nameLabel.text = "Имя пользователя"
                nameLabel.font = UIFont.systemFont(ofSize: 18)
                nameLabel.textAlignment = .center
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                

                
                
                view.addSubview(titleLabel)
                view.addSubview(profileImageView)
                view.addSubview(nameLabel)

                
                
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
                    profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                    profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    profileImageView.widthAnchor.constraint(equalToConstant: 100),
                    profileImageView.heightAnchor.constraint(equalToConstant: 100),
                    
                    nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
                    nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
    }
}
