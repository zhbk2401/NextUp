import Foundation

class ClassViewModel: ObservableObject, Identifiable {
    private let model: ClassModel

    var id: UUID { model.id }
    var name: String { model.name }
    var numberText: String { String(model.number) }
    var locationsText: String { model.locations.joined(separator: ", ") }
    var teachersText: String { model.teachers.joined(separator: ", ") }
    var classTypeText: String { model.classType.rawValue }
    var classHoursText: String {
        switch(model.number) {
        case 1: return "8:30-9:50"
        case 2: return "10:05-11:25"
        case 3: return "11:40-13:00"
        case 4: return "13:15-14:35"
        case 5: return "14:50-16:10"
        default: return""
        } }
    
    var subgroupType: SubgroupTypeModel { model.subgroupType }
    var weekType: WeekTypeModel { model.weekType }
    
    init(model: ClassModel) {
        self.model = model
    }
}
