//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/12/25.
//

import UIKit

class QuestionViewController: UIViewController {

    // MARK: - Properties
    private let quiz: Quiz
    private var currentQuestionIndex = 0
    private var selectedAnswerIndex: Int?
    private var userAnswers: [Int?] = []
    
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
    
    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(quiz: Quiz) {
        self.quiz = quiz
        self.userAnswers = Array(repeating: nil, count: quiz.questions.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadQuestion()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(containerView)
        containerView.addSubview(questionLabel)
        containerView.addSubview(optionsStackView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 32),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            optionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            submitButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        title = quiz.title
        navigationItem.hidesBackButton = false
    }
    
    // MARK: - Question Handling
    private func loadQuestion() {
        guard currentQuestionIndex < quiz.questions.count else {
            showResults()
            return
        }
        
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        // Clear existing options
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new options
        for (index, option) in question.options.enumerated() {
            let optionButton = createOptionButton(title: option, index: index)
            optionsStackView.addArrangedSubview(optionButton)
        }
        
        // Update selected answer if user had previously selected one
        if let previousAnswer = userAnswers[currentQuestionIndex] {
            selectOption(at: previousAnswer)
        } else {
            selectedAnswerIndex = nil
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        }
    }
    
    private func createOptionButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.tag = index
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        selectOption(at: sender.tag)
    }
    
    private func selectOption(at index: Int) {
        selectedAnswerIndex = index
        
        // Update UI for all option buttons
        for subview in optionsStackView.arrangedSubviews {
            guard let button = subview as? UIButton else { continue }
            
            if button.tag == index {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .systemGray6
                button.setTitleColor(.label, for: .normal)
            }
        }
        
        // Enable submit button
        submitButton.isEnabled = true
        submitButton.alpha = 1.0
    }
    
    @objc private func submitButtonTapped() {
        guard let selectedAnswerIndex = selectedAnswerIndex else { return }
        
        // Save user's answer
        userAnswers[currentQuestionIndex] = selectedAnswerIndex
        
        // Show the answer screen
        let currentQuestion = quiz.questions[currentQuestionIndex]
        let answerVC = AnswerViewController(
            question: currentQuestion,
            userAnswerIndex: selectedAnswerIndex
        )
        answerVC.delegate = self
        navigationController?.pushViewController(answerVC, animated: true)
    }
    
    private func showResults() {
        // Calculate score
        var correctAnswers = 0
        for (index, answer) in userAnswers.enumerated() {
            if let answer = answer, answer == quiz.questions[index].correctAnswerIndex {
                correctAnswers += 1
            }
        }
        
        let finishedVC = FinishedViewController(
            correctAnswers: correctAnswers,
            totalQuestions: quiz.questions.count,
            quizTitle: quiz.title
        )
        navigationController?.pushViewController(finishedVC, animated: true)
    }
}

// MARK: - AnswerViewControllerDelegate
extension QuestionViewController: AnswerViewControllerDelegate {
    func didTapNext() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < quiz.questions.count {
            loadQuestion()
        } else {
            showResults()
        }
    }
}
