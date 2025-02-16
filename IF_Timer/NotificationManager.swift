//
//  NotificationManager.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 15.02.2025.
//

import UserNotifications
import UIKit

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // Запрос разрешения на уведомления
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
               // print("Ошибка при запросе разрешения на уведомления: \(error.localizedDescription)")
            }
        }
    }
    
    // Планирование уведомлений
    func scheduleNotifications(finishDate: Date, endDate: Date, isStarvation: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Удаляем старые уведомления
        
        //print("Запланирован новый пуш-уведомления")
        
        if !isStarvation {
            // Уведомление за 1 час до начала голодания
            let oneHourBeforeStart = endDate.addingTimeInterval(-3600)
            if oneHourBeforeStart > Date() {
                scheduleNotification(
                    title: "Залишилася 1 година!",
                    body: "До початку голодування залишилася 1 година.",
                    date: oneHourBeforeStart,
                    identifier: "oneHourBeforeStart"
                )
            }
            
            // Уведомление в момент начала голодания
            if endDate > Date() {
                scheduleNotification(
                    title: "Час вийшов!",
                    body: "Пора почати голодування.",
                    date: endDate,
                    identifier: "startFasting"
                )
            }
           // print("Заплонированы пуш уведомления при отдыхе, isStarvation = \(isStarvation), за час на = \(oneHourBeforeStart), по окончанию на = \(endDate)")
        } else {
            // Уведомление за 1 час до окончания голодания
            let oneHourBeforeFinish = finishDate.addingTimeInterval(-3600)
            if oneHourBeforeFinish > Date() {
                scheduleNotification(
                    title: "Залишилася 1 година!",
                    body: "До кінця голодування залишилася 1 година.",
                    date: oneHourBeforeFinish,
                    identifier: "oneHourBeforeFinish"
                )
            }
            
            // Уведомление в момент завершения голодания
            if finishDate > Date() {
                scheduleNotification(
                    title: "Голодування завершено!",
                    body: "Час завершити голодування.",
                    date: finishDate,
                    identifier: "finishNotification"
                )
            }
           // print("Заплонированы пуш уведомления при голодании, isStarvation = \(isStarvation), за час на = \(oneHourBeforeFinish), по окончанию на = \(finishDate)")
        }
    }
    
    func scheduleNotificationReminde(_ remindeSecond: Int, _ isStarvation: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Удаляем старые уведомления
        
            // Уведомление на 1 позже
            let oneHourBeforeStartReminde = Date().addingTimeInterval(Double(remindeSecond))
            if oneHourBeforeStartReminde > Date() {
                if isStarvation {
                scheduleNotification(
                    title: "Час вийшов!",
                    body: "Час завершити голодування.",
                    date: oneHourBeforeStartReminde,
                    identifier: "oneHourBeforeStartReminde"
                )
        //print("Запланирован новый пуш-уведомления по тапу Напомнить позже ПРИ ГОЛОДАНИИ, oneHourBeforeStart - \(oneHourBeforeStartReminde), remindeSecond - \(remindeSecond), isStarvation - \(isStarvation)")
        } else {
            scheduleNotification(
                title: "Час вийшов!",
                body: "Пора почати голодування.",
                date: oneHourBeforeStartReminde,
                identifier: "oneHourBeforeStartRemindeRest"
            )
           // print("Запланирован новый пуш-уведомления по тапу Напомнить позже ПРИ ОТДЫХЕ, oneHourBeforeStart - \(oneHourBeforeStartReminde), remindeSecond - \(remindeSecond), isStarvation - \(isStarvation)")
        }
        }
    }
    
    // Метод создания уведомления
    private func scheduleNotification(title: String, body: String, date: Date, identifier: String) {

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                //print("Ошибка при создании уведомления: \(error.localizedDescription)")
            }
        }
    }
}
