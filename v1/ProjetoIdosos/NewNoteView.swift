//
//  NewNoteView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct NewNoteView: View {
    @State var newNoteTitle: String = ""
    @State var newNoteDescription: String = ""
    
    var body: some View {
        VStack {
            Text("Que título pode ajudar o entendimento da nota?")
                .font(.headline)
                .padding(.horizontal)
            TextField("Adicionar título", text: $newNoteTitle)
                .padding()
                .border(Color.gray, width: 1)
                .padding(.horizontal)

            Text("Qual a descrição detalhada da nota?")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            TextEditor(text: $newNoteDescription)
                .frame(height: 150)
                .border(Color.gray, width: 1)
                .padding()

            Spacer() // Push content to the top
        
            Button("Save") {
                let newNote = Notes(id: UUID().uuidString, title: newNoteTitle, description: newNoteDescription)
                Task {
                    ViewModel().uploadNote(note: newNote)
                }
            }
            .disabled(newNoteTitle.isEmpty)
            .padding()
        
        }
    }
}

#Preview {
    NewNoteView()
}
