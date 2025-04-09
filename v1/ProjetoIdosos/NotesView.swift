//
//  Notes.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct NotesView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Adicionar Nota", destination: NewNoteView())
                    .font(.title)
                
                Spacer()
                
                Text("Últimas Notas")
                    .font(.title)
            
                List(vm.notes) { note in
                    ScrollView {
                        VStack {
                            NavigationLink("\(note.title)", destination: NoteDetailView(note: note))
                                .font(.title).multilineTextAlignment(.leading).padding(.leading, 20)
                            Text("\(note.description)").font(.title2).multilineTextAlignment(.trailing).padding(.leading, 20)
                        }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)

                    }
                }
                .onAppear {
                    Task {
                        vm.fetchNotes()
                    }
                }
            }
        }
    }
}

#Preview {
    NotesView()
}
