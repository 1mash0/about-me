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
    
    @State private var showIconDialog = false
    
    private var isFormInvalid: Bool {
        user.name.isEmpty || user.about.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // MARK: Icon
                VStack(alignment: .center) {
                    Button {
                        self.showIconDialog = true
                    } label: {
                        UserIconView(iconUrl: user.iconUrl)
                    }
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .confirmationDialog(
                        "アイコン画像の変更",
                        isPresented: $showIconDialog,
                        titleVisibility: .visible
                    ) {
                        Button("GitHub から取得") {
                            // TODO: GitHubからアイコン画像を取得する処理
                            self.showIconDialog = false
                            user.iconUrl = "https://avatars.githubusercontent.com/u/52849416?v=4"
                        }.disabled(user.githubID == nil)
                        
                        Button("X から取得") {
                            // TODO: Xからアイコン画像を取得する処理
                            self.showIconDialog = false
                            user.iconUrl = "https://avatars.githubusercontent.com/u/52849416?v=4"
                        }.disabled(user.xID == nil)
                        
                        Button("削除", role: .destructive) {
                            self.showIconDialog = false
                            user.iconUrl = nil
                        }
                    }
                }
                .padding()
                
                // MARK: Name
                VStack(alignment: .leading, spacing: 16) {
                    VStack(spacing: 2) {
                        TextField("Enter Your Name", text: $user.name)
                        .bold()
                        .font(.title)
                        Divider()
                            .frame(height: 0.5)
                            .background(user.name.isEmpty ? .red : .black)
                    }
                    
                    VStack(spacing: 2) {
                        TextField("Enter Your Nickname", text: Binding(
                            get: { user.nickname ?? "" },
                            set: { user.nickname = $0.isEmpty ? nil : $0 }
                        ))
                        .bold()
                        .font(.title3)
                        Divider()
                            .frame(height: 0.5)
                            .background(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image("GitHub", bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                        VStack(spacing: 2) {
                            TextField("Enter your Github ID", text: Binding(
                                get: { user.githubID ?? "" },
                                set: { user.githubID = $0.isEmpty ? nil : $0 }
                            ))
                            .bold()
                            .font(.headline)
                            Divider()
                                .frame(height: 0.5)
                                .background(.black)
                        }
                    }
                    HStack(spacing: 8) {
                        Image("X", bundle: .main)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(height: 22)
                        VStack(spacing: 2) {
                            TextField("Enter your X ID", text: Binding(
                                get: { user.xID ?? "" },
                                set: { user.xID = $0.isEmpty ? nil : $0 }
                            ))
                            .bold()
                            .font(.headline)
                            Divider()
                                .frame(height: 0.5)
                                .background(.black)
                        }
                    }
                }
                
                // MARK: About
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(spacing: 2) {
                        TextField(
                            "Enter Self-introduction",
                            text: $user.about,
                            axis: .vertical
                        )
                        .font(.headline)
                        Divider()
                            .frame(height: 0.5)
                            .background(user.about.isEmpty ? .red : .black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: Skills
                VStack(alignment: .leading, spacing: 10) {
                    Text("Skills")
                        .font(.largeTitle)
                        .bold()
                    
                    if !user.skills.isEmpty {
                        SkillView(skills: user.skills.map({ $0.name }))
                    } else {
                        ContentUnavailableView {
                            Text("No Skill")
                                .bold()
                        } actions: {
                            Button("追加する") {
                                print("transition add skill page")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: Portfolio
                VStack(alignment: .leading, spacing: 10) {
                    Text("Portfolio")
                        .font(.largeTitle)
                        .bold()
                    
                    if !user.portfolios.isEmpty {
#if os(iOS)
                        let count = 2
#else
                        let count = 3
#endif
                        
                        let grids = Array(
                            repeating: GridItem(spacing: 14),
                            count: count
                        )
                        LazyVGrid(columns: grids, spacing: 16) {
                            ForEach(user.portfolios, id: \.self) { portfolio in
                                VStack(spacing: 0) {
                                    Color.gray
                                        .aspectRatio(1.7, contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    Text(portfolio.title)
                                        .font(.headline)
                                }
                            }
                        }
                    } else {
                        ContentUnavailableView {
                            Text("No Portfolio")
                                .bold()
                        } actions: {
                            Button("追加する") {
                                print("transition add portfolio page")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
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


