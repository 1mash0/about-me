//
//  ContentView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI
import SwiftData

func ??<T: Sendable>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(get: { lhs.wrappedValue ?? rhs }, set: { lhs.wrappedValue = $0 })
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var isEditMode: Bool = false
    @State private var showDebugSheet = false
    
    @Query private var users: [User]
    
    @State private var showIconDialog = false
    
    @State private var inputName: String = ""
    
    var body: some View {
        NavigationStack {
            if let user = users.first(where: { $0.isSelf }) {
                ScrollView {
                    if !isEditMode {
                        UserProfileView(user: user)
                    } else {
                        UserProfileEditView(user: user)
                    }
                }
                .toolbar {
                    if isEditMode {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("cancel") {
                                modelContext.rollback()
                                isEditMode.toggle()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button(isEditMode ? "Done" : "Edit") {
                            if (isEditMode) {
                                do {
                                    try modelContext.save()
                                } catch {
                                    modelContext.rollback()
                                }
                            }
                            isEditMode.toggle()
                        }
                        .disabled(isEditMode && (user.name.isEmpty || user.about.isEmpty))
                    }
                }
                
            } else {
                ContentUnavailableView {
                    Label("No Item", systemImage: "tray")
                } actions: {
                    NavigationLink("追加する", destination: UserProfileAddView(user: .init()))
                }
            }
        }
    }
}

#Preview {
    let userConfig = ModelConfiguration(for: User.self, isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: User.self, configurations: userConfig)
    
    let uuid = UUID()
    
    let user: User = .init(
        userId: uuid,
        iconUrl: "https://avatars.githubusercontent.com/u/52849416?v=4",
        name: "Shota Imasue",
        nickname: "1mash0",
        githubID: "1mash0",
        xID: "1mash0_",
        otherLinks:  [
            .init(
                link: "https://qiita.com/1mash0"
            )
        ],
        about: "自己紹介〜",
        skills: [
            "iOS","Swift","Objective-C","UIKit","SwiftUI",
            "Dart","Flutter","Python","Flask",
        ].enumerated().map { (index, name) in
                .init(order: index, name: name)
        },
        portfolios: [],
        isSelf: true
    )
    
    container.mainContext.insert(user)
    
    return ContentView()
        .modelContainer(container)
}
