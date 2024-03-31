//
//  Login.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-29.
//

import SwiftUI

struct Login: View {
    @StateObject var loginVM = LoginViewModel()
    @State var visible = false

    var body: some View {
        ZStack{
                GeometryReader{_ in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            HStack{
                                NavigationLink {
                                    Home()
                                } label: {
                                    Text("Home")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("FPurple"))
                                }
                                .padding()
                                Spacer(minLength: 0)
                                NavigationLink {
                                    Register()
                                } label: {
                                    Text("Register")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("FPurple"))
                                }
                                .padding()
                            }
                            Text("Log into your account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.7))
                                .padding(.top,50)
                            Image("bg1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 4)
                            HStack(spacing: 15) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color.black.opacity(0.7))
                                TextField("Email", text: self.$loginVM.login.email)
                                    .textInputAutocapitalization(.never)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(self.loginVM.login.email != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.top, 25)
                            HStack(spacing: 15){
                                
                                Button {
                                    self.visible.toggle()
                                } label: {
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.black.opacity(0.7))
                                }

                                VStack{
                                    if self.visible{
                                        TextField("Password", text: self.$loginVM.login.pass)
                                            .textInputAutocapitalization(.never)
                                    }else {
                                        SecureField("Password", text: self.$loginVM.login.pass)
                                            .textInputAutocapitalization(.never)
                                    }
                                }
                                
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(self.loginVM.login.pass != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.top, 25)
                            
                            HStack{
                                Spacer()
                                NavigationLink {
                                    ForgetPassword()
                                } label: {
                                    Text("Forget Password")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("FPurple"))
                                }
                            }
                            .padding(.top, 20)
                            
                            Button {
                                loginVM.verify()
                            } label: {
                                Text("Log In")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color("FPurple"))
                            .cornerRadius(10)
                            .padding(.top, 25)

                        }
                        .padding(.horizontal, 25)
                    }

                }
                
            
            if self.loginVM.message.alert{
                GeometryReader{_ in
                    ErrorMessagesView(alert: self.$loginVM.message.alert, error: self.$loginVM.message.error, topic: self.$loginVM.message.topic, loading: self.$loginVM.message.isLoading, guestUser: self.$loginVM.message.guestUser)
                }
            }
        }
        .background(Color("GrayBG"))
        .navigationBarHidden(true)
    }
}

#Preview {
    Login()
}
