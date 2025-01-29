//
//  FastingTracker.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 29.01.2025.
//

import Foundation

// Структура, которая будет использоваться для хранения данных
struct FastingDataEntry: Codable {
    let date: String
    let hours: CGFloat
}

class FastingTracker {
    private var fastingPeriods: [(start: Date, finish: Date)] = []
    private let calendar = Calendar(identifier: .gregorian)
    private(set) var fastingData: [FastingDataEntry] = []
    
    // Ключ для сохранения данных в UserDefaults
    private let fastingDataKey = "fastingDataKey"
    
    init() {
        loadFastingData()
    }
    
    func addFastingPeriod(start: Date, finish: Date) {
        fastingPeriods.append((start, finish))
        updateChartData()
       //clearFastingData()
        saveFastingData()  // Сохраняем данные после изменения
    }
    
    private func updateChartData() {
        var result: [String: CGFloat] = [:]
        let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = = dateFormatter.formatToDayAndMonthFirstLetter(from: date)
       // dateFormatter.locale = Locale(identifier: "uk_UA")
        print(dateFormatter)
        
        for (start, finish) in fastingPeriods {
            var current = start
            let end = finish
            
            while current < end {
                let nextMidnight = calendar.nextDate(after: current, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict, direction: .forward) ?? end
                let periodEnd = min(nextMidnight, end)
                
                let hours = CGFloat(periodEnd.timeIntervalSince(current) / 3600)
                //let dateKey = dateFormatter.string(from: current)
                let dateKey = dateFormatter.formatToDayAndMonthFirstLetter(from: current)

                
                result[dateKey, default: 0] += hours
                current = periodEnd
            }
        }
        
        let sortedKeys = result.keys.sorted()
        var completeResult: [FastingDataEntry] = []
        var previousDate: String?
        
        for date in sortedKeys {
            if let prev = previousDate, let prevDate = dateFormatter.date(from: prev), let currentDate = dateFormatter.date(from: date) {
                let dayDifference = calendar.dateComponents([.day], from: prevDate, to: currentDate).day ?? 0
                
                if dayDifference > 1 {
                    for missingDay in 1..<(dayDifference) {
                        if let missingDate = calendar.date(byAdding: .day, value: missingDay, to: prevDate) {
                            let missingKey = dateFormatter.string(from: missingDate)
                            completeResult.append(FastingDataEntry(date: missingKey, hours: 0.0))
                        }
                    }
                }
            }
            completeResult.append(FastingDataEntry(date: date, hours: result[date] ?? 0.0))
            previousDate = date
        }
        
        // Debug output to see how fastingData changes
        print("Before appending, fastingData: \(fastingData)")
        fastingData.append(contentsOf: completeResult)
        print("After appending, fastingData: \(fastingData)")
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

extension DateFormatter {
    // Метод для форматирования даты с первой буквой месяца
    func formatToDayAndMonthFirstLetter(from date: Date) -> String {
        // Массив с первой буквой месяца на украинском
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
}
