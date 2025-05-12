//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/12/25.
//

import UIKit

class FinishedViewController: UIViewController {

    // MARK: - Properties
    private let correctAnswers: Int
    private let totalQuestions: Int
    private let quizTitle: String
    
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
    
    private let trophyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trophy.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Topics", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(correctAnswers: Int, totalQuestions: Int, quizTitle: String) {
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
        self.quizTitle = quizTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(containerView)
        containerView.addSubview(trophyImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(messageLabel)
        view.addSubview(finishButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            trophyImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            trophyImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trophyImageView.widthAnchor.constraint(equalToConstant: 80),
            trophyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: trophyImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            
            finishButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            finishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    private func displayResults() {
        let percentage = Double(correctAnswers) / Double(totalQuestions) * 100
        
        scoreLabel.text = "\(correctAnswers) out of \(totalQuestions) correct"
        
        if percentage == 100 {
            titleLabel.text = "Perfect!"
            messageLabel.text = "Congratulations! You got all questions correct in the \(quizTitle) quiz."
            trophyImageView.tintColor = .systemYellow
        } else if percentage >= 80 {
            titleLabel.text = "Great Job!"
            messageLabel.text = "You did very well in the \(quizTitle) quiz. Keep it up!"
            trophyImageView.tintColor = .systemGreen
        } else if percentage >= 60 {
            titleLabel.text = "Good Effort!"
            messageLabel.text = "You did well in the \(quizTitle) quiz, but there's room for improvement."
            trophyImageView.image = UIImage(systemName: "medal.fill")
            trophyImageView.tintColor = .systemBlue
        } else {
            titleLabel.text = "Try Again!"
            messageLabel.text = "You might want to review the \(quizTitle) material and try again."
            trophyImageView.image = UIImage(systemName: "book.fill")
            trophyImageView.tintColor = .systemOrange
        }
    }
    
    @objc private func finishButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
