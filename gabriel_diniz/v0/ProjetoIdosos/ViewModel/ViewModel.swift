//
//  ViewModel.swift
//  ProjetoIdosos
//
//  Created by Turma02-11 on 03/04/25.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var heartBeat: [HeartBeats] = []
    
    func fetch() {
        guard let url = URL(string: "http://192.168.128.90:1880/getHeartBeat") else {
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
