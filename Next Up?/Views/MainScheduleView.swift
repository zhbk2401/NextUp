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
                
                if viewModel.isLoading {
                    ProgressView("Завантаження...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack (spacing: 10) {
                        Text("Помилка!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Button("Викор. останні дані") {

                            }
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.secondary)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.secondary.opacity(0.7), lineWidth: 1)
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.secondary.opacity(0.3), lineWidth: 1)
                                    .blur(radius: 5)
                            }
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
                            
                            Button("Спробувати знову") {
                                viewModel.loadSchedule()
                            }
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                            .padding()
                            .background(.quaternary)
                            .cornerRadius(20)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.secondary.opacity(0.2), lineWidth: 1)
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.secondary.opacity(0.3), lineWidth: 1)
                                    .blur(radius: 5)
                            }
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    CarouselView(itemsCount: viewModel.days.count) { index in
                        DayView(viewModel: viewModel.days[index])
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadSchedule()
        }
    }
}

#Preview {
    MainScheduleView()
}
