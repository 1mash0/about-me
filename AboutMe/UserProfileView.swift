//
//  UserProfileView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.modelContext) private var modelContext
    
    let user: User
    
    @State private var debug_showDialog: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Icon
            VStack(alignment: .center) {
                UserIconView(iconUrl: user.iconUrl)
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
            }
            .padding()
            
            VStack(spacing: 0) {
                // MARK: Name
                VStack(alignment: .leading) {
                    Text(user.name)
                        .bold()
                        .font(.title)
                    
                    if let nickname = user.nickname, !nickname.isEmpty {
                        Text(nickname)
                            .bold()
                            .font(.title3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: SNS
                SNSsIconView(
                    githubID: user.githubID,
                    xID: user.xID,
                    otherSNSIDs: user.otherLinks.map({
                        $0.link
                    })
                )
            }
            
            VStack(spacing: 22) {
                
                // MARK: About
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(user.about)
                        .font(.headline)
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
            
            Spacer(minLength: 120)
            Button("削除する", role: .destructive) {
                debug_showDialog = true
            }
            .confirmationDialog(
                "プロフィールを削除しますか？",
                isPresented: $debug_showDialog,
                titleVisibility: .visible
            ) {
                Button("削除する", role: .destructive) {
                    self.debug_showDialog = false
                    
                    modelContext.delete(user)
                    
                    do {
                        try modelContext.save()
                    } catch {
                        modelContext.rollback()
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
    }
}
