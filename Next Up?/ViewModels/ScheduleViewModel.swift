import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var days: [DayViewModel] = []
    @Published var selectedWeek: WeekTypeModel = .weekC { didSet { updateFilters() } }
    @Published var selectedSubgroup: ClassSubgroupModel = .subgroupTwo { didSet { updateFilters() } }
    @Published var selectedGroup: String = "ПЗ-17" { didSet { loadSchedule() } }

    private func updateFilters() {
        for day in days {
            day.selectedWeek = selectedWeek
            day.selectedSubgroup = selectedSubgroup
        }
    }
    
    public func loadSchedule() {
        ScheduleService.fetchSchedule(group: selectedGroup, semester: 2) { result in
            switch result {
            case .success(let schedule):
                print("✅ Loaded:", schedule.count, "items")
                for day in schedule {
                    self.days.append(DayViewModel(model: day, selectedWeek: self.selectedWeek, selectedSubgroup: self.selectedSubgroup))
                }
            case .failure(let error):
                switch error {
                case .networkError(let msg):
                    print("🚫 Network error:", msg)
                case .parsingError(let msg):
                    print("🚫 Parsing error:", msg)
                }
            }
        }
    }
}
