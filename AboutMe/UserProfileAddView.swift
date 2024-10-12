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
    
    @State var iconUrl: String?
    @State var name: String?
    @State var nickname: String?
    @State var githubID: String?
    @State var xID: String?
    @State var otherLinks: [String] = []
    @State var about: String?
    @State var skills: [String] = []
    @State var portfolios: [String] = []
    
    @State private var showIconDialog = false
    
    private var isFormInvalid: Bool {
        name?.isEmpty ?? true || about?.isEmpty ?? true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // MARK: Icon
                VStack(alignment: .center) {
                    Button {
                        self.showIconDialog = true
                    } label: {
                        UserIconView(iconUrl: iconUrl)
                    }
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .confirmationDialog(
                        "アイコン画像の変更",
                        isPresented: $showIconDialog,
                        titleVisibility: .visible
                    ) {
                        Button("X から取得") {
                            // Xからアイコン画像を取得する処理
                            self.showIconDialog = false
                        }.disabled(xID == nil)
                        
                        Button("GitHub から取得") {
                            // GitHubからアイコン画像を取得する処理
                            self.showIconDialog = false
                            iconUrl = "https://avatars.githubusercontent.com/u/52849416?v=4"
                        }.disabled(githubID == nil)
                        
                        Button("削除", role: .destructive) {
                            self.showIconDialog = false
                            iconUrl = nil
                        }
                    }
                }
                .padding()
                
                // MARK: Name
                VStack(alignment: .leading, spacing: 16) {
                    VStack(spacing: 2) {
                        TextField("Enter Your Name", text: Binding(
                            get: { name ?? "" },
                            set: { name = $0.isEmpty ? nil : $0 }
                        ))
                        .bold()
                        .font(.title)
                        Divider()
                            .frame(height: 0.5)
                            .background((name?.isEmpty) ?? true ? .red : .black)
                    }
                    
                    VStack(spacing: 2) {
                        TextField("Enter Your Nickname", text: Binding(
                            get: { nickname ?? "" },
                            set: { nickname = $0.isEmpty ? nil : $0 }
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
                                get: { githubID ?? "" },
                                set: { githubID = $0.isEmpty ? nil : $0 }
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
                                get: { xID ?? "" },
                                set: { xID = $0.isEmpty ? nil : $0 }
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
                            text: Binding(
                                get: { about ?? "" },
                                set: { about = $0.isEmpty ? nil : $0 }
                            ),
                            axis: .vertical
                        )
                        .font(.headline)
                        Divider()
                            .frame(height: 0.5)
                            .background((about?.isEmpty) ?? true ? .red : .black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: Skills
                VStack(alignment: .leading, spacing: 10) {
                    Text("Skills")
                        .font(.largeTitle)
                        .bold()
                    
                    if !skills.isEmpty {
                        SkillView(skills: skills.map({ $0 }))
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
                    
                    if !portfolios.isEmpty {
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
                            ForEach(portfolios, id: \.self) { portfolio in
                                VStack(spacing: 0) {
                                    Color.gray
                                        .aspectRatio(1.7, contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    Text(portfolio)
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
                    let user: User = .init(
                        userId: UUID(),
                        iconUrl: iconUrl,
                        name: name!,
                        nickname: nickname,
                        githubID: githubID,
                        xID: xID,
                        otherLinks: [],
                        about: about!,
                        skills: [],
                        portfolios: []
                    )
                    modelContext.insert(user)
                    do {
                        try modelContext.save()
                    } catch {
                        modelContext.rollback()
                    }
                    
                    dismiss()
                }.disabled(isFormInvalid)
            }
        }
    }
}

#Preview {
    UserProfileAddView()
}


