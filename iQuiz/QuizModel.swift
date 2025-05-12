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
                    text: "Easy: What is 5 + 3?",
                    options: ["6", "7", "8", "9"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "Medium: What is 12 ÷ 4 × 2?",
                    options: ["6", "8", "4", "3"],
                    correctAnswerIndex: 0
                ),
                Question(
                    text: "Hard: What is the value of x in the equation 2x + 3 = 11?",
                    options: ["3", "4", "5", "6"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            description: "How well do you know Marvel superheroes?",
            iconName: "bolt.fill",
            questions: [
                Question(
                    text: "Easy: Which superhero wears a red and blue spider suit?",
                    options: ["Iron Man", "Hulk", "Spider-man", "Captain America"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "Medium: What is Black Panther's home country?",
                    options: ["Zamunda", "Genosha", "Sokovia", "Wakanda"],
                    correctAnswerIndex: 3
                ),
                Question(
                    text: "Hard: Which Infinity Stone did Vision have in his forehead?",
                    options: ["Power", "Mind", "Reality", "Time"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        Quiz(
            title: "Science",
            description: "Challenge yourself with science questions",
            iconName: "leaf.fill",
            questions: [
                Question(
                    text: "Easy: What is the chemical symbol for water?",
                    options: ["H2O", "CO2", "NaCl", "O2"],
                    correctAnswerIndex: 0
                ),
                Question(
                    text: "Medium: What is the closest planet to the Sun?",
                    options: ["Earth", "Venus", "Mercury", "Mars"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "Hard: What particle has a negative electric charge?",
                    options: ["Proton", "Neutron", "Electron", "Photon"],
                    correctAnswerIndex: 2
                )
            ]
        )
    ]
}
