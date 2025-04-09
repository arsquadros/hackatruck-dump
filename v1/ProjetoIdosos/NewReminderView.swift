//
//  NewReminderView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct NewReminderView: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var selectedDate: Date = Date()
    @State var isRepeatable: Bool = false
    @State var repeatDays: [Bool] = [false, false, false, false, false, false, false]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.headline)
                .padding(.horizontal)
            TextField("Enter title", text: $title)
                .padding()
                .border(Color.gray, width: 1)
                .padding(.horizontal)
            
            Text("Description")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            TextEditor(text: $description)
                .frame(height: 100)
                .border(Color.gray, width: 1)
                .padding()
            
            Text("Date and Time")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            DatePicker("Select Date and Time", selection: $selectedDate)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Toggle("Repeat", isOn: $isRepeatable)
                    .padding(.horizontal)
                
                if isRepeatable {
                    Text("Repeat On")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    Grid(horizontalSpacing: 15, verticalSpacing: 10) {
                        GridRow {
                            DayToggle(day: "Dom", isSelected: $repeatDays[0])
                            DayToggle(day: "Seg", isSelected: $repeatDays[1])
                            DayToggle(day: "Ter", isSelected: $repeatDays[2])
                            DayToggle(day: "Qua", isSelected: $repeatDays[3])
                        }
                        GridRow {
                            DayToggle(day: "Qui", isSelected: $repeatDays[4])
                            DayToggle(day: "Sex", isSelected: $repeatDays[5])
                            DayToggle(day: "Sab", isSelected: $repeatDays[6])
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            
            Spacer() // Push content to the top
            
            Button("Save") {
                let newReminder = Reminders(
                    id: UUID().uuidString,
                    title: title,
                    description: description,
                    datetime: Int(selectedDate.timeIntervalSince1970),
                    isRepeatable: isRepeatable,
                    repeatDays: repeatDays
                )
                ViewModel().uploadReminder(reminder: newReminder)
            }
            .disabled(title.isEmpty)
            .padding()
            
        }
    }
}
    
#Preview {
    NewReminderView()
}
