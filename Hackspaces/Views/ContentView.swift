//
//  ContentView.swift
//  hackspaces
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import Foundation
import SwiftUI

func makeDirectoryAPICall(completion: @escaping ([(name: String, apiUrl: String)]?) -> Void) {
    // Specify the URL for the API endpoint
    let apiUrl = URL(string: "https://directory.spaceapi.io")!

    // Create a URL request
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "GET"

    // Create a URLSession task
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        // Check for errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        // Check if there is data
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

    // Start the URLSession task
    task.resume()
}

func makeSpaceAPICall(for apiUrl: String, completion: @escaping (SpaceApi?) -> Void) {
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

public func readLocalFile(forName name: String) -> Foundation.Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
        {
            return jsonData
        }
    } catch {
        print(error)
    }
    return nil
}

public func parse(jsonData: Foundation.Data) {
    do {
        let decodedData = try JSONDecoder().decode(SpaceApi.self, from: jsonData)
        //print("Data Api: ", decodedData.data.api)
        //print("url: ", decodedData.url)
        //print("====================")
    } catch {
        print(error)
    }
}

public func loadjson(fromURLString urlString: String, completion: @escaping (Result<Foundation.Data, Error>) -> Void) {
    if let url = URL(string: urlString) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                completion(.success(data))
            }
        }
        urlSession.resume()
    }
}

struct Hackspace: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var apiUrl: String
}

// MARK: - Views

struct HackspaceListView: View {
    var hackspaces: [Hackspace]
    var onSelectHackspace: (Hackspace) -> Void

    var body: some View {
        List(hackspaces) { hackspace in
            HStack {
                Button(action: {
                    self.onSelectHackspace(hackspace)
                }) {
                    Text(hackspace.title)
                }
            }
        }
    }

    init(hackspaces: [Hackspace], onSelectHackspace: @escaping (Hackspace) -> Void) {
        self.hackspaces = hackspaces
        self.onSelectHackspace = onSelectHackspace
    }
}


struct FavoritesView: View {
    let favorites: [Hackspace] = [
        Hackspace(title: "Section77", apiUrl: "https://api.section77.de"),
        // Add more favorite hackspaces as needed
    ]
    
    @State private var selectedHackspace: Hackspace?

    var body: some View {
        VStack {
            if favorites.isEmpty {
                Text("Favorites not found")
            } else {
                HackspaceListView(hackspaces: favorites, onSelectHackspace: { hackspace in
                    self.selectedHackspace = hackspace
                })
            }
        }
    }
}


struct DirectoryView: View {
    @State private var hackspaceArray: [Hackspace] = []
    @State private var selectedHackspace: Hackspace?
    @State private var isRefreshing = false

    var body: some View {
        NavigationView {
            VStack {
                HackspaceListView(hackspaces: hackspaceArray, onSelectHackspace: selectHackspace)
                    .refreshable {
                        directoryAPIWrapper()
                    }
                    .onAppear {
                        // Load initial data
                        directoryAPIWrapper()
                    }
            }
            .navigationTitle("Hackspaces")
            .sheet(item: $selectedHackspace) { hackspace in
                // Show details for selected hackspace
                HackspaceDetailView(hackspace: hackspace)
            }
        }
    }

    func directoryAPIWrapper() {
        makeDirectoryAPICall { [self] result in
            if let keys = result {
                self.hackspaceArray = keys.map { Hackspace(title: $0.name, apiUrl: $0.apiUrl) }
            }
        }
    }

    func selectHackspace(_ hackspace: Hackspace) {
        // Call individual API for the selected hackspace
        self.selectedHackspace = hackspace
        /*
        makeSpaceAPICall(for: hackspace.apiUrl) { apiData in
            // Handle API response for the selected hackspace
            if let apiData = apiData {
                // Update selectedHackspace with details if needed
                
                print("API data for \(hackspace.title): \(apiData)")
            }
        }
         */
    }
}


struct ContentView: View {
    var body: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(0)
            DirectoryView()
                .tabItem {
                    Label("Browse", systemImage: "globe")
                }
                .tag(0)
        } /* .onAppear(perform: {
             if let localData = readLocalFile(forName: "spaceapi") {
                 parse(jsonData: localData)
             }
         }) */
        .padding()
    }
}
                                            
struct HackspaceDetailView: View {
    let hackspace: Hackspace
    @State private var apiResponse: String = "Loading..." // Initial value for API response

    var body: some View {
        VStack {
            Text("Hackspace Detail: \(hackspace.title)")
                .font(.title)
                .padding()

            TextField("API Response", text: $apiResponse)
                .disabled(true) // Make the TextField read-only

            Button("Call API") {
                spaceAPIWrapper()
            }
            .padding()
        }
        .onAppear {
            // Optionally, you can make the API call when the view appears
            // makeAPICall()
        }
    }
    
    func spaceAPIWrapper() {
            makeSpaceAPICall(for: hackspace.apiUrl) { spaceApi in
                if let spaceApi = spaceApi {
                    // Update UI with API response data
                    DispatchQueue.main.async {
                        self.apiResponse = "\(spaceApi)" // Update API response text
                    }
                    print("API data for \(hackspace.title): \(spaceApi)")
                } else {
                    // Handle API call failure
                    self.apiResponse = "Error fetching data"
                }
            }
        }
}
                                             
                        

// MARK: - Previews

#Preview {
    ContentView()
}
