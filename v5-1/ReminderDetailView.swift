//
//  ReminderDetailView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct ReminderDetailView: View {
    var reminder: Reminders

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Abbreviated day name
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text(reminder.title)
                .font(.largeTitle)
                .padding(.bottom)

            Text("Detalhes")
                .font(.title)
                .padding(.bottom, 5)

            Text(reminder.description)
                .font(.title2)
                .padding(.bottom)

            Text("Data e hora:")
                .font(.title2)
            Text("\(Date(timeIntervalSince1970: TimeInterval(reminder.datetime)), formatter: dateFormatter)")
                .font(.title3)
                .padding(.bottom)

            Text("Repeat:")
                .font(.title2)
            if reminder.isRepeatable {
                HStack {
                    ForEach(0..<reminder.repeatDays.count, id: \.self) { index in
                        if reminder.repeatDays[index] {
                            Text(getDayOfWeek(from: index))
                                .font(.title2)
                                .padding(5)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
                .padding(.bottom)
                if reminder.repeatDays.allSatisfy({ !$0 }) {
                    Text("Não foram selecionados dias para repetição.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            } else {
                Text("Não se repete")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Detalhes do lembrete")
        .navigationBarTitleDisplayMode(.inline)
    }

    func getDayOfWeek(from index: Int) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.weekday = index + 1 // Sunday is 1, Monday is 2, etc.
        if let date = calendar.date(from: dateComponents) {
            return dayFormatter.string(from: date)
        }
        return ""
    }
}

#Preview {
    ReminderDetailView(
        reminder: Reminders(
            id: UUID().uuidString,
            title: "Tomar Paracetamol",
            description: "Tomar Paracetamol para aliviar as dores de cabeça frequentes.",
            datetime: Int(Date().timeIntervalSince1970) + 86400,
            isRepeatable: true,
            repeatDays: [true, true, true, true, true, true, true]
        )
    )
}
