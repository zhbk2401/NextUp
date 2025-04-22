import SwiftUI

struct AnimatedGradientView: View {
    let count: Int
    let blurRadius: CGFloat
    var size: ClosedRange<CGFloat>
    var speed: CGFloat
    var color: ColorRange
    
    struct CircleItem {
        var color: Color
        var size: CGFloat
        var position: CGPoint
        var speedX: CGFloat
        var speedY: CGFloat
    }
    
    @State private var circles: [CircleItem] = []

    var body: some View {
        ZStack {
            ForEach(circles.indices, id: \.self) { index in
                let circle = circles[index]
                Circle()
                    .fill(circle.color)
                    .frame(width: circle.size, height: circle.size)
                    .position(circle.position)
                    .blur(radius: blurRadius)
            }
        }
        .onAppear {
            setupCircles()
            startAnimationLoop()
        }
    }

    private func setupCircles() {
        circles = (0..<count).map { _ in
            CircleItem(
                color: color.randomColor(),
                size: .random(in: size),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                speedX: .random(in: -speed...speed),
                speedY: .random(in: -speed...speed)
            )
        }
    }

    private func startAnimationLoop() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            for i in circles.indices {
                var circle = circles[i]
                circle.position.x += circle.speedX
                circle.position.y += circle.speedY
                if circle.position.x < 0 || circle.position.x > UIScreen.main.bounds.width {
                    circle.speedX *= -1
                }
                if circle.position.y < 0 || circle.position.y > UIScreen.main.bounds.height {
                    circle.speedY *= -1
                }
                circles[i] = circle
            }
        }
    }
}

struct ColorRange {
    var hueRange: ClosedRange<Double>
    var saturationRange: ClosedRange<Double>
    var brightnessRange: ClosedRange<Double>
    
    func randomColor() -> Color {
            let hue = Double.random(in: hueRange)
            let saturation = Double.random(in: saturationRange)
            let brightness = Double.random(in: brightnessRange)
            return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}
