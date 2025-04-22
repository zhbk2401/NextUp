import Foundation

struct ClassModel : Identifiable {
    let id = UUID()
    let name: String
    let number: Int
    let locations: [String]
    let teachers: [String]
    let classType: ClassTypeModel
    let subgroupType: ClassSubgroupModel
    let weekType: WeekTypeModel
}
