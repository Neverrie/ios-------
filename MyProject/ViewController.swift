//
//  ViewController.swift
//  MyProject
//
//  Created by Константин Коробов on 24.12.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "logo")
    }

    @IBAction func Registration(_ sender: Any) {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
}

