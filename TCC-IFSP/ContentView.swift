//
//  ContentView.swift
//  TCC-IFSP
//
//  Created by Gabriel Amaral on 10/02/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @Environment(EmotionClassifierViewModel.self) var detector
    @State private var emotionItem: PhotosPickerItem?
    @State private var presentPhotoPicker = false
    @State private var presentCamera = false
    
    var body: some View {
        VStack {
            Text("Emotion Detector")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 30)
            
            if let selectedImage = detector.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                
                Text(detector.classificationLabel)
                    .font(.title2)
                
                Spacer()
                
                VStack {
                    Button {
                        detector.flagCurrentImage()
                    } label: {
                        Text("Flag picture")
                            .font(.headline)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .frame(width: 365)
                            .background(.red)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .contentShape(Rectangle())
                    }
                    HStack {
                        Button{
                            presentPhotoPicker = true
                        } label: {
                            Text("Select image")
                                .font(.headline)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 24)
                                .frame(minWidth: 180)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .contentShape(Rectangle())
                        }
                        
                        Button {
                            presentCamera = true
                        } label: {
                            Text("Take picture")
                                .font(.headline)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 24)
                                .frame(minWidth: 180)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .contentShape(Rectangle())
                        }
                    }
                }
                
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 200))
                    .foregroundColor(.gray.opacity(0.3))
                
                Text(detector.classificationLabel)
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button {
                        presentPhotoPicker = true
                    } label: {
                        Text("Select Image")
                            .font(.headline)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .frame(minWidth: 180)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .contentShape(Rectangle())
                        
                    }
                    
                    Button {
                        presentCamera = true
                    } label: {
                        Text("Take picture")
                            .font(.headline)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .frame(minWidth: 180)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .photosPicker(isPresented: $presentPhotoPicker,
                      selection: $emotionItem,
                      matching: .images)
        .sheet(isPresented: $presentCamera) {
            CameraAdaptor { image in
                Task { await detector.detect(image: image) }
            }
        }
        .onChange(of: emotionItem) {
            Task {
                if let loaded = try? await emotionItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: loaded) {
                    
                    await detector.detect(image: image)
                }
            }
        }
        .overlay(alignment: .top) {
            if detector.didFlagImage {
                Text("Flag saved!")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.green)
                    .cornerRadius(16)
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: detector.didFlagImage)
            }
        }

    }
}
