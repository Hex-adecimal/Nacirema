//
//  ContentView.swift
//  Nacirema
//
//  Created by Luigi Penza on 14/11/23.
//

import SwiftUI
import SwiftData

//MARK: AnimationPhase
enum ButtonAnimationPhase: CaseIterable {
    case beginnig, middle, end
    
    var scale: Double {
        switch self {
        case .beginnig, .end: 1
        case .middle: 0.9
        }
    }
    
    var animation: Animation {
        switch self {
        case .beginnig, .end: .bouncy(duration: 1.0)
        case .middle: .easeIn(duration: 1.0)
        }
    }
}

enum OuterRingAnimationPhase: CaseIterable {
    case beginning, middle, end
    
    var scale: Double {
        switch self {
        case .beginning: 2.0
        case .middle: 2.5
        case .end: 3.0
        }
    }
    
    var animation: Animation {
        switch self {
        case .beginning, .end: .bouncy(duration: 1.0)
        case .middle: .easeIn(duration: 1.0)
        }
    }
}

struct ContentView: View {
    @State private var isListening: Bool = false
    @State private var textToggle: Bool = false
    
    private let modalHeight: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            //MARK: Background
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.linearGradient(colors: [.purple, .orange], startPoint: .bottom, endPoint: .top))
            
            //MARK: Animation for the audio
            Circle()
            //.fill(.white.opacity(isListening ? 1 : 0))//MARK: DIRTY
                .fill(.clear)
                .strokeBorder(.gray.opacity(isListening ? 0.5 : 0), lineWidth: 1)
                .phaseAnimator(OuterRingAnimationPhase.allCases) { content, phase in
                    content
                        .scaleEffect(phase.scale)
                } animation: { phase in
                    phase.animation
                }
                .offset(x: 0, y: 20)
            
            Circle()
            //.fill(.white.opacity(isListening ? 1 : 0))//MARK: DIRTY
                .fill(.clear)
                .strokeBorder(.gray.opacity(isListening ? 0.5 : 0), lineWidth: 1)
                .phaseAnimator(OuterRingAnimationPhase.allCases) { content, phase in
                    content
                        .scaleEffect(phase.scale*0.85)
                } animation: { phase in
                    phase.animation
                }
                .offset(x: 0, y: 20)
            
            VStack {
                //MARK: Label
                Text(isListening ? " " : (textToggle ? "Hold to Auto Shazam" : "Tap to Shazam"))
                // Vision
                    .bold()
                    .foregroundStyle(.black)
                    .font(.title2)
                // Accessibility
                    .accessibilityHidden(true)
                // Animation
                    .onAppear {
                        // Schedule a timer to toggle the boolean every 2 seconds
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                            //TODO: Animation like a dice to up
                            withAnimation() {
                                textToggle.toggle()
                            }
                        }
                    }
                
                //MARK: SHAZAM BUTTON
                CircleAndLinks()
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        //MARK: Listening ...
                        isListening.toggle()
                        Task {
                            if isListening {
                                let viewController = ViewController()
                                await viewController.match()
                            }
                        }
                    }
                //MARK: Button Animation
                    .phaseAnimator(ButtonAnimationPhase.allCases) { content, phase in
                        content
                            .scaleEffect(phase.scale)
                    } animation: { phase in
                        phase.animation
                    }
                //MARK: Haptic feedback
                    .sensoryFeedback(.success, trigger: isListening)
            }
        }
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                ModalView()
            }
            .presentationDetents([.height(modalHeight), .large])
            .interactiveDismissDisabled(true)
            .presentationBackgroundInteraction(.enabled(upThrough: .height(modalHeight)))
        }
    }
}

//For doing the first animation, we have two task to accomplish: Design Shape and Animating
private struct CircleAndLinks: View {
    @State var animating: Bool = false
    
    var body: some View {
        //MARK: In summary, this SwiftUI code creates a ZStack with a background circle having a linear gradient fill and a shadow. Two Link elements, labeled "he" and "her," are positioned in the ZStack with specified trimming ranges and colors. These links are then rotated, and an animation is applied when the ZStack appears.
        
        ZStack {
            // Draw a Circle in the background with a linear gradient fill and a shadow
            Circle()
                .fill(.linearGradient(colors: [.white, .gray], startPoint: .bottomLeading, endPoint: .topTrailing))
                .shadow(radius: 10, y: 10)
            //MARK: Making it for everyone
                .accessibilityLabel("Shazam")
                .accessibilityHint("Tap to listen for a song or hold to auto listen")
            
            // Define the "he" Link with a specified trimming range and color
            let fromTrim: CGFloat = 0.43
            let toTrim: CGFloat = 1
            let he = Link(fromTrim: animating ? fromTrim : fromTrim - 2,
                          toTrim: animating ? toTrim : toTrim - 2.5,
                          color: .purple)
            
            // Define the "her" Link with a specified trimming range and color
            let her = Link(fromTrim: animating ? fromTrim + 1 : fromTrim,
                           toTrim: toTrim,
                           color: .orange)
            
            // Add the "he" Link to the ZStack and apply a rotation effect
            he
            he.rotationEffect(.degrees(180))
            
            // Add the "her" Link to the ZStack and apply a rotation effect
            her
            her.rotationEffect(.degrees(180))
        }
        .onAppear {
            // Apply an animation when the ZStack appears
            withAnimation(.timingCurve(0.65, 0, 0.35, 1, duration: 1)) {
                animating = true
            }
        }
        
    }
}

private struct Link: View {
    //MARK: In summary, this Swift code defines a SwiftUI View called Link that represents a custom-styled link. The link is implemented using a custom shape called NaciremaCapsule, and various modifiers such as rotation, offset, trim, stroke, and frame are applied to achieve the desired appearance. The properties (fromTrim, toTrim, and color) allow for customization of the link's appearance when creating an instance of this view.
    
    let fromTrim: CGFloat
    let toTrim: CGFloat
    let color: Color
    
    var body: some View {
        NaciremaCapsule()
            .rotation(.degrees(-45))
            .offset(x: -7, y: -16)
        //MARK: Trim closed shape in half
            .trim(from: fromTrim, to: toTrim)
        //MARK: Stroke the inside
            .stroke(color, style: .init(lineWidth: 20, lineCap: .round))
        //MARK: Make it smaller
            .frame(width: 90, height: 64)
    }
}

private struct NaciremaCapsule: Shape {
    func path(in rect: CGRect) -> Path {
        //MARK: In summary, this Swift function generates a Path that represents a closed shape consisting of two semicircles connected at the bottom, forming a shape like the top half of a circle. The size and position of the shape are determined by the provided CGRect.
        
        // Create an empty path to which we'll add shapes
        var path = Path()
        
        // Calculate the radius of the semicircle based on the height of the provided rectangle
        let arcRadius = rect.height / 2
        
        // Define the bottom center point of the rectangle
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        
        // Define the trailing and leading points on the horizontal axis
        let trailing = CGPoint(x: rect.maxX, y: rect.midY)
        let leading = CGPoint(x: rect.minX, y: rect.midY)
        
        // Calculate the center points of the arcs on the horizontal axis
        let arcCenterTrailing: CGPoint = CGPoint(x: trailing.x - arcRadius, y: trailing.y)
        let arcCenterLeading: CGPoint = CGPoint(x: leading.x + arcRadius, y: leading.y)
        
        // Move to the bottom center point to start drawing the path
        path.move(to: bottom)
        
        // Add the semicircle on the trailing side
        path.addRelativeArc(center: arcCenterTrailing, radius: arcRadius, startAngle: .degrees(90), delta: .degrees(-180))
        
        // Add the semicircle on the leading side
        path.addRelativeArc(center: arcCenterLeading, radius: arcRadius, startAngle: .degrees(-90), delta: .degrees(-180))
        
        // Close the path to connect the two semicircles and form a closed shape
        path.closeSubpath()
        
        // Return the final path
        return path
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Song.self, configurations: config)

    //let song = Song(image: "Vesuvio", name: "Vesuvio", artist: "New Genea")
    return ContentView()
        .modelContainer(container)
}
