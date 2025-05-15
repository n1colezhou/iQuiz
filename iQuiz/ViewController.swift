//
//  ViewController.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/5/25, updated 5/14/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: QuizTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private var quizzes: [Quiz] {
        return QuizDataSource.shared.quizzes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        setupRefreshControl()
        checkForNetworkDataOnStartup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        // Reload table view to reflect any potential changes
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        title = "iQuiz"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
        
        navigationItem.rightBarButtonItem = settingsButton
        
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func checkForNetworkDataOnStartup() {
        // Only attempt to fetch if network is available
        if NetworkManager.shared.isNetworkAvailable {
            fetchQuizData()
        }
    }
    
    @objc private func refreshData() {
        if NetworkManager.shared.isNetworkAvailable {
            fetchQuizData()
        } else {
            refreshControl.endRefreshing()
            showNetworkAlert()
        }
    }
    
    private func fetchQuizData() {
        NetworkManager.shared.fetchQuizData(from: SettingsManager.shared.dataSourceURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                
                switch result {
                case .success(let quizData):
                    // Convert the fetched data to Quiz objects
                    let quizzes = quizData.map { $0.toQuiz() }
                    
                    // Update the QuizDataSource
                    QuizDataSource.shared.quizzes = quizzes
                    
                    // Reload table view
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    if case NetworkError.noConnection = error {
                        self?.showNetworkAlert()
                    } else {
                        self?.showAlert(title: "Error", message: "Could not fetch quiz data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // MARK: - Alert Helpers
    private func showNetworkAlert() {
        showAlert(title: "No Internet Connection", message: "Using stored quiz data. Connect to the internet and pull to refresh or use the Check Now button in Settings to update.")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.identifier, for: indexPath) as? QuizTableViewCell else {
            return UITableViewCell()
        }
        
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        
        let questionVC = QuestionViewController(quiz: selectedQuiz)
        navigationController?.pushViewController(questionVC, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate
extension ViewController: SettingsViewControllerDelegate {
    func didUpdateQuizzes() {
        tableView.reloadData()
    }
}
