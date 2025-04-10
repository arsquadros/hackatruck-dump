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
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State var animationAlert = true
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                NavBarView()
                // Styled Navigation Bar Title
                HStack {
                    Text("Novo cuidado")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.2196078431, green: 0.3803921569, blue: 0.3294117647, alpha: 1))) // Darker Green
                        .padding(.vertical)
                    Spacer()
                    // You might have a "Cancel" button here in your actual NavBarView
                }
                .padding(.horizontal)
                
                Text("Que título pode ajudar o entendimento da nota?")
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))) // Dark Gray
                    .padding(.horizontal)
                    .padding(.top)
                TextField("Adicionar título", text: $newNoteTitle)
                    .font(.title3) // Larger font for input
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))) // Light background for better contrast
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .border(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)), width: 1) // Subtle border
                
                Text("Qual a descrição detalhada da nota?")
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))) // Dark Gray
                    .padding(.horizontal)
                    .padding(.top)
                TextEditor(text: $newNoteDescription)
                    .frame(height: 150)
                    .font(.body) // Use body font, will be adjusted for size
                    .padding(8)
                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))) // Light background
                    .cornerRadius(8)
                    .border(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)), width: 1)
                    .padding()
                
                Spacer() // Push content to the top
                
                Button {
                    let newNote = Notes(id: UUID().uuidString, title: newNoteTitle, description: newNoteDescription)
                    Task {
                        ViewModel().uploadNote(note: newNote)
                        // Consider adding navigation back or a confirmation message
                    }
                } label: {
                    Text("Save Note")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(newNoteTitle.isEmpty ? Color(#colorLiteral(red: 0.6235294118, green: 0.7725490196, blue: 0.6666666667, alpha: 0.5)) : Color(#colorLiteral(red: 0.6235294118, green: 0.7725490196, blue: 0.6666666667, alpha: 1))) // Light Green
                        .cornerRadius(10)
                }
                .disabled(newNoteTitle.isEmpty)
                .padding()
            }
            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1))) // Very Light Gray Background
            .navigationBarHidden(true) // Hide the default navigation bar if you're using a custom one
        }
    }
}

#Preview {
    NewNoteView()
}
