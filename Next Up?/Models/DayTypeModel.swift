enum DayTypeModel : String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Нд"
}

func shortToLongDayName(_ input: String) -> String {
    switch(input){
    case "Пн": return "Понеділок"
    case "Вт": return "Вівторок"
    case "Ср": return "Середа"
    case "Чт": return "Четвер"
    case "Пт": return "Пʼятниця"
    case "Сб": return "Субота"
    case "Нд": return "Неділя"
    default: return ""
    }
}
