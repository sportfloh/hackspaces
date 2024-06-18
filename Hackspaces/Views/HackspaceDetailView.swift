//
//  HackspaceDetailView.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//
import SwiftUI

struct HackspaceDetailView: View {
    let hackspace: Hackspace
    @State private var logoImage: UIImage?
    @State private var spaceApi: SpaceApi?
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 15, height: 10)
                        .foregroundColor(.blue)
                }
                Text(hackspace.title)
                    .font(.title)
                    .padding(.vertical)
                if let isOpen = spaceApi?.state.open {
                    Image(systemName: isOpen ? "circle.fill" : "circle")
                        .foregroundColor(isOpen ? .green : .red)
                        .padding(.top, 5)
                }
            }

            if isLoading {
                ProgressView()
            } else {
                if let spaceApi = spaceApi {
                    Text("Address: \(spaceApi.location.address)")
                    Text("Contact:")
                    if let image = logoImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    } else {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Logo not available")
                        }
                    }
                } else {
                    Text("Error fetching data")
                }
            }

            Spacer()

            Button("Call API") {
                spaceAPIWrapper()
            }
            Button("Download Logo") {
                downloadLogoWrapper(from: (spaceApi?.logo)!)
            }
        }
        .padding()
        .onAppear {
            spaceAPIWrapper()
        }
    }

    func spaceAPIWrapper() {
        isLoading = true

        APIService.makeSpaceAPICall(for: hackspace.apiUrl) { spaceApi in
            isLoading = false

            if let spaceApi = spaceApi {
                self.spaceApi = spaceApi
                print("API data for \(hackspace.title): \(spaceApi)")
            } else {
                print("Error fetching data")
            }
        }
    }

    func downloadLogoWrapper(from url: URL) {
        isLoading = true

        APIService.getHackSpaceLogo(from: url) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                    case .success(let image):
                        logoImage = image
                    case .failure(let error):
                        print("Error downloading image: \(error)")
                }
            }
        }
    }
}
