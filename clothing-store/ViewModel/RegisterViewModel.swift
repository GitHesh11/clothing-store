
import SwiftUI
import Firebase

class RegisterViewModel: ObservableObject {
    @Published var register : RegisterModel
    @Published var message = ErrorMessageModel(alert: false, error: "", topic: "Error", isLoading: false, guestUser: false)
    @Published var visible = false
    @Published var revisible = false
    @AppStorage("current_status") var status = false

    let ref = Firestore.firestore()
    
    init(){
        register = RegisterModel(firstname: "", lastname: "", email: "", pass: "", repass: "")
    }
    
    func verifyRegistration(){
  
        if self.register.firstname != "" && self.register.lastname != "" && self.register.email != "" && self.register.pass != "" && self.register.repass != "" {
            if self.register.pass == self.register.repass {
                createNewAccount()
            }else{
                    self.message.error = "Password mismatch"
                    self.message.alert.toggle()
            }
        } else {
            self.message.error = "Please Fill the all the Fields properly"
            self.message.alert.toggle()
        }
    }

    
    func createNewAccount(){
        self.message.alert.toggle()
        self.message.isLoading = true
        Auth.auth().createUser(withEmail: self.register.email, password: self.register.pass) { (res , err)  in
            if err != nil {
                self.message.isLoading = false
                self.message.error = err!.localizedDescription
            }else{
                let uid = res?.user.uid
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = dateFormatter.string(from: Date())
                
                
                self.ref.collection("Users").document(uid!).setData([
                    "uid" : uid as Any,
                    "firstname" : self.register.firstname,
                    "lastname" :self.register.lastname,
                    "email" : self.register.email,
                    "dateCreated" : dateString
                    
                ]) { (err) in
                    if err != nil {
                        self.message.isLoading = false
                        self.message.error = err!.localizedDescription
                    }else{
                        self.message.isLoading = false
                        self.message.topic = "Success"
                        self.message.error = "Registered Successfully"
                        self.register = RegisterModel(firstname: "", lastname: "", email: "", pass: "", repass: "")
                    }
                }
            }
        }
    }
}





