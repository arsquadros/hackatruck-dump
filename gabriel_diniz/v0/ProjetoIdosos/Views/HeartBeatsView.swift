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
    
    var ydata = [0,0]
    var aux = 3
    
    var body: some View {
        VStack {
            Text("Heart Beats Screen").font(.largeTitle).bold()
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title)
                
                ForEach(viewModel.heartBeat.sorted(by: { $0.heartBeat < $1.heartBeat}), id: \.self) { hb in
                    Text(hb.heartBeat)
                }
                
                .font(.title)
            }
            .foregroundStyle(.red)
            .padding()
            
            
            Spacer()
//            Chart(0..<viewModel.heartBeat.count, id: \.self) { nr in
//                ForEach(viewModel.heartBeat, id:\.self) { hb in
//                    
//                    LineMark(
//                        x: .value("X values", nr),
//                        y: .value("Y values", hb.heartBeat)
//                    )
//                }
//            }
            
            
            Spacer()
        }.onAppear(){viewModel.fetch()}
        /* OUTRO EXEMPLO DE GRAFICO - NAO FOI TESTADO
        VStack {
            Text("Live Heart Rate")
                .font(.title)
                .bold()
                .padding()

            Chart(viewModel.heartRateData) { entry in
                LineMark(
                    x: .value("Time", entry.timestamp),
                    y: .value("BPM", entry.bpm)
                )
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis(.hidden)
            .frame(height: 300)
            .animation(.easeInOut(duration: 0.2), value: viewModel.heartRateData)
        }
        .onAppear {
            viewModel.startUpdating()
        }
        .onDisappear {
            viewModel.stopUpdating()
        }
        */
    }
}

#Preview {
    HeartBeatsView()
}
