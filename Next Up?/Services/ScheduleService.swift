import Foundation
import SwiftSoup

class ScheduleService {
    static func fetchSchedule(group: String, semester: Int) async throws -> [DayModel] {
        let url = try generateURL(group: group, semester: semester)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try parseData(data: data)
    }
    
    private static func generateURL(group: String, semester: Int) throws -> URL {
        var components = URLComponents(string: "https://student.lpnu.ua/students_schedule")
        components?.queryItems = [
            URLQueryItem(name: "studygroup_abbrname", value: group),
            URLQueryItem(name: "semestr", value: "\(semester)")
        ]
        guard let url = components?.url else {
            throw ErrorModel.networkError("Invalid URL parameters")
        }
        return url
    }
    
    private static func parseData(data: Data) throws -> [DayModel] {
        var schedule: [DayModel] = []
        var currentDay = DayModel()
        var currentClassNumber = 0
        var currentDayNumber = 0
        let content = try getContentFromData(data: data)
        
        for element in content.children() {
            switch try element.className() {
            case "view-grouping-header": // DAY
                guard let dayType = DayTypeModel(rawValue: try element.text()) else {
                    throw ErrorModel.parsingError("'DayTypeModel' parsing error")
                }
                if (currentDayNumber > 0) {
                    schedule.append(currentDay)
                }
                currentDayNumber += 1
                currentDay = DayModel(day: dayType, classes: [])
                break
            case "stud_schedule": // CLASS
                for row in try element.select("div.views-row") {
                    for classData in row.children() {
                        let newClass = try parseClassData(classData: classData, classNumber: currentClassNumber)
                        currentDay.classes.append(newClass)
                    }
                }
                break
            default: // CLASS NUMBER
                guard let classNumberText = try? element.text(),
                    let classNumber = Int(classNumberText) else {
                    throw ErrorModel.parsingError("Class number parsing error")
                }
                currentClassNumber = classNumber
                break
            }
        }
        schedule.append(currentDay)
        return schedule
    }
    
    private static func getContentFromData(data: Data) throws -> Element {
        let html = String(data: data, encoding: .utf8) ?? ""
        let doc = try SwiftSoup.parse(html)
        guard let content: Element = try doc.select("div.view-content").first() else {
            throw ErrorModel.parsingError("'view-content' div not found")
        }
        return content
    }
    
    private static func parseClassData(classData: Element, classNumber: Int) throws -> ClassModel {
        guard let classContent = try classData.select("div.group_content").first(),
            classContent.textNodes().count >= 2
        else {
            throw ErrorModel.parsingError("'group_content' div not found")
        }
        let name = classContent.textNodes()[0].text().trimmingCharacters(in: .whitespacesAndNewlines)
        let details = try parseClassDetails(info: classContent.textNodes()[1].text())
        let subgroupType = try parseClassSubgroupFromID(classId: classData.id())
        let weekType = try parseWeekTypeFromID(classId: classData.id())
        return ClassModel(
            name: name,
            number: classNumber,
            locations: details.locations,
            teachers: details.teachers,
            classType: details.classType,
            subgroupType: subgroupType,
            weekType: weekType)
    }
    
    private static func parseClassDetails(info: String) throws -> (classType: ClassTypeModel, locations: [String], teachers: [String]) {
        var classType = ClassTypeModel()
        var locations: [String] = []
        var teachers: [String] = []
        let details = info.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ", ")
        
        for element in details {
            if element == details.last {
                guard let tryClassType = ClassTypeModel(rawValue: String(element)) else {
                    throw ErrorModel.parsingError("Class type parsing error")
                }
                classType = tryClassType
            } else if element.contains("н.к.") {
                locations.append(String(element))
            } else {
                teachers.append(String(element))
            }
        }
        
        return (classType, locations, teachers)
    }
    
    private static func parseClassSubgroupFromID(classId: String) throws -> SubgroupTypeModel {
        let subgroupString = classId.split(separator: "_").dropLast().joined(separator: "_")
        guard let subgroup = SubgroupTypeModel(rawValue: String(subgroupString)) else {
            throw ErrorModel.parsingError("Week type parsing error")
        }
        return subgroup
    }
    
    private static func parseWeekTypeFromID(classId: String) throws -> WeekTypeModel {
        guard let weekTypeString = classId.split(separator: "_").last,
            let weekType = WeekTypeModel(rawValue: String(weekTypeString)) else {
            throw ErrorModel.parsingError("Week type parsing error")
        }
        return weekType
    }
}
