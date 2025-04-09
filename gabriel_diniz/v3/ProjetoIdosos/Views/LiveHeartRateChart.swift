//import SwiftUI
//import Charts
//
//struct LiveHeartRateChart: View {
//    @StateObject private var viewModel = HeartRateViewModel()
//
//    var body: some View {
//        VStack {
//            Text("Live Heart Rate")
//                .font(.title)
//                .bold()
//                .padding()
//
//            Chart(viewModel.heartRateData, id:\.self) { entry in
//                LineMark(
//                    x: .value("Time", entry.date),
//                    y: .value("BPM", entry.heartBeat)
//                )
//                .interpolationMethod(.catmullRom)
//            }
//            .chartXAxis(.hidden)
//            .frame(height: 300)
//            .animation(.easeInOut(duration: 1.5), value: viewModel.heartRateData)
//        }
//        .onAppear {
//            viewModel.startUpdating()
//        }
//        .onDisappear {
//            viewModel.stopUpdating()
//        }
//    }
//}
//
//
//#Preview {
//    LiveHeartRateChart()
//}
