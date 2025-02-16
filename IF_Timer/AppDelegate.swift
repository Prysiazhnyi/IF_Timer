//
//  AppDelegate.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit
import UserNotifications
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {
           FirebaseApp.configure() // Инициализация Firebase
           checkIfFirstLaunch() // функция для загрузки данных с Firebase при пепрвом запуске
           
           // Запрашиваем разрешение на уведомления
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("Ошибка запроса разрешения: \(error.localizedDescription)")
               }
           }
           
           // Назначаем делегат
           center.delegate = self
           
           return true
       }
       
       // Метод для обработки уведомлений в активном режиме
       func userNotificationCenter(
           _ center: UNUserNotificationCenter,
           willPresent notification: UNNotification,
           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
       ) {
           completionHandler([.banner, .sound]) // Показываем уведомление как баннер даже в активном режиме
       }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func checkIfFirstLaunch() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "isFirstStartApp") == nil {
            // Первый запуск
            print("🚀 Первый запуск приложения!")
            userDefaults.set(false, forKey: "isFirstStartApp")
            
            FirebaseSaveData.shared.loadAndSaveDataFromFirebase {
                // После загрузки данных вызываем loadSaveDate
                SaveData.shared.loadSaveDate()
                
            }
        } else {
            // Не первый запуск — загружаем данные из UserDefaults
            print("🔄 Приложение уже запускалось.")
            SaveData.shared.loadSaveDate()
        }
    }



}

