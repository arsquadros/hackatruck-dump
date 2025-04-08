//
//  Models.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import Foundation

struct Reminder: Identifiable, Codable {
    let id: String // uuid
    
    let title: String
    let description: String
    let datetime: Date
    let isRepeatable: Bool
}

struct HeartBeats: Identifiable, Decodable {
    let id = UUID()
    let heartBeat: String
    let date: String
  //  let label: String
    
//    static func random(label: String) -> HeartBeats {
//        HeartBeats(heartBeat: String(Int.random(in: 30...160)), date: Int.random(in: 1...999999999), label: label)
//    }
}

struct Notes: Identifiable, Codable {
    let id: String // uuid
    
    let title: String
    let description: String
}
