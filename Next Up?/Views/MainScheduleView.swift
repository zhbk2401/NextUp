import SwiftUI

struct MainScheduleView: View {
    @StateObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        ZStack {
            AnimatedGradientView(
                count: 6,
                blurRadius: 80,
                size: 250...400,
                speed: 1,
                color: ColorRange(
                    hueRange: 0.5...1.0,
                    saturationRange: 0.2...0.5,
                    brightnessRange: 0.8...1))
                .ignoresSafeArea()
                .opacity(0.3)
            VStack (spacing: 0) {
                VStack (spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(maxWidth: .infinity)
                        HStack(spacing: 10) {
                            Image(systemName: "graduationcap.fill")
                            Text(viewModel.selectedGroup)
                                .font(.system(size: 20, weight: .bold))
                                .lineLimit(1)
                        }
                            .frame(maxWidth: .infinity)
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Image(systemName: "gear")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    HStack() {
                        Picker("Week", selection: $viewModel.selectedWeek) {
                            Text("Чис.").tag(WeekTypeModel.weekC)
                            Text("Знам.").tag(WeekTypeModel.weekZ)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        .onChange(of: viewModel.selectedWeek) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        Spacer()
                        Picker("Subgroup", selection: $viewModel.selectedSubgroup) {
                            Text("I Підг.").tag(ClassSubgroupModel.subgroupOne)
                            Text("II Підг.").tag(ClassSubgroupModel.subgroupTwo)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        .onChange(of: viewModel.selectedSubgroup) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                .padding(.top, -10)
                .background(.ultraThinMaterial)
                Rectangle()
                    .fill(.secondary.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 1)
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .blur(radius: 5)
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
    MainScheduleView()
}
