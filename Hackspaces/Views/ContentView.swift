//
//  ContentView.swift
//  hackspaces
//
//  Created by Florian Bruder and Christian Werner on 15.08.23.
//

import SwiftUI

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
    let favorites: [Hackspace] = [Hackspace(image: "globe", title: "Setion77")]

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
