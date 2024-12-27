import UIKit

class RegistrationViewController: UIViewController{
    
    private let genderButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.isSecureTextEntry = isSecure
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return textField
        }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
        
            continueButton.addTarget(self, action: #selector(continueToProfile), for: .touchUpInside)

        }
    
    private func setupUI() {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "minilogo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
        let titleLabel = UILabel()
        titleLabel.text = "Регистрация"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//сколько умного текста, жесть, даже понятно
        let loginTextField = createTextField(placeholder: "Логин")
        let nameTextField = createTextField(placeholder: "Имя или никнейм")
        let passwordTextField = createTextField(placeholder: "Пароль", isSecure: true)
        let confirmPasswordTextField = createTextField(placeholder: "Повторите пароль", isSecure: true)

        let genderLabel = UILabel()
        genderLabel.text = "Пол"
        genderLabel.font = UIFont.systemFont(ofSize: 16)

        genderButton.setTitle("Выберите", for: .normal)
        genderButton.setTitleColor(.systemBlue, for: .normal)
        genderButton.contentHorizontalAlignment = .right
        genderButton.addTarget(self, action: #selector(selectGender), for: .touchUpInside)

        let genderStackView = UIStackView(arrangedSubviews: [genderLabel, genderButton])
        genderStackView.axis = .horizontal
        genderStackView.distribution = .fillProportionally
        genderStackView.spacing = 8
        genderStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let stackView = UIStackView(arrangedSubviews: [
            loginTextField,
            nameTextField,
            passwordTextField,
            confirmPasswordTextField,
            genderStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 10
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Нажимая на кнопку, вы соглашаетесь с политикой конфиденциальности и обработки персональных данных, а также принимаете пользовательское соглашение"
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(continueButton)
        view.addSubview(subtitleLabel)
        view.addSubview(logoImageView)
//верстка :(
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 30),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }


    @objc private func selectGender() {
            let alert = UIAlertController(title: "Выберите пол", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Мужской", style: .default, handler: { _ in
                self.genderButton.setTitle("Мужской", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Женский", style: .default, handler: { _ in
                self.genderButton.setTitle("Женский", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            
            if let popover = alert.popoverPresentationController {
                popover.sourceView = self.genderButton
                popover.sourceRect = self.genderButton.bounds
            }
            
            present(alert, animated: true, completion: nil)
        }
    @objc private func continueToProfile() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.switchToMainTabBar()
            
        }
    }

}
