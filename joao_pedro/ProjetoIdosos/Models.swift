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

struct HeartBeats: Identifiable, Codable {
    let id: String // uuid
    
    let beatsPerMinute: Double // maybe string is better
}

struct Notes: Identifiable, Codable {
    let id: String // uuid
    
    let title: String
    let description: String
}
