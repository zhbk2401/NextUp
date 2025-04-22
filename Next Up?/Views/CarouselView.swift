import SwiftUI

struct CarouselView: View {
    var days: [DayView]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<days.count, id: \.self) { index in
                    days[index]
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()

            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    Capsule()
                        .fill(Color.secondary.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 35, height: 6)
                        .onTapGesture {
                            selectedImageIndex = index
                        }
                }
            }
        }
    }
}
