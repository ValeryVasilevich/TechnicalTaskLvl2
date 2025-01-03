import UIKit
import Combine

fileprivate enum Constants {
    static let headerTitle = "WELCOME TO THE SHIPS INFORMATION PROJECT"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let loginButtonTitle = "Login"
    static let loginGuestButtonTitle = "Login as a guest"
    static let errorAlertTitle = "Error"
    static let errorAlertMessage = "Invalid email or password."

    static let stackViewInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    static let welcomeLabelInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    static let stackViewSpacing: CGFloat = 16.0
}

final class LoginViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: LoginViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.headerTitle
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.emailPlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.loginButtonTitle, for: .normal)
        button.isEnabled = false
        return button
    }()

    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.loginGuestButtonTitle, for: .normal)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .red
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Initialization

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLayout()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupLayout() {
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(guestButton)

        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.welcomeLabelInsets.top),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.welcomeLabelInsets.left),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.welcomeLabelInsets.right),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackViewInsets.left),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackViewInsets.right),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        emailTextField.publisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)

        passwordTextField.publisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        loginButton.publisher
            .sink { [weak self] in self?.handleLogin() }
            .store(in: &cancellables)

        guestButton.publisher
            .sink { [weak self] in self?.viewModel.didLoginSucceeded?() }
            .store(in: &cancellables)

        viewModel.$isLoginButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    private func handleLogin() {
        viewModel.login()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                switch success {
                case true: self?.viewModel.didLoginSucceeded?()
                case false: self?.showErrorAlert()
                }
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert() {
        presentAlert(title: Constants.errorAlertTitle, message: Constants.errorAlertMessage)
    }
}
