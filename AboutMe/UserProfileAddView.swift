//
//  UserProfileAddView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI

struct UserProfileAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var user: User
    
    private var isFormInvalid: Bool {
        user.name.isEmpty || user.about.isEmpty
    }
    
    var body: some View {
        UserProfileFormView(user: user)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    addUser()
                }.disabled(isFormInvalid)
            }
        }
    }
    
    private func addUser() {
        modelContext.insert(user)
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
        
        dismiss()
    }
}

#Preview {
    UserProfileAddView(user: .init())
}


