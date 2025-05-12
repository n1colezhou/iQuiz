//
//  QuizModel.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/5/25.
//

import Foundation

struct Quiz {
    let title: String
    let description: String
    let iconName: String
    var questions: [Question]
}

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

class QuizDataSource {
    static let shared = QuizDataSource()
    
    var quizzes: [Quiz] = [
        Quiz(
            title: "Mathematics",
            description: "Test your math knowledge with these questions",
            iconName: "function",
            questions: [
                Question(
                    text: "What is 2 + 2?",
                    options: ["3", "4", "5", "6"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is the square root of 16?",
                    options: ["2", "4", "6", "8"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is 3 × 5?",
                    options: ["8", "12", "15", "18"],
                    correctAnswerIndex: 2
                )
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            description: "How well do you know Marvel superheroes?",
            iconName: "bolt.fill",
            questions: [
                Question(
                    text: "What is Iron Man's real name?",
                    options: ["Tony Stark", "Steve Rogers", "Bruce Banner", "Peter Parker"],
                    correctAnswerIndex: 0
                ),
                Question(
                    text: "Who is known as the God of Thunder?",
                    options: ["Loki", "Odin", "Thor", "Heimdall"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "What metal is Captain America's shield made of?",
                    options: ["Steel", "Adamantium", "Titanium", "Vibranium"],
                    correctAnswerIndex: 3
                )
            ]
        ),
        Quiz(
            title: "Science",
            description: "Challenge yourself with science questions",
            iconName: "leaf.fill",
            questions: [
                Question(
                    text: "What is the chemical symbol for water?",
                    options: ["H2O", "CO2", "NaCl", "O2"],
                    correctAnswerIndex: 0
                ),
                Question(
                    text: "What is the closest planet to the Sun?",
                    options: ["Earth", "Venus", "Mercury", "Mars"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "Which of these is NOT a primary color?",
                    options: ["Red", "Blue", "Green", "Yellow"],
                    correctAnswerIndex: 3
                )
            ]
        )
    ]
}
