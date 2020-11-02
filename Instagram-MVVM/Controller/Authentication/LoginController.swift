//
//  File.swift
//  Instagram-MVVM
//
//  Created by Stanley Traub on 10/25/20.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress

        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
//        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        configureTextFieldObservers()
        configureLoginButtonObserver()
    }
    
    //MARK: - Actions
    
    @objc private func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to log user in \(error.localizedDescription)")
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func configureTextFieldObservers() {
        emailTextField.rx.controlEvent(.editingChanged).asObservable()
            .map { self.emailTextField.text ?? ""}
            .filter { !$0.isEmpty}
            .subscribe(onNext: { [weak self] text in
                print(text)
                self?.viewModel.email = text
                self?.updateForm()
            })
            .disposed(by: disposeBag)
        
        
        passwordTextField.rx.controlEvent(.editingChanged).asObservable()
            .map { self.passwordTextField.text ?? "" }
            .filter { !$0.isEmpty }
            .subscribe(onNext: {[ weak self] text in
                print(text)
                self?.viewModel.password = text
                self?.updateForm()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureLoginButtonObserver() {
        loginButton.rx.controlEvent(.touchUpInside).asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let email = self?.emailTextField.text else { return }
                guard let password = self?.passwordTextField.text else { return }
                AuthService.logUserIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Failed to log user in \(error.localizedDescription)")
                        return
                    }

                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
//    @objc func textDidChange(sender: UITextField) {
//        if sender == emailTextField {
//            viewModel.email = sender.text
//        } else {
//            viewModel.password = sender.text
//        }
//
//        updateForm()
//
//    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureNotificationObservers() {
//        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    
}
