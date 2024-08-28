//
//  StoryView.swift
//  Vought Showcase SwiftUI
//
//  Created by Swarup Panda on 28/08/24.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var storyData: StoryViewModel
    var body: some View {
        if storyData.showStory {
            TabView(selection: $storyData.currentStory) {
                // adding the stories
                ForEach($storyData.stories){ $bundle in
                    StoryCardView(bundle: $bundle)
                        .environmentObject(storyData)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            
            // creating the transition from bottom to top
            .transition(.move(edge: .bottom))
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StoryCardView: View {
    
    @Binding var bundle: StoryBundle
    @EnvironmentObject var storyData: StoryViewModel
    
    var body: some View {
        
        // 3D rotation between two stories
        GeometryReader{ proxy in
            ZStack {
                
                Image(bundle.stories[0].imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // close button to dismiss the story
            .overlay(
                Button(action: {
                    withAnimation {
                        storyData.showStory = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                })
                .padding()
                ,alignment: .topTrailing
            )
            
            // Rotation
            .rotation3DEffect(
                getAngle(proxy: proxy),
                axis: (x: 0, y: 1, z: 0),
                anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                anchorZ: 2.5)
        }
    }
    
    func getAngle(proxy: GeometryProxy) -> Angle {
        
        // converting Offset into 45 degree rotaion
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        
        return Angle(degrees: Double(degrees))
    }
}
