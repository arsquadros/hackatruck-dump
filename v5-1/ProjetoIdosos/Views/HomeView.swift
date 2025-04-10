//
//  HomeView.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

import SwiftUI

struct StartView: View {
    @StateObject var vm = ViewModel()
    
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State var animationAlert = true
    
    var body: some View {
        NavigationStack{
            VStack {
                
                NavBarView()
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Últimos Lembretes")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                        
                        List {
                            ForEach(vm.reminders) { reminder in
                                NavigationLink(destination: ReminderDetailView(reminder: reminder)) {
                                    VStack(alignment: .leading) {
                                        Text(reminder.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(reminder.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: CGFloat(vm.reminders.count * 60)) // Adjust height based on content
                        
                        Text("Últimas Notas")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        
                        List {
                            ForEach(vm.notes) { note in
                                NavigationLink(destination: NoteDetailView(note: note)) {
                                    VStack(alignment: .leading) {
                                        Text(note.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(note.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: CGFloat(vm.notes.count * 60)) // Adjust height based on content
                        
                        Spacer()
                    }
                    .padding(.top)
                    .navigationBarHidden(true)
                    .onAppear {
                        Task {
                            vm.fetchReminders()
                            vm.fetchNotes()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StartView()
}
