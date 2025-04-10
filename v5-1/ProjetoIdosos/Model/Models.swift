//
//  Models.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import Foundation

struct Reminders: Identifiable, Codable {
    let id: String // uuid
    
    let title: String
    let description: String
    let datetime: Int
    let isRepeatable: Bool
    let repeatDays: [Bool]
    
}

struct HeartBeats: Identifiable, Decodable {
    let id = UUID()
    let heartBeat: String
    let date: String
}

struct Notes: Identifiable, Codable {
    let id: String // uuid
    
    var title: String
    var description: String
}

class ViewModel: ObservableObject {
    @Published var notes: [Notes] = []
    @Published var heartBeats: [HeartBeats] = []
    @Published var reminders: [Reminders] = []
    
    func fetchNotes() {
        guard let url = URL(string: "http://192.168.128.87:1880/notes/read") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Error retrieving data.")
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode([Notes].self, from: data)
                
                DispatchQueue.main.async {
                    self?.notes = parsed
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchReminders() {
        guard let url = URL(string: "http://192.168.128.87:1880/reminders/read") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Error retrieving data.")
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode([Reminders].self, from: data)
                
                DispatchQueue.main.async {
                    self?.reminders = parsed
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func uploadNote(note: Notes) {
        guard let url = URL(string: "http://192.168.128.87:1880/notes/create") else {
            print("Invalid URL for uploading note")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(note)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print("Error uploading reminder: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Upload successful. HTTP Status Code: \(httpResponse.statusCode)")
                }
            }
            task.resume()
            
        } catch {
            print("Error encoding reminder data: \(error.localizedDescription)")
        }
    }
    
    func uploadReminder(reminder: Reminders) {
        guard let url = URL(string: "http://192.168.128.87:1880/reminders/create") else {
            print("Invalid URL for uploading reminder")
            return
        }

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(reminder)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print("Error uploading reminder: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Upload successful. HTTP Status Code: \(httpResponse.statusCode)")
                }
            }
            task.resume()

        } catch {
            print("Error encoding reminder data: \(error.localizedDescription)")
        }
    }
}
