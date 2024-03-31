


import SwiftUI
import Firebase
import FirebaseStorage

let storage = Storage.storage().reference()
let metadata = StorageMetadata()

let ref = Firestore.firestore()



func fetchUser(completion: @escaping (UserModel) -> ()){
    let uid = Auth.auth().currentUser!.uid
    ref.collection("Users").document(uid).getDocument{ (doc, err) in
        guard let user = doc else { return }
        
        let firstname = user.data()?["firstname"] as! String
        let lastname = user.data()?["lastname"] as! String
        let email = user.data()?["email"] as! String
         
        DispatchQueue.main.async {
            completion(UserModel(firstname: firstname, lastname: lastname, email: email))
        }
    }
}
