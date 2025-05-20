//
//  QuizModel.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/5/25.
//

import Foundation

struct Quiz: Codable {
    let title: String
    let description: String
    let iconName: String
    var questions: [Question]
}

struct Question: Codable {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

class QuizDataSource {
    static let shared = QuizDataSource()
    
    private let storageFile = "quizzes.json"
    
    var quizzes: [Quiz] = []
    
    init() {
        loadQuizzes()
    }
    
    // MARK: - Storage Methods
    
    private func loadQuizzes() {
        // First try to load from documents directory
        if let loadedQuizzes = loadQuizzesFromFile() {
            quizzes = loadedQuizzes
            return
        }
        
        // If no file exists, load default quizzes
        quizzes = [
            Quiz(
                title: "Mathematics",
                description: "Test your math knowledge with these questions",
                iconName: "function",
                questions: [
                    Question(
                        text: "Easy: What is 5 + 3?",
                        options: ["6", "7", "8", "9"],
                        correctAnswerIndex: 2
                    ),
                    // ... rest of your default quizzes
                ]
            ),
            // ... other default quizzes
        ]
    }
    
    func updateQuizzes(_ newQuizzes: [Quiz]) {
        quizzes = newQuizzes
        saveQuizzesToFile()
    }
    
    private func saveQuizzesToFile() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(storageFile)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(quizzes)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving quizzes: \(error)")
        }
    }
    
    private func loadQuizzesFromFile() -> [Quiz]? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(storageFile)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let quizzes = try decoder.decode([Quiz].self, from: data)
            return quizzes
        } catch {
            print("Error loading quizzes: \(error)")
            return nil
        }
    }
}
