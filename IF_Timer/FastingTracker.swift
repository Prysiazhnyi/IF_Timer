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
    var hours: CGFloat
}

class FastingTracker {
    private var fastingPeriods: [(start: Date, finish: Date)] = []
    private let calendar = Calendar(identifier: .gregorian)
    private(set) var fastingData: [FastingDataEntry] = []
    
    // Ключ для сохранения данных в UserDefaults
    private let fastingDataKey = "fastingDataKey"
    
    init() {
        loadFastingData()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

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

        // Получаем все даты, которые необходимо обработать
        for (start, finish) in fastingPeriods {
            var current = start
            let end = finish

            while current < end {
                let nextMidnight = calendar.nextDate(after: current, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict, direction: .forward) ?? end
                let periodEnd = min(nextMidnight, end)

                let hours = CGFloat(periodEnd.timeIntervalSince(current) / 3600)
                let dateKey = dateFormatter.formatToDayAndMonthFirstLetter(from: current)

                // Добавляем только дни с данными
                result[dateKey, default: 0] += hours
                result[dateKey] = min(result[dateKey] ?? 0, 24) // Ограничение до 24 часов
                current = periodEnd
            }
        }

        // Обновляем данные в fastingData
        for date in result.keys {
            if let index = fastingData.firstIndex(where: { $0.date == date }) {
                // Если дата уже есть в fastingData, добавляем часы
                fastingData[index].hours += result[date] ?? 0.0
            } else {
                // Если дата не найдена, добавляем новый элемент
                fastingData.append(FastingDataEntry(date: date, hours: result[date] ?? 0.0))
            }
        }

        // Сортируем данные по дате
//        fastingData.sort { $0.date < $1.date }
        

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
        fastingData.reverse() // изменяет массив на месте
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
