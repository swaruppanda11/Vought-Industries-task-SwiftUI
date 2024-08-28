//
//  StoryViewModel.swift
//  Vought Showcase SwiftUI
//
//  Created by Swarup Panda on 28/08/24.
//

import SwiftUI

class StoryViewModel: ObservableObject {
    
    // List of stories
    @Published var stories: [StoryBundle] = [
        
        StoryBundle(profileName: "Seven", profileImage: "seven", stories: [
            Story(imageURL: "a_train"),
            Story(imageURL: "black_noir"),
            Story(imageURL: "homelander"),
            Story(imageURL: "maeve")
        ]),
        
        StoryBundle(profileName: "Boys", profileImage: "boys", stories: [
            Story(imageURL: "butcher"),
            Story(imageURL: "frenchie"),
            Story(imageURL: "hughei"),
            Story(imageURL: "mm")
        ])
    ]
    
    // properties of the story
    @Published var showStory: Bool = false
    
    // will be unique story bundle id
    @Published var currentStory: String = ""
}
