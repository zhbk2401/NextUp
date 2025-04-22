import Foundation
import SwiftSoup

class ScheduleService {
    static func fetchSchedule(group: String, semester: Int, completion: @escaping (Result<[DayModel], ErrorModel>) -> Void) {
        var components = URLComponents(string: "https://student.lpnu.ua/students_schedule")
        components?.queryItems = [
                URLQueryItem(name: "studygroup_abbrname", value: group),
                URLQueryItem(name: "semestr", value: "\(semester)")
            ]
        
        guard let url = components?.url else {
            completion(.failure(.networkError("Invalid URL")))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data,
                error == nil
            else {
                completion(.failure(.networkError(error?.localizedDescription ?? "Unknown network error")))
                return
            }
            var schedule: [DayModel] = []
            do {
                let html = String(data: data, encoding: .utf8) ?? ""
                let doc = try SwiftSoup.parse(html)
                var currentDay = DayModel()
                var currentClassNumber = 0
                guard let content : Element = try doc.select("div.view-content").first() else {
                    completion(.failure(.parsingError("'view-content' div not found")))
                    return
                }
                
                for element in content.children() {
                    switch try element.className() {
                    case "view-grouping-header":
                        guard let dayType = DayTypeModel(rawValue: try element.text()) else {
                            completion(.failure(.parsingError("'DayTypeModel' parsing error")))
                            return
                        }
                        if (!currentDay.classes.isEmpty) {
                            schedule.append(currentDay)
                        }
                        currentDay = DayModel(day: dayType, classes: [])
                        break
                    
                    case "stud_schedule":
                        for row in try element.select("div.views-row") {
                            for classItem in row.children() {
                                let subgroupType : ClassSubgroupModel
                                if classItem.id().contains("group") {
                                    subgroupType = .both
                                } else if classItem.id().contains("sub_1") {
                                    subgroupType = .subgroupOne
                                } else if classItem.id().contains("sub_2") {
                                    subgroupType = .subgroupTwo
                                } else {
                                    completion(.failure(.parsingError("Subgroup type parsing error")))
                                    return
                                }
                                
                                let weekType : WeekTypeModel
                                if classItem.id().contains("full") {
                                    weekType = .both
                                } else if classItem.id().contains("chys") {
                                    weekType = .weekC
                                } else if classItem.id().contains("znam") {
                                    weekType = .weekZ
                                } else {
                                    completion(.failure(.parsingError("Week type parsing error")))
                                    return
                                }
                                
                                var locations : [String] = []
                                var teachers : [String] = []
                                var classType = ClassTypeModel.laboratory
                                let name : String
                                guard
                                    let classContent = try classItem.select("div.group_content").first(),
                                    classContent.textNodes().count >= 2
                                else {
                                    completion(.failure(.parsingError("'group_content' div not found")))
                                    return
                                }
                                name = classContent.textNodes()[0].text().trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                let details = classContent.textNodes()[1].text().trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ", ")
                                for info in details {
                                    if details.last == info {
                                        guard let tryClassType = ClassTypeModel(rawValue: String(info)) else {
                                            completion(.failure(.parsingError("Class type parsing error")))
                                            return
                                        }
                                        classType = tryClassType
                                    } else if info.contains("н.к.") {
                                        locations.append(String(info))
                                    } else {
                                        teachers.append(String(info))
                                    }
                                }
                                
                                
                                currentDay.classes.append(ClassModel(
                                    name: name,
                                    number: currentClassNumber,
                                    locations: locations,
                                    teachers: teachers,
                                    classType: classType,
                                    subgroupType: subgroupType,
                                    weekType: weekType))
                            }
                        }
                        break
                    default:
                        guard let classNumberText = try? element.text(), let classNumber = Int(classNumberText) else {
                            completion(.failure(.parsingError("Class number parsing error")))
                            return
                        }
                        currentClassNumber = classNumber
                        break
                    }
                }
                schedule.append(currentDay)
                DispatchQueue.main.async {
                    completion(.success(schedule))
                }
            } catch {
                completion(.failure(.parsingError(error.localizedDescription)))
            }
        }.resume()
    }
}
