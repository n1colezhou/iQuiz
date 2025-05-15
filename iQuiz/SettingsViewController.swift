//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/14/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateQuizzes()
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Data Source URL"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter URL"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .URL
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let checkNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Now", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset to Default", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(urlTextField)
        containerView.addSubview(checkNowButton)
        containerView.addSubview(resetButton)
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            urlTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            urlTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            checkNowButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 24),
            checkNowButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            checkNowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            checkNowButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: checkNowButton.bottomAnchor, constant: 12),
            resetButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            activityIndicator.centerYAnchor.constraint(equalTo: checkNowButton.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: checkNowButton.trailingAnchor, constant: -16)
        ])
        
        checkNowButton.addTarget(self, action: #selector(checkNowButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // Add done button to keyboard
        urlTextField.returnKeyType = .done
        urlTextField.delegate = self
    }
    
    private func loadSettings() {
        urlTextField.text = SettingsManager.shared.dataSourceURL
    }
    
    // MARK: - Actions
    @objc private func checkNowButtonTapped() {
        // Save the current URL text
        if let urlText = urlTextField.text, !urlText.isEmpty {
            SettingsManager.shared.dataSourceURL = urlText
        }
        
        // Start loading indicator
        activityIndicator.startAnimating()
        checkNowButton.setTitle("", for: .normal)
        
        // Check network connectivity first
        if !NetworkManager.shared.isNetworkAvailable {
            showNetworkAlert()
            resetCheckNowButton()
            return
        }
        
        // Fetch data from URL
        NetworkManager.shared.fetchQuizData(from: SettingsManager.shared.dataSourceURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.resetCheckNowButton()
                
                switch result {
                case .success(let quizData):
                    // Convert the fetched data to Quiz objects
                    let quizzes = quizData.map { $0.toQuiz() }
                    
                    // Update the QuizDataSource
                    QuizDataSource.shared.quizzes = quizzes
                    
                    // Notify delegate
                    self?.delegate?.didUpdateQuizzes()
                    
                    // Show success message
                    self?.showAlert(title: "Success", message: "Quiz data updated successfully!")
                    
                case .failure(let error):
                    // Show error message
                    let errorMessage: String
                    
                    switch error {
                    case NetworkError.noConnection:
                        errorMessage = "No internet connection."
                    case NetworkError.invalidURL:
                        errorMessage = "Invalid URL provided."
                    case NetworkError.invalidResponse:
                        errorMessage = "Invalid response from server."
                    case NetworkError.noData:
                        errorMessage = "No data received from server."
                    case NetworkError.decodingError:
                        errorMessage = "Could not parse the data from server."
                    default:
                        errorMessage = "An error occurred: \(error.localizedDescription)"
                    }
                    
                    self?.showAlert(title: "Error", message: errorMessage)
                }
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        SettingsManager.shared.resetToDefaultURL()
        urlTextField.text = SettingsManager.shared.dataSourceURL
    }
    
    private func resetCheckNowButton() {
        activityIndicator.stopAnimating()
        checkNowButton.setTitle("Check Now", for: .normal)
    }
    
    // MARK: - Alert Helpers
    private func showNetworkAlert() {
        showAlert(title: "No Internet Connection", message: "Please check your internet connection and try again.")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let urlText = textField.text, !urlText.isEmpty {
            SettingsManager.shared.dataSourceURL = urlText
        }
    }
}
