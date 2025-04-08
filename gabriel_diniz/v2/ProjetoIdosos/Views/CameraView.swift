//
//  CameraView.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        Image(systemName: "camera.fill").resizable().frame(
            width: 130, height: 100
        ).foregroundColor(.blue)
    }
}

#Preview {
    CameraView()
}
