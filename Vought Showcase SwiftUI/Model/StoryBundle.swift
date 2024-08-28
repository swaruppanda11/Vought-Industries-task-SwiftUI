//
//  StoryBundle.swift
//  Vought Showcase SwiftUI
//
//  Created by Swarup Panda on 28/08/24.
//

import SwiftUI

// making a sample story model
// StoryBundle -> number of stories for each user

struct StoryBundle: Identifiable {
    var id = UUID().uuidString
    var profileName: String
    var profileImage: String
    var isSeen: Bool = false
    var stories: [Story]
}

struct Story: Identifiable {
    var id = UUID().uuidString
    var imageURL: String
}
