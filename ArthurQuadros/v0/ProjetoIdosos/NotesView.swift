//
//  Notes.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct NotesView: View {
    @State var notas:[Notes] = [
        Notes(
            id:"1",
            title: "Nota 1",
            description: "Conteúdo"
        ),
        Notes(
            id:"2",
            title: "Nota 2",
            description: "Conteúdo"
        ),
        Notes(
            id:"3",
            title: "Nota 3",
            description: "Conteúdo"
        )
    ]
    
    var body: some View {
        VStack {
            Text(
                "Adicionar Nota"
            ).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.blue).padding(.bottom, 50)
            
            Spacer()
            
            Text("Notas cadastradas").font(.largeTitle).bold()
            List(notas) { nota in
                VStack {
                    Text("\(nota.title)").font(.title).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/).padding(.leading, 20)
                    Text("\(nota.description)").font(.title2).multilineTextAlignment(.trailing).padding(.leading, 20)
                }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    NotesView()
}
