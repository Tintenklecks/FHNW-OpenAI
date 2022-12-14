//
//  ContentView.swift
//  OpenAI
//
//  Created by Ingo Boehme on 11.12.22.
//

import SwiftUI

// MARK: - MainView

struct AIImageView: View {
    @EnvironmentObject var appState: AppState

    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            if appState.isOffline {
                BannerView(showing: .constant(true), type: .noInternet)
                    .animation(.default, value: appState.isOffline)
            }
            if viewModel.checkDone {
                if viewModel.rejectionReason == "" {
                    BannerView(showing: $viewModel.checkDone, type: .info("Your prompt is OK"))
                        .animation(.default, value: viewModel.checkDone)

                } else {
                    BannerView(showing: $viewModel.checkDone, type: .error("There are the following concerns:\n\(viewModel.rejectionReason)"))
                        .animation(.default, value: viewModel.checkDone)
                }
            }

            ZStack {
                VStack(alignment: .leading) {
                    Text("Description of picture to create:")
                        .bold()
                    TextField("Enter description to generate an image from", text: $viewModel.prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            viewModel.renderImage()
                        }
                    HStack {
                        Text("Picture size:")
                            .bold()
                        Picker("Picture size", selection: $viewModel.size) {
                            ForEach(OpenAIImageSizes.allCases, id: \.self) { size in
                                Text(size.asParameter)
                            }
                        }
                    }

                    HStack {
                        Button("Check wording") {
                            viewModel.checkPrompt()
                        }
                        .buttonStyle(.bordered)
                        Button("Render Image") {
                            viewModel.renderImage()
                        }
                        .buttonStyle(.borderedProminent)

                    }.padding()

                    ScrollView([.horizontal, .vertical]) {
                        AsyncImage(url: viewModel.imageUrl)
                            .frame(width: viewModel.size.width, height: viewModel.size.height)
                    }
                    Spacer()
                }
                .padding(32)
                .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {}

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .scaleEffect(3)
                    .foregroundColor(.yellow)
                    .opacity(viewModel.isBusy ? 1 : 0)
            }
        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AIImageView()
    }
}
