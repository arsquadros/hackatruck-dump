//
//  HeartBeats.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI
import Charts

struct HeartBeatsView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var heartBeatData: [HeartBeats] = []
    
    @State private var animationAmount: CGFloat = 1
    
    @State private var animationAlert: Bool = true
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
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
                Image(systemName: "person.crop.circle")
                    .font(.largeTitle)
                
            }
            
            Rectangle()
                .frame(width: .infinity, height: 1)
                .padding(.top, -10)
                .foregroundStyle(.lightGreen)
            
            
            
            HStack {
                Image(systemName: "heart.fill")
                    .scaleEffect(animationAmount)
                    .animation(
                        .linear(duration: 0.2)
                        .delay(0.2)
                        .repeatForever(autoreverses: true),
                        value: animationAmount)
                    .onAppear {
                        animationAmount = 1.2
                    }
                
                if let lastHeartBeat = viewModel.heartBeat.sorted(by: { $0.date < $1.date }).last {
                    ForEach([lastHeartBeat]) { hb in
                        HStack {
                            Text(hb.heartBeat)
                            Text("bpm")
                        }
                    }
                }
            }
            .foregroundStyle(.darkRed)
            .padding()
            .font(.largeTitle)
            .bold()
            
            
            Spacer()
            Chart(viewModel.heartBeat.sorted(by: { $0.date < $1.date })) { hb in
                
                LineMark(
                    x: .value("Date", hb.date),
                    y: .value("HeartBeat", hb.heartBeat)
                )
                .foregroundStyle(.lightGreen)
                
            }
            .frame(width: 300, height: 200)
            
            
            Spacer()
        }
        .onAppear {
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                viewModel.fetch()
            }
            heartBeatData = []
            for index in viewModel.heartBeat {
                let umidade = index.heartBeat
                let data = index.date
                heartBeatData.append(HeartBeats(heartBeat: umidade, date: data))
            }
            
        }
        
        .padding(.horizontal)
    }
}



#Preview {
    HeartBeatsView()
}
