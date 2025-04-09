//
//  NoteDetailView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct NoteDetailView: View {
    var note: Notes
    
    var body: some View {
        Text("\(note.title)")
            .font(.largeTitle)
        Spacer()
        Text("\(note.description)")
            .font(.title)
        Spacer()
    }
}

#Preview {
    NoteDetailView(note: Notes(
        id: "tmp", title: "Mock Note", description: "This is a description of a mock note for testing purposes."
    ))
}
