//
//  MainTabView.swift
//  CurrencyAPI
//
//  Created by Najd on 30/09/2024.
//

import SwiftUI

struct MainTabView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var bio: String
    @Binding var education: String
    @Binding var skills: String
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView() // Home
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ProfileDetailsView(name: $name, email: $email, bio: $bio, education: $education, skills: $skills)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(1)
        }
        .accentColor(Color.appColor)
        .background(Color.white)
    }
    
}
