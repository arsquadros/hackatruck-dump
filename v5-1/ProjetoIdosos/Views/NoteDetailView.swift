//
//  NoteDetailView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct NoteDetailView: View {
    var note: Notes
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State var animationAlert = true
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                NavBarView()
                // Styled Navigation Bar Title
                HStack {
                    Text("Note Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.2196078431, green: 0.3803921569, blue: 0.3294117647, alpha: 1))) // Darker Green
                        .padding(.vertical)
                    Spacer()
                    // You might have back/edit buttons here in your actual NavBarView
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(note.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))) // Dark Gray
                            .padding(.bottom, 5)
                        
                        Text(note.description)
                            .font(.body)
                            .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))) // Medium Gray
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))) // Light background for readability
                            .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer() // Push content to the top if needed
            }
            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1))) // Very Light Gray Background
            .navigationBarHidden(true) // Hide the default navigation bar if you're using a custom one
        }
    }
}
    
    #Preview {
        NoteDetailView(note: Notes(
            id: "tmp", title: "Medication Reminder", description: "Take your blood pressure medication with a full glass of water after breakfast."))
    }
