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
    var ifFirstLaunch: Bool = true // для загрузки данных с Faribase
    
    // Ключ для сохранения данных в UserDefaults
    private let fastingDataKey = "fastingDataKey"
    
    init() {
        if ifFirstLaunch {
           // FirebaseSaveData.shared.loadFastingDataFromCloud(into: self)
            ifFirstLaunch = false
        } else {
            loadFastingData()
            }
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    func addFastingPeriod(start: Date, finish: Date) {
        fastingPeriods.append((start, finish))
        updateChartData()
        saveFastingData()  // Сохраняем данные после изменения
        print("Данные FastingTracker для сохранения в Firebase: \(fastingData)")
        FirebaseSaveData.shared.saveFastingDataToCloud(fastingData: fastingData)

        FirebaseSaveData.shared.saveFastingDataToCloud(fastingData: fastingData)  // Сохраняем в Firebase
    }
    
    private func updateChartData() {
        var result: [String: CGFloat] = [:]
        let dateFormatter = DateFormatter()
        
        // Устанавливаем формат для полной даты (для сортировки)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Получаем все даты, которые необходимо обработать
        for (start, finish) in fastingPeriods {
            var current = start
            let end = finish

            while current < end {
                let nextMidnight = calendar.nextDate(after: current, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict, direction: .forward) ?? end
                let periodEnd = min(nextMidnight, end)

                let hours = CGFloat(periodEnd.timeIntervalSince(current) / 3600)
                let dateKey = dateFormatter.string(from: current)
                
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
                let dateObj = result[date] ?? 0.0
                // Используем dateFormatter для форматирования даты в "день месяц" (например, "25 С")
                let dayAndMonth = formatToDayAndMonthFirstLetter(from: dateFormatter.date(from: date)!)
                fastingData.append(FastingDataEntry(date: dayAndMonth, hours: dateObj, fullDate: date))
            }
        }

        // Сортируем данные по полной дате (сравниваем строковые представления дат)
        fastingData.sort { $0.fullDate < $1.fullDate }

       // print("After appending, fastingData: \(fastingData)")
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
        UserDefaults.standard.set(ifFirstLaunch, forKey: "ifFirstLaunch")
        let encodedData = try? JSONEncoder().encode(fastingData)
        UserDefaults.standard.set(encodedData, forKey: fastingDataKey)
    }
    
    // Загрузка данных из UserDefaults
    private func loadFastingData() {
        if let savedData = UserDefaults.standard.data(forKey: fastingDataKey),
           let decodedData = try? JSONDecoder().decode([FastingDataEntry].self, from: savedData) {
            fastingData = decodedData
        }
        if let tempIfFirstLaunch = UserDefaults.standard.object(forKey: "ifFirstLaunch") as? Bool {
            self.ifFirstLaunch = tempIfFirstLaunch
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
