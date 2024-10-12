//
//  UserIconView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI

struct UserIconView: View {
    let iconUrl: String?
    
    var body: some View {
        if let iconUrl = iconUrl,
           let url = URL(string: iconUrl) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    blackIconView {
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                                .frame(width: 50)
                            Text("Invalid image URL")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                                .bold()
                        }
                    }
                } else {
                    ProgressView()
                }
            }
        } else {
            blackIconView {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
                    .frame(width: 50)
            }
        }
    }
    
    private func blackIconView<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        Color.gray.opacity(0.2)
            .overlay(content: content)
    }
}

struct SNSsIconView: View {
    let githubID: String?
    let xID: String?
    let otherSNSIDs: [String]
    
    var body: some View {
        HStack(spacing: 22) {
            Link(
                destination: URL(
                    string: "https://github.com/\(githubID ?? "")"
                )!
            ) {
                Image("GitHub", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
            }
            .disabled(githubID == nil)
            .opacity(githubID == nil ? 0.5 : 1)
            .padding(.vertical, 11)
            
            Link(
                destination: URL(
                    string: "https://x.com/\(xID ?? "")"
                )!
            ) {
                Image("X", bundle: .main)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.black)
                    .frame(height: 22)
            }
            .disabled(xID == nil)
            .opacity(xID == nil ? 0.5 : 1)
            .padding(.vertical, 11)
            
            if !otherSNSIDs.isEmpty {
                ForEach(otherSNSIDs, id: \.self) { id in
                    Link(
                        destination: URL(
                            string: id
                        )!
                    ) {
                        Image(systemName: "doc.text")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(height: 22)
                    }
                    .padding(.vertical, 11)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 22, alignment: .trailing)
    }
}
