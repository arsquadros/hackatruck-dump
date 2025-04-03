//
//  Reminder.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct ReminderView: View {
    @State var alarmes:[Reminder] = [
        Reminder(
            id:"1",
            title: "tit",
            description: "desc",
            datetime: Date(),
            isRepeatable: false
        ),
        Reminder(
            id:"2",
            title: "tit",
            description: "desc",
            datetime: Date(),
            isRepeatable: false
        ),
        Reminder(
            id:"3",
            title: "tit",
            description: "desc",
            datetime: Date(),
            isRepeatable: false
        )
    ]
    
    var body: some View {
        VStack {
            Text(
                "Adicionar alarme"
            ).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.blue).padding(.bottom, 50)
            
            Spacer()
            
            Text("Próximos alarmes").font(.largeTitle).bold()
            List(alarmes) { alarme in
                HStack {
                    Text("\(alarme.datetime)").font(.title).padding(.leading, 20)
                }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    ReminderView()
}
