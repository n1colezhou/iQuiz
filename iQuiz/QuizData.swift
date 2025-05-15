//
//  QuizData.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/14/25.
//

import Foundation

struct QuizData: Codable {
    let title: String
    let desc: String
    let questions: [QuestionData]
    
    enum CodingKeys: String, CodingKey {
        case title
        case desc
        case questions
    }
}

struct QuestionData: Codable {
    let text: String
    let answer: String
    let answers: [String]
    
    enum CodingKeys: String, CodingKey {
        case text
        case answer
        case answers
    }
}

extension QuizData {
    func toQuiz() -> Quiz {
        // Determine an appropriate icon based on the quiz title
        let iconName = determineIconName(for: title)
        
        // Convert QuestionData to Question objects
        let convertedQuestions = questions.map { questionData -> Question in
            // Find the index of the correct answer in the answers array
            let correctAnswerIndex = questionData.answers.firstIndex(of: questionData.answer) ?? 0
            
            return Question(
                text: questionData.text,
                options: questionData.answers,
                correctAnswerIndex: correctAnswerIndex
            )
        }
        
        return Quiz(
            title: title,
            description: desc,
            iconName: iconName,
            questions: convertedQuestions
        )
    }
    
    private func determineIconName(for title: String) -> String {
        // Simple logic to determine an icon based on the quiz title
        let lowerTitle = title.lowercased()
        
        if lowerTitle.contains("marvel") || lowerTitle.contains("super") || lowerTitle.contains("hero") {
            return "bolt.fill"
        } else if lowerTitle.contains("math") || lowerTitle.contains("calculus") || lowerTitle.contains("algebra") {
            return "function"
        } else if lowerTitle.contains("science") || lowerTitle.contains("physics") || lowerTitle.contains("chemistry") || lowerTitle.contains("biology") {
            return "leaf.fill"
        } else if lowerTitle.contains("history") || lowerTitle.contains("world") {
            return "book.fill"
        } else if lowerTitle.contains("geography") || lowerTitle.contains("countries") {
            return "globe"
        } else if lowerTitle.contains("movie") || lowerTitle.contains("film") || lowerTitle.contains("cinema") {
            return "film"
        } else if lowerTitle.contains("music") || lowerTitle.contains("song") {
            return "music.note"
        } else if lowerTitle.contains("sport") || lowerTitle.contains("football") || lowerTitle.contains("basketball") {
            return "sportscourt"
        } else if lowerTitle.contains("tech") || lowerTitle.contains("computer") || lowerTitle.contains("programming") {
            return "desktopcomputer"
        } else {
            // Default icon if no match
            return "questionmark.circle.fill"
        }
    }
}
