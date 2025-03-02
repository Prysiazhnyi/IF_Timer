import FirebaseFirestore

class FirebaseSaveData {
    
    static let shared = FirebaseSaveData()
    private let db = Firestore.firestore()
    let selectPlanView = SelectPlanView()
    let fastingTracker = FastingTracker()

    // Получение документа пользователя
    private func getUserDocument() -> DocumentReference {
        let userID =
        "test_document_Firebase_Database" // для тестов
        //"lZpudjonPmsWukuoA2k9" // Это ваш реальный ID документа
        return db.collection("myProfileIFTimer").document(userID)
    }

    // ✅ Сохранение данных
    // Функция для сохранения данных
    func saveDataToCloud(from viewController: ViewController) {
        let userData: [String: Any] = [
            "startDate": viewController.startDate.timeIntervalSince1970,
            "selectedMyPlan": viewController.selectedPlan.rawValue,
            "timeResting": viewController.timeResting,
            "timeFasting": viewController.timeFasting,
            "isStarvation": viewController.isStarvation,
            "timeWait": viewController.timeWait,
            "endDate": viewController.endDate.timeIntervalSince1970,
            "isFastingTimeExpired": viewController.isFastingTimeExpired,
            "isStarvationTimeExpired": viewController.isStarvationTimeExpired,
            "timeIsUp": viewController.timeIsUp,
            "vcSelectedButtonTag": viewController.vcSelectedButtonTag,
            "firstDateUseApp": viewController.firstDateUseApp
        ]

        getUserDocument().setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения в Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Данные успешно сохранены в Firebase!")
               // print("✅ Данные успешно сохранены в Firebase! - saveDataToCloud userData - \(userData)")
               
            }
        }
    
    }
    
    // MARK: Сохранения в Firebase data FastingTraker
    
    // Метод для сохранения данных о голодании в Firebase
    func saveFastingDataToCloud(fastingData: [FastingDataEntry]) {
        let userData: [String: Any] = [
            "fastingData": fastingData.map { entry in
                [
                    "date": entry.date,
                    "hours": entry.hours,
                    "fullDate": entry.fullDate
                ]
            }
        ]

        getUserDocument().setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения данных для FastingTracker в Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Данные о голодании для FastingTracker успешно сохранены в Firebase!")
              // print("Сохранение userData ( FastingTracker ) в Firebase: \(userData)")
            }
        }
    }
    
    // Метод для сохранения данных о голодании в Firebase
    func saveFastingDataToCloud(fastingDataCycle: [FastingDataCycle]) {
        let userData: [String: Any] = [
            "fastingDataCycle": fastingDataCycle.map { entry in
                [
                    "startDate": entry.startDate,
                    "finishDate": entry.finishDate,
                    "hoursFasting": entry.hoursFasting
                ]
            }
        ]

        getUserDocument().setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения данных для FastingTracker в Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Данные о голодании для FastingTracker успешно сохранены в Firebase!")
                //print("Сохранение userData ( FastingTracker ) в Firebase: \(userData)")
            }
        }
    }
    
    //MARK:
    
    // ✅ Сохранение данных
    // Функция для сохранения данных
    func saveDataProfileViewControllerToCloud(from profileViewController: ProfileViewController) {
        let userData: [String: Any] = [
           
            "startWeightValue": profileViewController.startWeightValue,
            "targetWeightValue": profileViewController.targetWeightValue,
            "lastWeightValue": profileViewController.lastWeightValue,
            "height": profileViewController.height,
            "weightDataArray": profileViewController.weightDataProfile.map { entry in
                        [
                            "date": ISO8601DateFormatter().string(from: entry.date),
                            "weight": entry.weight
                        ]
                    }
        ]

        getUserDocument().setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения в Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Данные -- ProfileViewController --  успешно сохранены в Firebase!")
               // print("✅ Данные успешно сохранены в Firebase! - saveDataToCloud userData - \(userData)")
               
            }
        }
    
    }
    

//MARK:    // ✅ Загрузка данных
    
    func loadAndSaveDataFromFirebase(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Загрузка данных из Firebase
            FirebaseSaveData.shared.getUserDocument().getDocument { snapshot, error in
                if let error = error {
                    print("Ошибка загрузки данных: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data() else {
                    print("Нет данных в Firebase")
                    return
                }

                // Сохранение данных в UserDefaults
                if let startDate = data["startDate"] as? TimeInterval {
                    UserDefaults.standard.set(Date(timeIntervalSince1970: startDate), forKey: "startDate")
                }
                if let selectedPlanRawValue = data["selectedMyPlan"] as? String {
                    UserDefaults.standard.set(selectedPlanRawValue, forKey: "selectedMyPlan")
                }
                if let timeResting = data["timeResting"] as? Int {
                    UserDefaults.standard.set(timeResting, forKey: "timeResting")
                }
                if let timeFasting = data["timeFasting"] as? Int {
                    UserDefaults.standard.set(timeFasting, forKey: "timeFasting")
                }
                if let isStarvation = data["isStarvation"] as? Bool {
                    UserDefaults.standard.set(isStarvation, forKey: "isStarvation")
                }
                if let timeWait = data["timeWait"] as? Int {
                    UserDefaults.standard.set(timeWait, forKey: "timeWait")
                }
                if let endDate = data["endDate"] as? TimeInterval {
                    UserDefaults.standard.set(Date(timeIntervalSince1970: endDate), forKey: "endDate")
                }

                if let isFastingTimeExpired = data["isFastingTimeExpired"] as? Bool {
                    UserDefaults.standard.set(isFastingTimeExpired, forKey: "isFastingTimeExpired")
                }
                if let isStarvationTimeExpired = data["isStarvationTimeExpired"] as? Bool {
                    UserDefaults.standard.set(isStarvationTimeExpired, forKey: "isStarvationTimeExpired")
                }
                if let timeIsUp = data["timeIsUp"] as? Bool {
                    UserDefaults.standard.set(timeIsUp, forKey: "timeIsUp")
                }
                if let vcSelectedButtonTag = data["vcSelectedButtonTag"] as? Int {
                    UserDefaults.standard.set(vcSelectedButtonTag, forKey: "vcSelectedButtonTag")
                }
                if let fastingDataArray = data["fastingData"] as? [[String: Any]] {
                    
                    var fastingDataEntries: [FastingDataEntry] = []
                    for fastingDataDict in fastingDataArray {
                        if let date = fastingDataDict["date"] as? String,
                           let hours = fastingDataDict["hours"] as? CGFloat,
                           let fullDate = fastingDataDict["fullDate"] as? String {
                            let entry = FastingDataEntry(date: date, hours: hours, fullDate: fullDate)
                            fastingDataEntries.append(entry)
                        }
                    }
                    // Сохраняем данные о голодании в UserDefaults
                    if let encodedData = try? JSONEncoder().encode(fastingDataEntries) {
                        UserDefaults.standard.set(encodedData, forKey: "fastingDataKey")
                        print("✅ Данные fastingDataKey о голодании успешно сохранены в UserDefaults.")
                    } else {
                        print("❌ Не удалось закодировать данные о голодании fastingDataKey.")
                    }
                }
                /////////////////
                if let fastingDataCycleArray = data["fastingDataCycle"] as? [[String: Any]] {
                    
                    var fastingDataCycleEntries: [FastingDataCycle] = []
                    for fastingDataDict in fastingDataCycleArray {
                        if let startDate = fastingDataDict["startDate"] as? String,
                           let finishDate = fastingDataDict["finishDate"] as? String,
                           let hoursFasting = fastingDataDict["hoursFasting"] as? CGFloat {
                            let entry = FastingDataCycle(startDate: startDate, finishDate: finishDate, hoursFasting: hoursFasting)
                            fastingDataCycleEntries.append(entry)
                        }
                    }
                    // Сохраняем данные о голодании в UserDefaults
                    if let encodedData = try? JSONEncoder().encode(fastingDataCycleEntries) {
                        UserDefaults.standard.set(encodedData, forKey: "fastingDataCycleKey")
                        print("✅ Данные fastingDataKey о голодании успешно сохранены в UserDefaults.")
                    } else {
                        print("❌ Не удалось закодировать данные о голодании fastingDataKey.")
                    }
                }
                
                if let firstDateUseApp = data["firstDateUseApp"] as? TimeInterval {
                    UserDefaults.standard.set(Date(timeIntervalSince1970: firstDateUseApp), forKey: "firstDateUseApp")
                }
                
                // Данный для ProfileViewController
                
                if let weightDataArray = data["weightDataArray"] as? [[String: Any]] {
                    // Сохраняем данные напрямую в UserDefaults без дополнительных преобразований
                    UserDefaults.standard.set(weightDataArray, forKey: "weightDataArray")
                    print("✅ Данные weightDataArray успешно сохранены в UserDefaults.")
                }
                
                if let tempStartWeightValue = data["startWeightValue"] as? Double {
                    UserDefaults.standard.set(tempStartWeightValue, forKey: "startWeightValue")
                }
                if let tempTargetWeightValue = data["targetWeightValue"] as? Double {
                    UserDefaults.standard.set(tempTargetWeightValue, forKey: "targetWeightValue")
                }
                
                if let tempLastWeightValue = data["lastWeightValue"] as? Double {
                    UserDefaults.standard.set(tempLastWeightValue, forKey: "lastWeightValue")
                }
                
                if let tempHeight = data["height"] as? Double {
                    UserDefaults.standard.set(tempHeight, forKey: "height")
                }
               
                
                // Other
                
                print("Данные успешно загружены и сохранены в UserDefaults")
                
                // 🚀 Вызываем переданный completion (например, обновление SaveData)
                           DispatchQueue.main.async {
                               completion(true)
                           }
            }
        }
    }

}
