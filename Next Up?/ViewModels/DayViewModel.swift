import Foundation

class DayViewModel: ObservableObject, Identifiable {
    @Published var selectedWeek: WeekTypeModel
    @Published var selectedSubgroup: SubgroupTypeModel
    
    private let model: DayModel

    var id: UUID { model.id }
    var dayText: String { model.day.rawValue }
    var allClasses: [ClassViewModel] { model.classes.map(ClassViewModel.init)}
    var activeClasses: [ClassViewModel] {
        allClasses.filter {
            ($0.weekType == .both || $0.weekType == selectedWeek) &&
            ($0.subgroupType == .both || $0.subgroupType == selectedSubgroup)
        }
    }
    
    init(model: DayModel, selectedWeek: WeekTypeModel, selectedSubgroup: SubgroupTypeModel) {
        self.model = model
        self.selectedWeek = selectedWeek
        self.selectedSubgroup = selectedSubgroup
    }
}
