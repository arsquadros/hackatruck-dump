//
//  ContentView.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            StartView().tabItem {
                Label(
                    "Tela Inicial",
                    systemImage: "house.fill"
                ).padding()
            }
            ReminderView().tabItem {
                Label(
                    "Alarme",
                    systemImage: "stopwatch.fill"
                )
            }
            CameraView().tabItem {
                Label(
                    "Câmera",
                    systemImage: "camera.fill"
                ).padding()
            }
            HeartBeatsView().tabItem {
                Label(
                    "Batimentos",
                    systemImage: "bolt.heart.fill"
                )
            }
            NotesView().tabItem {
                Label(
                    "Cuidados",
                    systemImage: "list.bullet.clipboard.fill"
                )
            }
        }.tint(.green)
    }
}

#Preview {
    ContentView()
}
