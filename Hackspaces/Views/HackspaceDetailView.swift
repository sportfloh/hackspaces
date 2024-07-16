//
//  HackspaceDetailView.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//
import SwiftUI

struct HackspaceDetailView: View {
  let hackspace: Hackspace
  @State private var spaceApi: SpaceApi?
  @State private var logoImage: UIImage?
  @State private var isLoading = false // Flag for overall data fetching
  @State private var isDownloadingLogo = false

  var body: some View {
    NavigationView { // Wrap in NavigationView for consistent navigation
      ScrollView { // Wrap in ScrollView for scrollable content
        VStack(alignment: .leading) { // Align content to leading edge

          HStack {
            if let image = logoImage {
              Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            }
            Text(hackspace.title)
              .font(.title)
              .fontWeight(.bold) // Use bold weight for title
            Spacer()
            if let isOpen = spaceApi?.state.open {
              Image(systemName: isOpen ? "circle.fill" : "circle")
                .foregroundColor(isOpen ? .green : .red)
            }
          }

          if let spaceApi = spaceApi {
            Text("Address: \(spaceApi.location.address)")
              .padding(.top) // Add top padding for spacing
          } else {
            Text("Error fetching data")
          }

          Spacer() // Add spacer at the bottom for aesthetics
        }
        .padding() // Pad content within the VStack
      }
      .navigationTitle(hackspace.title) // Set navigation title
    }
    .onAppear {
      loadSpaceApi()
    }
  }

  private func loadSpaceApi() {
    isLoading = true // Set isLoading to true before starting API call
    // Replace with your actual API call logic
    APIService.makeSpaceAPICall(for: hackspace.apiUrl) { [self] spaceApi in
      isLoading = false // Set isLoading to false after receiving data
      if let spaceApi = spaceApi {
        self.spaceApi = spaceApi
        // Check if logo URL is available after loading API data
        if let logoUrl = spaceApi.logo {
          isDownloadingLogo = true
          downloadLogoWrapper(from: logoUrl) { [self] result in
            DispatchQueue.main.async {
              isDownloadingLogo = false
              switch result {
              case .success(let image):
                logoImage = image
              case .failure(let error):
                print("Error downloading image: \(error)")
              }
            }
          }
        }
      } else {
        print("Error fetching data")
      }
    }
  }

  func downloadLogoWrapper(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    // Replace with your actual image download logic
    APIService.getHackSpaceLogo(from: url) { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }
}




