//
//  FastingTracker.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 29.01.2025.
//

import Foundation

// Структура для хранения данных с датой без времени
struct FastingDataEntry: Codable {
    let date: String
    var hours: CGFloat
    let fullDate: String  // Сохраняем полную дату в формате "yyyy-MM-dd" для сортировки
}

class FastingTracker {
    private var fastingPeriods: [(start: Date, finish: Date)] = []
    private let calendar = Calendar(identifier: .gregorian)
    var fastingData: [FastingDataEntry] = []
    let fastingChartView = FastingChartView()
    
    // Ключ для сохранения данных в UserDefaults
    private let fastingDataKey = "fastingDataKey"
    
    init() {
        loadFastingData()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    func addFastingPeriod(start: Date, finish: Date) {
        fastingPeriods.append((start, finish))
        updateChartData()
        saveFastingData()  // Сохраняем данные после изменения
       // print("Данные FastingTracker для сохранения в Firebase: \(fastingData)")
        FirebaseSaveData.shared.saveFastingDataToCloud(fastingData: fastingData)

        FirebaseSaveData.shared.saveFastingDataToCloud(fastingData: fastingData)  // Сохраняем в Firebase
    }
    
    private func updateChartData() {
        var result: [String: CGFloat] = [:]
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for (start, finish) in fastingPeriods {
            var current = start
            let end = finish

            while current < end {
                let nextMidnight = calendar.nextDate(after: current, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict, direction: .forward) ?? end
                let periodEnd = min(nextMidnight, end)

                let hours = CGFloat(periodEnd.timeIntervalSince(current) / 3600)
                let dateKey = dateFormatter.string(from: current)

                result[dateKey, default: 0] += hours
                result[dateKey] = min(result[dateKey] ?? 0, 24) // Ограничиваем до 24 часов
                current = periodEnd
            }
        }

        for (date, hours) in result {
            if let index = fastingData.firstIndex(where: { $0.fullDate == date }) {
                fastingData[index].hours += hours
            } else {
                let formattedDate = formatToDayAndMonthFirstLetter(from: dateFormatter.date(from: date)!)
                fastingData.append(FastingDataEntry(date: formattedDate, hours: hours, fullDate: date))
            }
        }

        fastingData.sort { $0.fullDate < $1.fullDate }

        print("After appending, fastingData: \(fastingData)")
    }


    // Метод для форматирования даты в формат "день первая буква месяца" (например, "25 С")
    private func formatToDayAndMonthFirstLetter(from date: Date) -> String {
        let monthFirstLetters = ["С", "Л", "Б", "К", "Т", "Ч", "Л", "С", "В", "Ж", "Л", "Г"]
        
        // Получаем номер месяца (1-12)
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date) - 1 // Индексация с 0
        
        // Форматируем день (день месяца)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        // Получаем день и первую букву месяца
        let dayString = dayFormatter.string(from: date)
        let monthFirstLetter = monthFirstLetters[month]
        
        // Формируем финальную строку
        return "\(dayString) \(monthFirstLetter)"
    }

    // Сохранение данных в UserDefaults
    private func saveFastingData() {
       
        let encodedData = try? JSONEncoder().encode(fastingData)
        UserDefaults.standard.set(encodedData, forKey: fastingDataKey)
    }
    
    // Загрузка данных из UserDefaults
    private func loadFastingData() {
        if let savedData = UserDefaults.standard.data(forKey: fastingDataKey),
           let decodedData = try? JSONDecoder().decode([FastingDataEntry].self, from: savedData) {
            fastingData = decodedData
        }
    }
    
    func clearFastingData() {
        // Удаляем данные из UserDefaults
        UserDefaults.standard.removeObject(forKey: fastingDataKey)
        
        // Очищаем массив в приложении
        fastingData = []
    }
    
    func getFastingData() -> [FastingDataEntry] {
        return fastingData
    }
}
