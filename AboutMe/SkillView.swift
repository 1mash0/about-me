//
//  SkillView.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import SwiftUI

struct SkillView: View {
    let skills: [String]
    
    var body: some View {
        FlowLayout(alignment: .leading, spacing: 0) {
            ForEach(skills, id: \.self) { skill in
                SkillTagView(skill: skill)
                    .padding(4)
            }
        }
    }
}

private struct SkillTagView: View {
    let skill: String
    
    var body: some View {
        Text(skill)
            .font(.headline)
            .foregroundStyle(.secondary)
            .padding(8)
            .background(Color(uiColor: .secondarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
