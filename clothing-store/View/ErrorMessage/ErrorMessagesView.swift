import SwiftUI

struct ErrorMessagesView: View {
    @StateObject var loginVM = LoginViewModel()
    @Binding var alert : Bool
    @Binding var error: String
    @Binding var topic: String
    @Binding var loading: Bool
    @Binding var guestUser: Bool
    
    var body: some View {
        VStack{
             VStack{
                    HStack{
                        Text(loading ? "Loading..." : self.topic)
                            .font(.title)
                            .foregroundColor(Color.black.opacity(0.7))
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                        if loading {
                            ProgressView()
                            .accentColor(.red)
                            .shadow(color: Color(red: 0, green: 0.7, blue: 0),
                                       radius: 5.0, x: 2.0, y: 2.0)
                            .padding(.top)
                        }else{
                            Text(self.error)
                                .foregroundColor(Color.black.opacity(0.7))
                                .padding(.top)
                                .padding(.horizontal, 25 )
                        }
                    Button {
                        self.alert.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width - 120)
                    }
                    .padding(.vertical)
                    .background(Color("FBlack"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                 
                 if guestUser{
                     NavigationLink {
                        Login()
                     } label: {
                         Text("Login")
                             .foregroundColor(.white)
                             .fontWeight(.bold)
                             .frame(width: UIScreen.main.bounds.width - 120)
                     }
                     .padding(.vertical)
                     .background(Color("FPurple"))
                     .cornerRadius(10)
                     .padding(.top, 25)
                 }

                }
                .padding(.vertical, 25)
                .frame(width: UIScreen.main.bounds.width - 70)
                .background(Color.white)
                .cornerRadius(15)

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}


extension View {
    func getRect()-> CGRect {
        return UIScreen.main.bounds
    }
}
