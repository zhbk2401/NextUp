import SwiftUI

struct MainScheduleView: View {
    @StateObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.secondary.opacity(0.2), Color.clear]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            AnimatedGradientView(
                count: 6,
                blurRadius: 80,
                size: 250...400,
                speed: 0.7,
                color: ColorRange(
                    hueRange: 0.5...1.0,
                    saturationRange: 0.2...0.5,
                    brightnessRange: 0.8...1))
                .ignoresSafeArea()
                .opacity(0.3)
            VStack {
                HStack() {
                    Picker("Week", selection: viewModel.$selectedWeek) {
                        Text("c").tag(WeekTypeModel.odd)
                        Text("z").tag(WeekTypeModel.even)
                        Text("Both").tag(WeekTypeModel.both)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Picker("Subgroup", selection: viewModel.$selectedSubgroup) {
                        Text("1").tag(ClassSubgroupModel.first)
                        Text("2").tag(ClassSubgroupModel.second)
                        Text("Both").tag(ClassSubgroupModel.both)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                CarouselView(itemsCount: viewModel.days.count) { index in
                    DayView(viewModel: viewModel.days[index])
                }
                .onAppear {
                    viewModel.loadSchedule()
                }
            }
        }
        }
}

#Preview {
    MainView()
}
