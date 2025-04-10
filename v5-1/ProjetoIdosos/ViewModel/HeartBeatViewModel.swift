import Foundation

class HeartBeatViewModel: ObservableObject {
    
    @Published var heartBeat: [HeartBeats] = []
    
    func fetch() {
        guard let url = URL(string: "http://192.168.128.87:1880/getHeartBeat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error
            in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode([HeartBeats].self, from: data)
                
                DispatchQueue.main.async {
                    self?.heartBeat = parsed
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
