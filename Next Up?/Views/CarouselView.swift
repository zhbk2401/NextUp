import SwiftUI

struct CarouselView<Content: View>: View {
    @State private var selectedIndex = 0
    let itemsCount: Int
    @ViewBuilder let content: (Int) -> Content

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(0..<itemsCount, id: \.self) { index in
                    GeometryReader { geo in
                        let screenWidth = UIScreen.main.bounds.width
                        let distance = abs(geo.frame(in: .global).midX - screenWidth / 2)

                        VStack {
                            content(index)
                                .blur(radius: min(distance / 50, 200))
                                .opacity(1.0 - min(distance / screenWidth, 0.8))
                                .brightness(min(distance / screenWidth / 10.0, 0.1))
                                .scaleEffect(1.0 - min(distance / screenWidth * 0.05, 0.05))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()

            HStack(spacing: 5) {
                ForEach(0..<itemsCount, id: \.self) { index in
                    let myVal = abs(CGFloat(selectedIndex - index) / CGFloat(itemsCount))
                    Capsule()
                        .fill(Color.primary.opacity(selectedIndex == index ? 1 : 0.4))
                        .frame(width: 10 * (1 - myVal), height: 10 * (1 - myVal))
                        .blur(radius: CGFloat(itemsCount) * myVal)
                        .animation(.bouncy, value: selectedIndex)
                }
            }
            .padding()
            .onChange(of: selectedIndex, {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            })
        }
    }
}
