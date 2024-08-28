//
//  Home.swift
//  Vought Showcase SwiftUI
//
//  Created by Swarup Panda on 27/08/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject var storyData = StoryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack(spacing: 12) {
//                        Button {
//                            
//                        } label: {
//                            Image("logo")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 50, height: 50)
//                                .clipShape(Circle())
//                            
//                        }
//                        .padding(.trailing, 10)
                        
                        ForEach($storyData.stories) { $bundle in
                            ProfileView(bundle: $bundle)
                                .environmentObject(storyData)
                        }
                    }
                    .padding()
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Vought Showcase")
        }
        .overlay(
            StoryView()
                .environmentObject(storyData)
        )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct ProfileView: View {
    
    @Binding var bundle: StoryBundle
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var storyData: StoryViewModel

    
    var body: some View {
        Image(bundle.profileImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding(2)
            .background(scheme == .dark ? .black : .white, in: Circle())
            .padding(2)
            .background(
                LinearGradient(colors: [
                    .red,
                    .orange,
                    .red,
                    .orange
                ],
                startPoint: .top,
                endPoint: .bottom)
                .clipShape(Circle())
                .opacity(bundle.isSeen ? 0 : 1)
            )
            .onTapGesture {
                withAnimation {
                    bundle.isSeen = true
                    
                    // Saving current Bundle and toggling story
                    storyData.currentStory = bundle.id
                    storyData.showStory = true
                }
            }
    }
}

