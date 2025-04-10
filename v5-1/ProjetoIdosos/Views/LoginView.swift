//
//  LoginView.swift
//  ProjetoIdosos
//
//  Created by Turma02-11 on 09/04/25.
//

import SwiftUI

struct LoginView: View {
    
    @State public var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                Group {
                    TextField("Email: ",text: $email)
                        .multilineTextAlignment(.center)
                    SecureField("Senha: ",text: $password)
                        .multilineTextAlignment(.center)
                    NavigationLink(destination: ContentView()) {
                        Text("Entrar")
                            .foregroundStyle(.lightGreen)
                    }
                }
                .padding()
                .background(.background)
                .clipShape(.rect(cornerRadius: 4))
            }
            .padding(40)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .padding(20)
        }
    }
}

#Preview {
    LoginView()
}
