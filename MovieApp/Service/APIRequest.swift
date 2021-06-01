//
//  APIRequest.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    
    init(fullurl: String) {
        let resourceString = "\(fullurl)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func post (completion: @escaping(Result<Data, APIError>) -> Void) {
        do {
          var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                completion(.success(jsonData))
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }

}
