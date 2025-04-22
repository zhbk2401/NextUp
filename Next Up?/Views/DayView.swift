import SwiftUI

struct DayView: View {
    @StateObject var viewModel: DayViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text(shortToLongDayName(viewModel.dayText))
                .font(.system(size: 26, weight: .bold))
                .opacity(0.4)
            VStack (spacing: 10) {
                ForEach(viewModel.activeClasses) { classVM in
                    ClassCardView(viewModel: classVM)
                        .animation(.bouncy, value: viewModel.selectedSubgroup)
                        .animation(.bouncy, value: viewModel.selectedWeek)
                }
            }
        }
        .animation(.bouncy, value: viewModel.selectedSubgroup)
        .animation(.bouncy, value: viewModel.selectedWeek)
        .padding()
    }
}
