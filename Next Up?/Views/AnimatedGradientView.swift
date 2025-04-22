import SwiftUI

struct AnimatedgeadientView: View {
    struct CircleItem {
        var color: Color
        var size: CGFloat
        var position: CGPoint
        var speedX: CGFloat
        var speedY: CGFloat
    }
    
    @State private var circles: [CircleItem] = (0..<6).map { _ in
        CircleItem(
            color: Color(hue: .random(in: 0.5...1), saturation: 0.5, brightness: 1),
            size: .random(in: 200...500),
            position: CGPoint(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height)),
            speedX: .random(in: -0.5...0.5),
            speedY: .random(in: -0.5...0.5)
        )
    }

    var body: some View {
        ZStack {
            ForEach(circles.indices, id: \.self) { index in
                let circle = circles[index]
                Circle()
                    .fill(circle.color.opacity(0.4))
                    .frame(width: circle.size, height: circle.size)
                    .position(circle.position)
                    .blur(radius: 100) // Soft blur effect
                    .onAppear {
                        animateCircle(index: index)
                    }
            }
        }
    }
    
    private func animateCircle(index: Int) {
        // Update the position of the circles every frame smoothly
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            var circle = circles[index]

            // Update positions based on speed
            circle.position.x += circle.speedX
            circle.position.y += circle.speedY

            // Bounce the circle off the edges of the screen
            if circle.position.x < 0 || circle.position.x > UIScreen.main.bounds.width {
                circle.speedX *= -1
            }
            if circle.position.y < 0 || circle.position.y > UIScreen.main.bounds.height {
                circle.speedY *= -1
            }

            // Save the updated circle
            circles[index] = circle
        }
    }
}
