//
//  ContentView.swift
//  BottomSheet
//
//  Created by paige shin on 2022/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var searchText: String = ""
    
    // Gesture Properties...
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
     
    
    var body: some View {
        ZStack {
            
            // For Getting Frame For Image ...
            GeometryReader { proxy in
                let frame = proxy.frame(in: .global)
                
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
                
            }
            .blur(radius: getBlurRadius())
            .ignoresSafeArea()
            
            // For Getting Height For Drag Gesture...
            GeometryReader { proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        
                        BlurView(style: .systemThinMaterialDark)
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        
                        VStack {
                        
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 60, height: 4)
                                .padding(.top)
                            
                            TextField("Search", text: $searchText)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(BlurView(style: .dark))
                                .cornerRadius(10)
                                .colorScheme(.dark)
                                .padding(.top, 10)
                            
                            ScrollView(showsIndicators: false) {
                                
                            }
                            
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                    }
                    .offset(y: height - 100)
                    .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.height
                        onChange()
                    }).onEnded({ value in
                        let maxHeight = height - 100
                        withAnimation {
                            // offset = 0
                            
                            // Logic Conditions For Moving States....
                            // Up down or mid...
                            if -offset > 100 && -offset < maxHeight / 2 {
                                // Mid...
                                offset = -(maxHeight / 3)
                            } else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            } else {
                                offset = 0
                            }
                        }
                        
                        // Storing Last Offset...
                        // So that the gesture can contine from the last position....
                        lastOffset = offset
                        
                    }))
                
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            
        }
    }
    
    private func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    // Blur Radis For BG
    private func getBlurRadius() -> CGFloat {
        let progress: CGFloat = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomCorner: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path: UIBezierPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
    
}

struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        let view: UIView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
