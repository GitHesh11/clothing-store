

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var login = LoginModel(email: "", pass: "")
    @Published var message = ErrorMessageModel(alert: false, error: "", topic: "Error", isLoading: false, guestUser: false)
    @AppStorage("current_status") var status = false
    let defaults = UserDefaults.standard
    
    func verify(){
        if self.login.email != "" && self.login.pass != "" {
            loginWithEmail();
        } else {
            self.message.error = "Please Fill the all the Fields properly"
            self.message.alert.toggle()
        }
    }
    
    func loginWithEmail(){
        self.message.alert.toggle()
        self.message.isLoading = true
        Auth.auth().signIn(withEmail: self.login.email, password: self.login.pass) { (res , err)  in
            if err != nil {
                self.message.isLoading = false
                self.message.error = err!.localizedDescription
            }else{
                
                fetchUser() { userDetails in
                    self.defaults.setValue(userDetails.firstname, forKey: "userfirstName")
                    self.defaults.setValue(userDetails.lastname, forKey: "userlastName")
                    self.defaults.setValue(userDetails.email, forKey: "userEmail")
                    self.message.alert.toggle()
                    self.message.isLoading = false
                    self.status = true
                }

            }
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            self.status = false
            print("User logged out successfully.")
            // Navigate to the login screen or perform any other action after logout
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
}
