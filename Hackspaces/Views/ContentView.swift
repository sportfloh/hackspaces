//
//  ContentView.swift
//  hackspaces
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import SwiftUI
import Foundation

func makeAPICall() {
    // Specify the URL for the API endpoint
    let apiUrl = URL(string: "https://directory.spaceapi.io")!

    // Create a URL request
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "GET"

    // Create a URLSession task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            // Parse the data using JSONDecoder (replace YourModel.self with your actual data model)
            let result = try JSONDecoder().decode(DirectoryApi.self, from: data)
            // Now you can use the 'result' variable to access the data from the API call
            print("API Result: \(result)")

            // You can store 'result' in a variable, pass it to another function, or do whatever you need
            // For example, if you have a variable named 'myVariable', you can assign 'result' to it
            // myVariable = result
        } catch let jsonError {
            print("Error decoding JSON: \(jsonError)")
        }
    }

    // Start the URLSession task
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
        print("Data Api: ", decodedData.data.api)
        print("url: ", decodedData.url)
        print("====================")
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
    var image: String
    var title: String
}


// MARK: - Views

struct HackspaceListView: View {
    var hackspaces: [Hackspace]

    var body: some View {
        List(hackspaces) {
            let hackspace = $0
            HStack {
                Image(systemName: hackspace.image)
                Text(hackspace.title)
            }
        }
    }

    init(hackspaces: [Hackspace]) {
        self.hackspaces = hackspaces
    }
}

struct FavoritesView: View {
    let favorites: [Hackspace] = [Hackspace(image: "globe", title: "Section77")]

    var body: some View {
        if favorites.isEmpty {
            Text("nicht gefunden")
        } else {
            HackspaceListView(hackspaces: favorites)
        }
    }
}

struct BrowseView: View {
    let decoder = JSONDecoder()
//    let product = try decoder.decode(GroceryProduct.self, from: json)

    let hackspaces = [
        Hackspace(image: "globe", title: "Setion77"),
        Hackspace(image: "circle.hexagonpath", title: "entropia"),
        Hackspace(image: "globe", title: "x-hain")
    ]

    var body: some View {
        HackspaceListView(hackspaces: hackspaces)
    }
}

struct MyTestView: View {
    var body: some View {
        Button(action: makeAPICall) {
            Label("DirectoryAPI", systemImage: "arrow.down")
        }
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
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "globe")
                }
                .tag(0)
            MyTestView()
                .tabItem {
                    Label("MyView", systemImage: "checkmark")
                }
                .tag(0)
        }.onAppear(perform: {
            if let localData = readLocalFile(forName: "spaceapi") {
                parse(jsonData: localData)
            }
        })
        .padding()
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
