//
//  ContentView.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-28.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("current_status") var status:Bool = false
    var body: some View {
        NavigationView{
            Group{
                if status{
                    Home()
                }else{
                    Login()
                }
            }
        }

    }
}

#Preview {
    ContentView()
}
