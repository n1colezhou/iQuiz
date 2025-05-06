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
}

class QuizDataSource {
    static let shared = QuizDataSource()
    
    var quizzes: [Quiz] = [
        Quiz(title: "Mathematics",
             description: "Test your math knowledge with these questions",
             iconName: "function"),
        Quiz(title: "Marvel Super Heroes",
             description: "How well do you know Marvel superheroes?",
             iconName: "bolt.fill"),
        Quiz(title: "Science",
             description: "Challenge yourself with science questions",
             iconName: "leaf.fill")
    ]
}
