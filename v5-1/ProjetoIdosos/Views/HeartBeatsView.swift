//
//  HeartBeats.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI
import Charts

struct HeartBeatsView: View {
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State private var heartBeatData: [HeartBeats] = []
    
    @State private var animationAmount: CGFloat = 1
    
    @State private var animationAlert: Bool = true
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavBarView()
                
                HStack {
                    Image(systemName: "heart.fill")
                        .scaleEffect(animationAmount)
                        .animation(
                            .linear(duration: 0.2)
                            .delay(0.2)
                            .repeatForever(autoreverses: true),
                            value: animationAmount)
                        .onAppear {
                            DispatchQueue.main.async {
                                animationAmount = 1.2
                            }
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
                    RuleMark(y:.value("Batimento Normal", 60))
                        .foregroundStyle(Color.black)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash:[5]))
                        .annotation {
                            Text("Batimento Regular")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                    
                    let hbNum = Double(hb.heartBeat)
                    LineMark(
                        x: .value("Date", hb.date),
                        y: .value("HeartBeat", hbNum!)
                    )
                    .foregroundStyle(.lightGreen)
                    
                }
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel() {
                            if let val = value.as(Double.self) {
                                Text("\(Int(val))")
                                    .font(.headline) // Increase Y-axis number size
                            }
                        }
                    }
                }
                //            .chartYAxis(.hidden)
                .frame(width: 300, height: 200)
                
                
                Spacer()
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
    }
}


#Preview {
    HeartBeatsView()
}
