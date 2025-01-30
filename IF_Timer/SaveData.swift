//
//  SaveData.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 20.01.2025.
//

import Foundation
import UIKit

class SaveData {
    var viewController: ViewController?

    func loadSaveDate() {
        print("Загрузка данных ..........................")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let viewController = self.viewController else {
                //print("Error: self or viewController is nil")
                return
            }

            var savedStartDate: Date?
            if let savedDate = UserDefaults.standard.object(forKey: "startDate") as? Date {
                savedStartDate = savedDate
                //print("загрузка savedDate - \(savedDate)")
            }
            viewController.startDate = savedStartDate ?? Date()

            if let tempIsStarvation = UserDefaults.standard.object(forKey: "isStarvation") as? Bool {
                viewController.isStarvation = tempIsStarvation
                //print("загрузка tempIsStarvation - \(tempIsStarvation)")
            }
//            if let temptimeIsUp = UserDefaults.standard.object(forKey: "timeIsUp") as? Bool {
//                viewController.timeIsUp = temptimeIsUp
//               print("загрузка timeIsUp - \(temptimeIsUp)")
//            }
            
            
            if let saveTimeFasting = UserDefaults.standard.object(forKey: "timeFasting") as? Int {
                viewController.timeFasting = saveTimeFasting
            }
            
            if let tempTimeWait = UserDefaults.standard.object(forKey: "timeWait") as? Int {
                viewController.timeWait = tempTimeWait
            }
            
            if let rawValue = UserDefaults.standard.string(forKey: "selectedMyPlan"),
               let plan = ViewController.Plan(rawValue: rawValue) {
                viewController.selectedPlan = plan
                //print("Загруженный план: \(plan)")
            } else {
                //print("Ошибка: не удалось загрузить план из UserDefaults")
            }
            
            if let endDateTemp = UserDefaults.standard.object(forKey: "endDate") as? Date {
                viewController.endDate = endDateTemp
            }
          


            DispatchQueue.main.async { [weak self] in
                guard let self = self, let viewController = self.viewController else {
                    print("Error: self or viewController is nil on main queue")
                    return
                }

                if let savedStartDate = savedStartDate {
                    viewController.setButtonTitle.setButtonTitle(for: viewController.startButton, date: savedStartDate)
                }
                
                if let saveTimeResting = UserDefaults.standard.object(forKey: "timeResting") as? Int {
                    viewController.timeResting = saveTimeResting
                    viewController.finishDate = viewController.startDate.addingTimeInterval(TimeInterval(viewController.timeResting))
                    viewController.updateFinishDateButton()
                } else {
                    viewController.finishButton.setTitle("Скоро", for: .normal)
                }
            }
        }
    }

    func saveDateUserDefaults() {
        guard let viewController = viewController else {
            print("Error: viewController is nil")
            return
        }
        UserDefaults.standard.set(viewController.startDate, forKey: "startDate")
        UserDefaults.standard.set(viewController.selectedPlan.rawValue, forKey: "selectedMyPlan")

       // UserDefaults.standard.set(viewController.selectedPlan.selectedMyPlan, forKey: "selectedMyPlan")
        UserDefaults.standard.set(viewController.timeResting, forKey: "timeResting")
        UserDefaults.standard.set(viewController.timeFasting, forKey: "timeFasting")
        UserDefaults.standard.set(viewController.isStarvation, forKey: "isStarvation")
        UserDefaults.standard.set(viewController.timeWait, forKey: "timeWait")
        UserDefaults.standard.set(viewController.endDate, forKey: "endDate")
        //UserDefaults.standard.set(viewController.timeIsUp, forKey: "timeIsUp")
        print("Сохранение данных !!!!!!!!!!!!!!")
       // print("сохранение данных в UserDefaults, isStarvation - \(viewController.isStarvation), timeResting - \(viewController.timeResting / 3600), timeFasting - \(viewController.timeFasting / 3600), timeWait - \(viewController.timeWait / 3600), selectedMyPlan - \(viewController.selectedPlan.selectedMyPlan), startDate - \(viewController.startDate), endDate - \(viewController.endDate) ")
    }
    
}



