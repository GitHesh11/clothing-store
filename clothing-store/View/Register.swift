//
//  Register.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-29.
//

import SwiftUI

struct Register: View {
    @StateObject var registerVM = RegisterViewModel()
    @Environment(\.presentationMode) var present
     
    var body: some View {
        ZStack{
            ZStack(alignment: .topLeading, content: {
                GeometryReader{_ in
                    ScrollView{
                        LazyVStack{

                        Text("Register")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.7))
                                .padding(.top, 15)
                            VStack{
                            
                                TextField("First Name", text: self.$registerVM.register.firstname)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(self.registerVM.register.firstname != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                                    )
                                    .padding(.top, 20)
                                
                                    TextField("Last Name", text: self.$registerVM.register.lastname)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(self.registerVM.register.lastname != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                                        )
                                        .padding(.top, 20)
                                        
                            }


                            HStack(spacing: 15) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color.black.opacity(0.7))
                                TextField("Email", text: self.$registerVM.register.email)
                                    .textInputAutocapitalization(.never)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(self.registerVM.register.email != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.top, 20)
                            
                            HStack(spacing: 15){
                                
                                Button {
                                    self.registerVM.visible.toggle()
                                } label: {
                                    Image(systemName: self.registerVM.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                                
                                VStack{
                                    if self.registerVM.visible{
                                        TextField("Password", text: self.$registerVM.register.pass)
                                            .textInputAutocapitalization(.never)
                                    }else {
                                        SecureField("Password", text: self.$registerVM.register.pass)
                                            .textInputAutocapitalization(.never)
                                    }
                                }

                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(self.registerVM.register.pass != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.top, 20)
                            
                            HStack(spacing: 15){
                                Button {
                                    self.registerVM.revisible.toggle()
                                } label: {
                                    Image(systemName: self.registerVM.revisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                                
                                VStack{
                                    if self.registerVM.revisible{
                                        TextField("Re-enter Password", text: self.$registerVM.register.repass)
                                            .textInputAutocapitalization(.never)
                                    }else {
                                        SecureField("Re-enter Password", text: self.$registerVM.register.repass)
                                            .textInputAutocapitalization(.never)
                                    }
                                }

                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(self.registerVM.register.repass != "" ? Color("FPurple") : Color.black.opacity(0.7), lineWidth: 2)
                            )
                            .padding(.top, 20)
                            
                            Button {
                                registerVM.verifyRegistration()
                            } label: {
                                Text("Register")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color("FPurple"))
                            .cornerRadius(10)
                            .padding(.top, 20)

                        }
                        .padding(.horizontal, 25)
                    }
                }
                
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    HStack{
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color("FPurple"))
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(Color("FPurple"))
                    }
                }
                .padding()

            })
            if self.registerVM.message.alert{
                GeometryReader{_ in
                    ErrorMessagesView(alert: self.$registerVM.message.alert, error: self.$registerVM.message.error, topic: self.$registerVM.message.topic, loading: self.$registerVM.message.isLoading, guestUser: $registerVM.message.guestUser)
                }
            }
        }
        .background(Color("GrayBG"))
        .navigationBarHidden(true)
    }
}

#Preview {
    Register()
}
