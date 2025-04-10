//
//  ContentView.swift
//  ProjetoIdosos
//
//  Created by Turma02-16 on 02/04/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        TabView {
            StartView().tabItem {
                Label(
                    "Tela Inicial",
                    systemImage: "house.fill"
                )
            }
            ReminderView().tabItem {
                Label(
                    "Alarme",
                    systemImage: "stopwatch.fill"
                )
            }
            CameraView(image: $cameraViewModel.currentFrame)
                .ignoresSafeArea()
                .tabItem {
                Label(
                    "Câmera",
                    systemImage: "camera.fill"
                )
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
        }.onAppear() {
            UNUserNotificationCenter.current()
                .requestAuthorization(
                    options: [.alert, .badge, .sound]
                ) { success, error in
                    if success {
                        print("Permission approved!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
        }.tint(.lightGreen)
    }
}

#Preview {
    ContentView()
}
