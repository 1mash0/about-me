//
//  Item.swift
//  AboutMe
//
//  Created by 今末 翔太 on 2024/10/12.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) private(set) var userId: UUID
    
    var iconUrl: String?
    
    var name: String
    var nickname: String?
    
    var githubID: String?
    var xID: String?
    
    var otherLinks: [OtherLink]
    
    var about: String
    
    var skills: [Skill]
    
    var portfolios: [Portfolio]
    
    init(
        userId: UUID = UUID(),
        iconUrl: String?,
        name: String,
        nickname: String?,
        githubID: String?,
        xID: String?,
        otherLinks: [OtherLink],
        about: String,
        skills: [Skill],
        portfolios: [Portfolio]
    ) {
        self.userId = userId
        self.iconUrl = iconUrl
        self.name = name
        self.nickname = nickname
        self.githubID = githubID
        self.xID = xID
        self.otherLinks = otherLinks
        self.about = about
        self.skills = skills
        self.portfolios = portfolios
    }
    
    convenience init () {
        self.init(
            iconUrl: nil,
            name: "",
            nickname: nil,
            githubID: nil,
            xID: nil,
            otherLinks: [],
            about: "",
            skills: [],
            portfolios: []
        )
    }
}

struct Skill: Codable, Hashable {
    private(set) var order: Int
    var name: String
    
    init(
        order: Int,
        name: String
    ) {
        self.order = order
        self.name = name
    }
}

struct Portfolio: Codable, Hashable {
    var url: String
    var title: String
    
    init(
        url: String,
        title: String
    ) {
        self.url = url
        self.title = title
    }
}

struct OtherLink: Codable, Hashable {
    var link: String
    
    init(
        link: String
    ) {
        self.link = link
    }
}
