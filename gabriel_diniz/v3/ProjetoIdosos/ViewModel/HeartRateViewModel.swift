import SwiftUI

final class HeartRateViewModel: ObservableObject {
    @Published var heartRateData: [HeartBeats] = []
    private var timer: Timer?
    private let maxDataPoints = 50

//    init() {
//        startUpdating()
//    }

//    func startUpdating() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//           // let newEntry = HeartBeats.random(label: "Heart Rate")
//            DispatchQueue.main.async {
//                self.heartRateData.append(newEntry)
//                if self.heartRateData.count > self.maxDataPoints {
//                    self.heartRateData.removeFirst()
//                }
//            }
//        }
//    }

    func stopUpdating() {
        timer?.invalidate()
        timer = nil
    }
}
