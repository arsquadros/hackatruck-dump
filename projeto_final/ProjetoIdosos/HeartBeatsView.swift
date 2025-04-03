//
//  HeartBeats.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI
import Charts

struct HeartBeatsView: View {
    let ydata = [1, 4.5, 3, 6, 7, 5.2, 9, 12.5]
    
    var body: some View {
        VStack {
            Text("Heart Beats Screen").font(.largeTitle).bold()
            Text("80 bpm").font(.title)
            
            Spacer()
            
            Chart(0..<ydata.count, id: \.self) { nr in
                LineMark(
                    x: .value("X values", nr),
                    y: .value("Y values", ydata[nr])
                )
            }.frame(height: 200).padding()
            
            Spacer()
        }
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
