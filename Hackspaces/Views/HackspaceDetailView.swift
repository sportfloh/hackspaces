//
//  HackspaceDetailView.swift
//  Hackspaces
//
//  Created by Nithin Chelliya on 18.06.24.
//
import SwiftUI
import MapKit

struct HackspaceDetailView: View {
    let hackspace: Hackspace
    @State private var logoImage: UIImage?
    @State private var spaceApi: SpaceApi?
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
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
                    if spaceApi.ext_ccc != nil {
                        VStack(alignment: .leading, spacing: 0) {
                            Label("CCC:", systemImage: "none")
                                .labelStyle(.titleOnly)
                                .underline()
                            Text(spaceApi.ext_ccc!)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Label("Address:", systemImage: "none")
                            .labelStyle(.titleOnly)
                            .underline()
                        Text(spaceApi.location.address)
                        Map(initialPosition: MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: spaceApi.location.lat, longitude: spaceApi.location.lon),
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            )
                        )) {
                                Marker(hackspace.title, coordinate: CLLocationCoordinate2D(latitude: spaceApi.location.lat, longitude: spaceApi.location.lon))
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Contact:")
                            .font(.title3.bold())
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if spaceApi.contact.email != nil {
                        VStack(alignment: .leading, spacing: 0) {
                            Label("E-Mail:", systemImage: "none")
                                .labelStyle(.titleOnly)
                                .underline()
                            Link(spaceApi.contact.email!,
                                 destination: URL(string: "mailto:" + spaceApi.contact.email!)!)
                            // Text(spaceApi.contact.email!)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    }
                    if spaceApi.contact.irc != nil {
                        VStack(alignment: .leading, spacing: 0) {
                            Label("IRC:", systemImage: "none")
                                .labelStyle(.titleOnly)
                                .underline()
                            Text((spaceApi.contact.irc)!)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    }
                    if spaceApi.contact.mastodon != nil {
                        VStack(alignment: .leading, spacing: 0) {
                            Label("Mastodon:", systemImage: "none")
                                .labelStyle(.titleOnly)
                                .underline()
                            Text((spaceApi.contact.mastodon)!)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    }
                    if spaceApi.contact.mumble != nil {
                        VStack(alignment: .leading, spacing: 0) {
                            Label("Mumble:", systemImage: "none")
                                .labelStyle(.titleOnly)
                                .underline()
                            Text((spaceApi.contact.mumble)!)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    }
                    // Link((spaceApi.contact.email), destination: URL(string: "mailto:\(spaceApi.contact.email)")!)

                    if let image = logoImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    } else {
                        if isLoading {
                            ProgressView()
                        } else {
                            //         Text("Logo not available")
                        }
                    }

                } else {
                    Text("Error fetching data")
                }
            }

            Spacer()

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
