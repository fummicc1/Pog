//
//  AuthClient.swift
//  Count
//
//  Created by Fumiya Tanaka on 2019/10/05.
//  Copyright © 2019 app.tanaka.fummicc1. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

protocol AuthRepository {
    
    var currentUser: User? { get }
    var myRef: DocumentReference? { get }
    
    func createUser(email: String, password: String)
    func deleteUser()
    func signIn(email: String, password: String)
    func signInAnonymously(completion: @escaping (Error?) -> ())
    func signOut()
    func sendEmailVerification()
    func listenStateChange(completion: @escaping (Auth, User?) -> ())
}

class AuthClient: AuthRepository {
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    var myRef: DocumentReference? {
        if let currentUser = currentUser {
            return Firestore.firestore().collection(FirestoreCollcetionName.users.rawValue).document(currentUser.uid)
        }
        return nil
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func deleteUser() {
        currentUser?.delete(completion: nil)
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signInAnonymously(completion: @escaping (Error?) -> ()) {
        Auth.auth().signInAnonymously { (result, error) in
            completion(error)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func sendEmailVerification() {
        currentUser?.sendEmailVerification(completion: nil)
    }
    
    func listenStateChange(completion: @escaping (Auth, User?) -> ()) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            completion(auth, user)
        }
    }
}
