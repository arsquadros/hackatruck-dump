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

struct HeartBeats: Hashable, Decodable {
    let heartBeat: String
}

struct Notes: Identifiable, Codable {
    let id: String // uuid
    
    let title: String
    let description: String
}
