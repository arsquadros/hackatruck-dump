//
//  NavBarView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 09/04/25.
//

import SwiftUI

struct NavBarView: View {
    var logoText: String = "MyHealth"
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State private var heartBeatData: [HeartBeats] = []
    
    @State private var animationAmount: CGFloat = 1
    
    @State private var animationAlert: Bool = true
    
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
                            .foregroundStyle(.black)
                    }
                }
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .padding(.top, -10)
                    .foregroundStyle(.lightGreen)
                
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    viewModel.fetch()
                }
                heartBeatData = []
                for index in viewModel.heartBeat {
                    let umidade = index.heartBeat
                    let data = index.date
                    heartBeatData.append(HeartBeats(heartBeat: umidade, date: data))
                }
                
            }
            
        }
        .padding()
    }
}

extension Color {
    static let lightBackground = Color(.systemGray6).opacity(0.3) // Adjust as needed
    static let darkText = Color(.black)
}

extension Color {
    init(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHex = cleanHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


#Preview {
    NavBarView()
}
