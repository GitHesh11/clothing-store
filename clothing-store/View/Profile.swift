//
//  Profile.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var sharedData: SharedProductViewModel
    @StateObject var loginData: LoginViewModel = LoginViewModel()
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    
                    HStack{
                        
                        Button {
                            withAnimation(.easeInOut) {
                                sharedData.showProfilePage = false
                            }
                        } label: {
                            Image("Back")
                                .font(.title2)
                                 .foregroundColor(Color.black.opacity(0.7))
                        }
                        
                        Text("My Profile")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    
                    VStack(spacing: 15){
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                        Text("\(loginData.defaults.string(forKey: "userfirstName") ?? "")" + "\(loginData.defaults.string(forKey: "userlastName") ?? "")")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        
                        Text((loginData.defaults.string(forKey: "userEmail") ?? ""))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("FPurple"))
                        

                    }
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal, .bottom])
                    .background(
                        Color.white.cornerRadius(12)
                    )
                    .padding()
                    .padding(.top, 40)
                    
                    
                    CustomNavigationLink(title: "Wishlist") {
                        Wishlist()
                            .environmentObject(sharedData)
                        
                    }
                    
                    Button {
                        LoginViewModel().logout()
                    } label: {
                        HStack{
                            Text("Logout")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            Color.white.cornerRadius(12)
                        )
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    

                }
                .padding(.horizontal, 22)
                .padding(.vertical, 20)
            }
            .navigationBarHidden(true)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(
                Color("BG")
                    .ignoresSafeArea()
            )
        }
    }
    
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String, @ViewBuilder content : @escaping ()-> Detail)-> some View {
        NavigationLink {
            content()
        } label : {
            HStack{
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                Spacer()
                Image("Go")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .foregroundColor(.black)
            .padding()
            .background(
                Color.white.cornerRadius(12)
            )
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

#Preview {
    Profile()
}
