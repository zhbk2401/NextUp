import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var days: [DayViewModel] = []
    @Published var selectedWeek: WeekTypeModel = .weekC { didSet { updateFilters() } }
    @Published var selectedSubgroup: SubgroupTypeModel = .subgroupTwo { didSet { updateFilters() } }
    @Published var selectedGroup: String = "ПЗ-17" { didSet { loadSchedule() } }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private func updateFilters() {
        for day in days {
            day.selectedWeek = selectedWeek
            day.selectedSubgroup = selectedSubgroup
        }
    }
    
    public func loadSchedule() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                days = []
                let schedule = try await ScheduleService.fetchSchedule(group: selectedGroup, semester: 2)
                await MainActor.run {
                    print("✅ Loaded:", schedule.count, "items")
                    self.days = schedule.map { day in
                        DayViewModel(model: day, selectedWeek: self.selectedWeek, selectedSubgroup: self.selectedSubgroup)
                    }
                    self.isLoading = false
                }
            } catch let error as ErrorModel {
                await MainActor.run {
                    switch error {
                    case .networkError(let msg):
                        self.errorMessage = "Помилка мережі: \(msg)"
                        print("🚫 Network error:", msg)
                    case .parsingError(let msg):
                        self.errorMessage = "Помилка обробки даних: \(msg)"
                        print("🚫 Parsing error:", msg)
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Невідома помилка: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
