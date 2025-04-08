//
//  OCRResultView.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 07/04/25.
//

import SwiftUI

struct OCRResultView: View {
    let recognizedText: String

    var body: some View {
        ScrollView {
            VStack() {
                Text("Recognized Text:")
                    .font(.title)
                Spacer()
                Text(recognizedText)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
        }
        .navigationTitle("OCR Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}
