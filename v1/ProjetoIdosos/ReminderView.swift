//
//  Reminder.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct ReminderView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Adicionar Nota", destination: NewReminderView())
                    .font(.title)
                
                Spacer()
                
                Text("Últimos Alarmes")
                    .font(.title)
            
                List(vm.reminders) { reminder in
                    ScrollView {
                        VStack {
                            NavigationLink("\(reminder.title)", destination: ReminderDetailView(reminder: reminder))
                                .font(.title).multilineTextAlignment(.leading).padding(.leading, 20)
                            Text("\(reminder.description)").font(.title2).multilineTextAlignment(.trailing).padding(.leading, 20)
                        }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)

                    }
                }
                .onAppear {
                    Task {
                        vm.fetchReminders()
                    }
                }
            }
        }
    }
}
#Preview {
    ReminderView()
}
