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

    
    var body: some View {
        VStack {
            HStack {
                if let lastHeartBeat = viewModel.heartBeat.sorted(by: { $0.date < $1.date }).last {
                    ForEach([lastHeartBeat]) { hb in
                        HStack {
                            let num = Double(hb.heartBeat)
                            Text("\(num!.formatted())")
                                .font(.title)
                                .foregroundStyle(.darkRed)
                        }
                    }
                }
                Spacer()
                Image(systemName: "figure.2.and.child.holdinghands")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                Spacer()
                Image(systemName: "person.crop.circle")
                    .font(.largeTitle)
                    
            }
            
            Rectangle()
                .frame(width: .infinity, height: 1)
                .padding(.top, -5)
            
            HStack {
                Image(systemName: "heart.fill")
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
                        x: .value("", hb.date),
                        y: .value("", hb.heartBeat)
                    )
                    .foregroundStyle(.green)
            
            }
            .frame(width: 300, height: 200)
            
            
            Spacer()
        }.onAppear(){
            viewModel.fetch()
            heartBeatData = []
            for index in viewModel.heartBeat{
                let umidade = index.heartBeat
                let data = index.date
                heartBeatData.append(HeartBeats(heartBeat: umidade, date: data))
            }
        }.padding(.horizontal)
    }
}

#Preview {
    HeartBeatsView()
}
