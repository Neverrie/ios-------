import UIKit
//ctrl c с регистрации, найс upd ладно нет
class LoginViewController: UIViewController {
    
    private let continueButton = UIButton(type: .system)
    private let loginTextField = UITextField()
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        continueButton.addTarget(self, action: #selector(continueToProfile), for: .touchUpInside)
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Войти"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginTextField.placeholder = "Логин"
        loginTextField.borderStyle = .roundedRect
        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let passwordTextField = createTextField(placeholder: "Пароль", isSecure: true)
        
        let stackView = UIStackView(arrangedSubviews: [
            loginTextField,
            passwordTextField,
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
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "minilogo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(continueButton)
        view.addSubview(imageView)
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            
            logoImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func continueToProfile() {
        guard let login = loginTextField.text, !login.isEmpty else {

            let alert = UIAlertController(title: "Ошибка", message: "Введите логин", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        

        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            
            if user.login == login {
            
                if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.switchToMainTabBar()
                }
            } else {
                
                let alert = UIAlertController(title: "Ошибка", message: "Пользователь с таким логином не найден", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            
            let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
