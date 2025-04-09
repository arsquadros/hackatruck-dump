//
//  DayToggle.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 08/04/25.
//

import SwiftUI

struct DayToggle: View {
    let day: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(day) {
            isSelected.toggle()
        }
        .frame(width: 40, height: 30)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
