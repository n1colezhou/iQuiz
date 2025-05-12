//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/12/25.
//

import UIKit

protocol AnswerViewControllerDelegate: AnyObject {
    func didTapNext()
}

class AnswerViewController: UIViewController {
    
    // MARK: - Properties
    private let question: Question
    private let userAnswerIndex: Int
    private let isLastQuestion: Bool
    weak var delegate: AnswerViewControllerDelegate?
    
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
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let correctAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(question: Question, userAnswerIndex: Int, isLastQuestion: Bool = false) {
        self.question = question
        self.userAnswerIndex = userAnswerIndex
        self.isLastQuestion = isLastQuestion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayResult()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(containerView)
        containerView.addSubview(questionLabel)
        containerView.addSubview(resultIconImageView)
        containerView.addSubview(resultLabel)
        containerView.addSubview(correctAnswerLabel)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            resultIconImageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            resultIconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            resultIconImageView.widthAnchor.constraint(equalToConstant: 60),
            resultIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            resultLabel.topAnchor.constraint(equalTo: resultIconImageView.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            correctAnswerLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 16),
            correctAnswerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            correctAnswerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            correctAnswerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            nextButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        if isLastQuestion {
            nextButton.setTitle("See Results", for: .normal)
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func displayResult() {
        questionLabel.text = question.text
        
        let isCorrect = userAnswerIndex == question.correctAnswerIndex
        
        if isCorrect {
            resultIconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            resultIconImageView.tintColor = .systemGreen
            resultLabel.text = "Correct!"
            resultLabel.textColor = .systemGreen
        } else {
            resultIconImageView.image = UIImage(systemName: "xmark.circle.fill")
            resultIconImageView.tintColor = .systemRed
            resultLabel.text = "Incorrect"
            resultLabel.textColor = .systemRed
        }
        
        let correctAnswer = question.options[question.correctAnswerIndex]
        correctAnswerLabel.text = "The correct answer is: \(correctAnswer)"
    }
    
    @objc private func nextButtonTapped() {
        delegate?.didTapNext()
        
        if !isLastQuestion {
            navigationController?.popViewController(animated: false)
        }
    }
}
