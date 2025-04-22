import Foundation

struct DayModel: Identifiable {
    let id = UUID()
    let day: DayTypeModel
    var classes: [ClassModel]
    
    init () {
        day = .monday
        classes = []
    }
    
    init (day: DayTypeModel, classes: [ClassModel]) {
        self.day = day
        self.classes = classes
    }
}
