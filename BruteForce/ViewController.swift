//
//  ViewController.swift
//  BruteForce
//
//  Created by Aisaule Sibatova on 24.04.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let queue = DispatchQueue(label: "queue", qos: .background)
    
    // MARK: States
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    // MARK: Outlets
    
    lazy var passwordDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = ""
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Enter the password"
        textField.text = ""
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        return textField
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    lazy var passwordGenerateButton: UIButton = {
        let button = UIButton(type: .system)
        button.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.setTitle("Generate password", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        return button
    }()
    
    lazy var changeBackgroundColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change background color", for: .normal)
        button.addTarget(self, action: #selector(backgroundColorChangeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var passwordGenerateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(passwordDisplayLabel)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordGenerateButton)
        stackView.addArrangedSubview(changeBackgroundColorButton)
        stackView.setCustomSpacing(42, after: passwordDisplayLabel)
        stackView.setCustomSpacing(182, after: passwordGenerateButton)
        return stackView
    }()
        
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(passwordGenerateStackView)
    }
    
    private func setupLayout() {
        passwordGenerateStackView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(180)
            make.leading.trailing.equalToSuperview().inset(92)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: Functions
    
    @objc private func backgroundColorChangeButtonTapped() {
        isBlack.toggle()
    }
    
    @objc private func generatePassword() {
        guard let password = passwordTextField.text else {return}
        activityIndicator.startAnimating()
        bruteForce(passwordToUnlock: password)
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        
        queue.async{ [self] in
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                DispatchQueue.main.async {
                    self.passwordDisplayLabel.text = password
                }
            }
            
            DispatchQueue.main.async {
                if password == passwordToUnlock {
                    self.passwordDisplayLabel.text = "Password is \(password) "
                } else {
                    self.passwordDisplayLabel.text = "Password was not hacked)"
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
