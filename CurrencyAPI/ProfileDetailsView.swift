//
//  ProfileDetailsView.swift
//  CurrencyAPI
//
//  Created by Najd on 30/09/2024.
//

import SwiftUI

struct ProfileDetailsView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var bio: String
    @Binding var education: String
    @Binding var skills: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                    .foregroundColor(Color.appColor)
                    .frame(maxWidth: .infinity)  // Expands to full width
                    .multilineTextAlignment(.center)  // Centers the text

                profileDetail(icon: "person", title: "Name", value: name)
                profileDetail(icon: "envelope", title: "Email", value: email)
                profileDetail(icon: "info.circle", title: "Bio", value: bio)
                profileDetail(icon: "graduationcap", title: "Education", value: education)
                profileDetail(icon: "star", title: "Skills", value: skills)

                Spacer()
            }
            .frame(maxWidth: .infinity)  // Ensure VStack takes the full width of the screen
            .padding(.horizontal, 16)
            .padding(.bottom, 80)        // Add bottom padding to prevent overlap with the tab bar
        }
        .background(Color.gray.opacity(0.05))
        .navigationTitle("Profile")
    }
    
    private func profileDetail(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(Color.appColor)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)  
        .padding(.vertical, 8)
    }
}
