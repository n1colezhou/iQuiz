//
//  NetworkManager.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/14/25.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isNetworkAvailable = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func fetchQuizData(from urlString: String, completion: @escaping (Result<[QuizData], Error>) -> Void) {
        guard isNetworkAvailable else {
            completion(.failure(NetworkError.noConnection))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let quizzes = try JSONDecoder().decode([QuizData].self, from: data)
                completion(.success(quizzes))
            } catch {
                print("JSON Decoding Error: \(error)")
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case noConnection
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}
