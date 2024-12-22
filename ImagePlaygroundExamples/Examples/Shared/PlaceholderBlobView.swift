//
//  PlaceholderBlobView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/21/24.
//

import SwiftUI

#Preview { PlaceholderBlobView() }

// Just a fun animating view - it's totally unnecessary eye candy
struct PlaceholderBlobView: View {
    let referenceDate: Date = .now
    
    @State private var mainPosition: CGPoint = .zero
    @State private var positions: [CGPoint] = []
    
    private let blurRadius = 10.0
    private let alphaThreshold = 0.875
    private let circleCount = 20
    
    @State private var hueRotation = 0.0
   let timer = Timer.publish(every: 0.0167, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Color.green
            .brightness(0.45)
        .mask {
            TimelineView(.animation(minimumInterval: 0.75)) { timeline in
                let currentDate = timeline.date.timeIntervalSinceReferenceDate
                let randomSeed = Int(currentDate / 0.75)
                
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    Canvas { context, canvasSize in
                        guard positions.count > 0 else { return }
                        let circles = (0...positions.count-1).map { tag in
                            context.resolveSymbol(id: tag)!
                        }
                        context.addFilter(.alphaThreshold(min: alphaThreshold))
                        context.addFilter(.blur(radius: blurRadius))
                        context.drawLayer { context2 in
                            circles.forEach { circle in
                                context2.draw(circle,
                                              at: .init(x: canvasSize.width/2,
                                                        y: canvasSize.height/2)
                                )
                            }
                        }
                    } symbols: {
                        ForEach(positions.indices, id: \.self) { id in
                            Circle()
                                .frame(width: id == 0 ? size.width/4 - blurRadius/alphaThreshold : size.width/4)
                                .offset(x: id == 0 ? mainPosition.x : positions[id].x,
                                        y: id == 0 ? mainPosition.y : positions[id].y)
                                .tag(id)
                        }
                    }
                    .onChange(of: randomSeed) { _, _ in
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            mainPosition = randomPosition(in: size, circleSize: .init(width: size.width/4, height: size.width/4))
                            positions = (0..<circleCount).map { _ in
                                randomPosition(in: size, circleSize: .init(width: size.width/2, height: size.width/2))
                            }
                        }
                    }
                    .onAppear {
                        positions = Array(repeating: .zero, count: circleCount)
                        
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            mainPosition = randomPosition(in: size, circleSize: .init(width: size.width/4, height: size.width/4))
                            positions = positions.map { _ in
                                randomPosition(in: size, circleSize: .init(width: size.width/2, height: size.width/2))
                            }
                        }
                    }
                }

            }
        }
        .shadow(color: .green, radius: 16, x: -4, y: -2)
        .hueRotation(.degrees(hueRotation))
        .onReceive(timer) { _ in
            hueRotation = (hueRotation + 1).truncatingRemainder(dividingBy: 360)
        }
    }
    
    func value(in range: ClosedRange<Float>, offset: Float, timeScale: Float, t: TimeInterval) -> Float {
        let amp = (range.upperBound - range.lowerBound) * 0.5
        let midPoint = (range.lowerBound + range.upperBound) * 0.5
        return midPoint + amp * sin(timeScale * Float(t) + offset)
    }
    
    func randomPosition(in bounds: CGSize, circleSize: CGSize) -> CGPoint {
        let xRange = circleSize.width / 2 ... bounds.width - circleSize.width / 2
        let yRange = circleSize.height / 2 ... bounds.height - circleSize.height / 2
        
        let randomX = CGFloat.random(in: xRange)
        let randomY = CGFloat.random(in: yRange)
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let offsetX = randomX - center.x
        let offsetY = randomY - center.y
        
        return CGPoint(x: offsetX, y: offsetY)
    }
}
