//
//  OCRResultView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 07/04/25.
//

import SwiftUI

struct OCRResultView: View {
    let recognizedText: String
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State var animationAlert = true

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if viewModel.heartBeat.isEmpty {
                        Text("00")
                            .font(.title)
                            .foregroundStyle(.black)
                    } else if let lastHeartBeat = viewModel.heartBeat.sorted(by: { $0.date < $1.date }).last {
                        let num = Double(lastHeartBeat.heartBeat) ?? 0
                        
                        if num >= 40 && num < 110 {
                            Text("\(num.formatted())")
                                .font(.title)
                                .foregroundStyle(.black)
                            
                        } else {
                            if animationAlert == true {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.orange)
                                
                            } else {
                                Text("\(num.formatted())")
                                    .font(.title)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        
                        
                    }
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 60, height: 60)
                    Spacer()
                    
                    NavigationLink(destination: LoginView()) {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                    }
                    
                }
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .padding(.top, -10)
                    .foregroundStyle(.lightGreen)
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Recognized Text:")
                            .font(.headline)
                            .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))) // Dark Gray
                            .padding(.bottom, 5)
                        
                        Text(recognizedText)
                            .font(.title2)
                            .foregroundColor(Color(#colorLiteral(red: 0.2196078431, green: 0.3803921569, blue: 0.3294117647, alpha: 1))) // Darker Green
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure text aligns to the left and takes available width
                            .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))) // Light background for better readability
                            .cornerRadius(8)
                        
                        Spacer() // Push content to the top if needed
                    }
                    .padding()
                }
                .navigationTitle("OCR Result")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1))) // Very Light Gray Background
            }
        }.padding()
    }
}
