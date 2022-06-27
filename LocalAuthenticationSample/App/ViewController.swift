//
//  ViewController.swift
//  LocalAuthenticationSample
//
//  Created by Arsenii Kovalenko on 27.06.2022.
//

import UIKit

class ViewController: UIViewController {

    private lazy var authenticationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticate", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        setUpAutoLayoutConstraints()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = .yellow
        view.addSubview(authenticationButton)
    }
    
    private func setUpAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            authenticationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authenticationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authenticationButton.heightAnchor.constraint(equalToConstant: 44),
            authenticationButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc private func buttonTapped() {
        let service: LocalAuthenticationServiceContext = LocalAuthenticationService(with: Model())
        service.requestAuthentication(.allWays, reason: "We need it to log in") { result in
            switch result {
            case .success:
                print("Success")
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct Model: AuthenticationModelProvider {}
