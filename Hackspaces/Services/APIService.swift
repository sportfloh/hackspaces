//
//  APIService.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//

import Foundation

import Foundation
import UIKit

struct APIService {
    static func makeDirectoryAPICall(completion: @escaping ([(name: String, apiUrl: String)]?) -> Void) {
        let apiUrl = URL(string: "https://directory.spaceapi.io")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let result = try JSONDecoder().decode([String: String].self, from: data)
                let hackspaceUrls = result.map { (name: $0.key, apiUrl: $0.value) }.sorted { $0.name < $1.name }
                completion(hackspaceUrls)
                print("API has been called")
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }

        task.resume()
    }

    static func makeSpaceAPICall(for apiUrl: String, completion: @escaping (SpaceApi?) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let spaceApi = try JSONDecoder().decode(SpaceApi.self, from: data)
                completion(spaceApi)
                print(data)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

    static func getHackSpaceLogo(from logoURL: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: logoURL) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            completion(.success(image))
        }.resume()
    }
}

