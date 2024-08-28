//
//  StoryView.swift
//  Vought Showcase SwiftUI
//
//  Created by Swarup Panda on 28/08/24.
//

import SwiftUI

struct CarouselViewController: View {
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
    
    // adding the timer for the segmented progress bar and changing the stories based on the timer
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // progress
    @State var timerProgress: CGFloat = 0
    
    var body: some View {
        
        // 3D rotation between two stories
        GeometryReader{ proxy in
            ZStack {
                
                // Getting the current index
                // and updating the story accordingly
                let index = min(Int(timerProgress), bundle.stories.count - 1)
                let story = bundle.stories[index]
                Image(story.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // adding tap gesture to move back and forth
            .overlay(
                HStack {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            
                            // Checking and updating to the previous
                            if (timerProgress - 1) < 0 {
                                updateStory(forward: false)
                            } else {
                                timerProgress = CGFloat(Int(timerProgress - 1))
                            }
                        }
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            
                            // Checking and updating to next
                            if (timerProgress + 1) > CGFloat(bundle.stories.count) {
                                // update to the image
                                updateStory()
                            } else {
                                // update to next story
                                timerProgress = CGFloat(Int(timerProgress + 1))
                            }
                            
                        }
                }
            )
            
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
            
            // segmented progress bar
            .overlay(
                HStack(spacing: 5) {
                    ForEach(bundle.stories.indices) { index in
                        
                        GeometryReader{ proxy in
                            let width = proxy.size.width
                            
                            // getting progress by eliminating current index with progress
                            // so that the remaining segments don't start animating when the previous one is loading
                            // setting max to 1
                            // min to 0
                            let progress = timerProgress - CGFloat(index)
                            let perfectProgress = min(max(progress, 0), 1)
                            
                            Capsule()
                                .fill(.gray.opacity(0.5))
                                .overlay(
                                    Capsule().fill(.white)
                                        .frame(width: width * perfectProgress)
                                    ,alignment: .leading
                                )
                        }
                    }
                }
                .frame(height: 1.4)
                .padding(.horizontal)
                ,alignment: .top
            )
            
            // Rotation
            .rotation3DEffect(
                getAngle(proxy: proxy),
                axis: (x: 0, y: 1, z: 0),
                anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                anchorZ: 2.5)
        }
        
        // Resetting timer everytime the story is appearing
        .onAppear(perform: {
            timerProgress = 0
        })
         
        .onReceive(timer) { _ in
            // Updating Seen Status in real time
            if storyData.currentStory == bundle.id {
                if !bundle.isSeen {
                    bundle.isSeen = true
                }
                
                // updating the timer
                if timerProgress < CGFloat(bundle.stories.count) {
                    timerProgress += 0.03
                } else {
                    updateStory()
                }
            }
        }
    }
    
    // updating the last image of the story to the next story
    func updateStory(forward: Bool = true) {
        let index = min(Int(timerProgress), bundle.stories.count - 1)
        let story = bundle.stories[index]
        
        // if it is not the first picture of the story, then move backwards
        // otherwise just set the timer to 0
        if !forward {
            if let first = storyData.stories.first, first.id != bundle.id {
                // getting the index
                let bundleIndex = storyData.stories.firstIndex { currentBundle in
                    return bundle.id == currentBundle.id
                } ?? 0
                withAnimation {
                    storyData.currentStory = storyData.stories[bundleIndex - 1].id
                }
            } else {
                timerProgress = 0
            }
        }
        
        // checking if its last
        if let last = bundle.stories.last, last.id == story.id {
            
            // if there's another story, then update to that
            // otherwise close the story view
            if let lastBundle = storyData.stories.last, lastBundle.id == bundle.id {
                withAnimation {
                    storyData.showStory = false
                }
            } else {
                let bundleIndex = storyData.stories.firstIndex { currentBundle in
                    return bundle.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    storyData.currentStory = storyData.stories[bundleIndex + 1].id
                }
            }
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
