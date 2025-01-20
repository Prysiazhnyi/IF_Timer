//
//  SaveData.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 20.01.2025.
//

import Foundation
import UIKit

class SaveData {
    var vc: ViewController?

    func loadSaveDate() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let vc = self.vc else {
                print("Error: self or vc is nil")
                return
            }

            var savedStartDate: Date?
            if let savedDate = UserDefaults.standard.object(forKey: "startDate") as? Date {
                savedStartDate = savedDate
                print("загрузка savedDate - \(savedDate)")
            }
            vc.startDate = savedStartDate ?? Date()

            if let tempIsStarvation = UserDefaults.standard.object(forKey: "isStarvation") as? Bool {
                vc.isStarvation = tempIsStarvation
            }
            
            if let saveTimeFasting = UserDefaults.standard.object(forKey: "timeFasting") as? Int {
                vc.timeFasting = saveTimeFasting
            }
            
            if let tempTimeWait = UserDefaults.standard.object(forKey: "timeWait") as? Int {
                vc.timeWait = tempTimeWait
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self, let vc = self.vc else {
                    print("Error: self or vc is nil on main queue")
                    return
                }

                if let savedStartDate = savedStartDate {
                    vc.setButtonTitle(for: vc.startButton, date: savedStartDate)
                }

                if let rawValue = UserDefaults.standard.string(forKey: "selectedMyPlan"),
                   let plan = ViewController.Plan(rawValue: rawValue) {
                    vc.selectedPlan = plan
                    vc.planButton.setTitle(rawValue, for: .normal)
                }

                if let saveTimeResting = UserDefaults.standard.object(forKey: "timeResting") as? Int {
                    vc.timeResting = saveTimeResting
                    vc.finishDate = vc.startDate.addingTimeInterval(TimeInterval(vc.timeResting))
                    vc.updateFinishDateButton()
                } else {
                    vc.finishButton.setTitle("Скоро", for: .normal)
                }
            }
        }
    }

    func saveDateUserDefaults() {
        guard let vc = vc else {
            print("Error: vc is nil")
            return
        }
        UserDefaults.standard.set(vc.startDate, forKey: "startDate")
        UserDefaults.standard.set(vc.selectedPlan.selectedMyPlan, forKey: "selectedMyPlan")
        UserDefaults.standard.set(vc.timeResting, forKey: "timeResting")
        UserDefaults.standard.set(vc.timeFasting, forKey: "timeFasting")
        UserDefaults.standard.set(vc.isStarvation, forKey: "isStarvation")
        UserDefaults.standard.set(vc.timeWait, forKey: "timeWait")
    }
}



