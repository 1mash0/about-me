//
//  UserProfileEditView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI

struct UserProfileEditView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var user: User
    
    @State private var showIconDialog = false
    
    var body: some View {
        UserProfileFormView(user: user)
    }
}
