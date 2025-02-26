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
    //let totalFasting: String
    
}

struct FastingDataCycle: Codable {
   // let fullDate: String  // Сохраняем полную дату в формате "yyyy-MM-dd" для сортировки
    let startDate: String
    let finishDate: String
    let hoursFasting: CGFloat
    
    //let totalFasting: String
    
}

class FastingTracker {
    private var fastingPeriods: [(start: Date, finish: Date)] = []
    private let calendar = Calendar(identifier: .gregorian)
    var fastingData: [FastingDataEntry] = []
    var fastingDataCycle: [FastingDataCycle] = []
    let fastingChartView = FastingChartView()
    
    // Ключ для сохранения данных в UserDefaults
    private let fastingDataKey = "fastingDataKey"
    private var fastingDataCycleKey = "fastingDataCycleKey"
    
    init() {
        loadFastingData()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    func addFastingPeriod(start: Date, finish: Date) {
        fastingPeriods.append((start, finish))
        updateChartData()
       //print("start - \(start), finish - \(finish)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // или любой другой формат, который вам нужен
        
        let startDateString = dateFormatter.string(from: start)
        let finishDateString = dateFormatter.string(from: finish)
        // Получаем количество часов голодания между start и finish
        let totalFasting = CGFloat(finish.timeIntervalSince(start) / 3600)
        fastingDataCycle.append(FastingDataCycle(startDate: startDateString, finishDate: finishDateString, hoursFasting: totalFasting))
        
        //print("fastingDataCycle - \(fastingDataCycle)")
        
        saveFastingData()  // Сохраняем данные после изменения
       // print("Данные FastingTracker для сохранения в Firebase: \(fastingData)")

        FirebaseSaveData.shared.saveFastingDataToCloud(fastingData: fastingData)  // Сохраняем в Firebase
        FirebaseSaveData.shared.saveFastingDataToCloud(fastingDataCycle: fastingDataCycle)  // Сохраняем в Firebase
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

        var lastDate = fastingData.last?.fullDate
        let existingDates = Set(fastingData.map { $0.fullDate })
        let sortedDates = result.keys.sorted()

        for date in sortedDates {
            guard let currentDate = dateFormatter.date(from: date) else { continue }

            // Заполнение пропущенных дней с hours: 0
            while let last = lastDate, let lastDateValue = dateFormatter.date(from: last),
                  let missingDate = calendar.date(byAdding: .day, value: 1, to: lastDateValue),
                  missingDate < currentDate {

                let missingDateString = dateFormatter.string(from: missingDate)
                if !existingDates.contains(missingDateString) {
                    let formattedDate = formatToDayAndMonthFirstLetter(from: missingDate)
                    fastingData.append(FastingDataEntry(date: formattedDate, hours: 0, fullDate: missingDateString))
                }
                lastDate = missingDateString
            }

            // Добавление новой записи или обновление существующей
            if let index = fastingData.firstIndex(where: { $0.fullDate == date }) {
                fastingData[index].hours += result[date] ?? 0
            } else {
                let formattedDate = formatToDayAndMonthFirstLetter(from: currentDate)
                fastingData.append(FastingDataEntry(date: formattedDate, hours: result[date] ?? 0, fullDate: date))
            }

            lastDate = date
        }

        fastingData.sort { $0.fullDate < $1.fullDate }
       // print("Updated fastingData: \(fastingData)")
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
        
        let encodedDataCycle = try? JSONEncoder().encode(fastingDataCycle)
        UserDefaults.standard.set(encodedDataCycle, forKey: fastingDataCycleKey)
    }
    
    // Загрузка данных из UserDefaults
    private func loadFastingData() {
        if let savedData = UserDefaults.standard.data(forKey: fastingDataKey),
           let decodedData = try? JSONDecoder().decode([FastingDataEntry].self, from: savedData) {
            fastingData = decodedData
        }
        
        if let savedDataCycle = UserDefaults.standard.data(forKey: fastingDataCycleKey),
           let decodedDataCycle = try? JSONDecoder().decode([FastingDataCycle].self, from: savedDataCycle) {
            fastingDataCycle = decodedDataCycle
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
