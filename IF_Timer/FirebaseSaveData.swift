import FirebaseFirestore

class FirebaseSaveData {
    
    static let shared = FirebaseSaveData()
    private let db = Firestore.firestore()
    let selectPlanView = SelectPlanView()
    let fastingTracker = FastingTracker()

    // Получение документа пользователя
    private func getUserDocument() -> DocumentReference {
        let userID = "lZpudjonPmsWukuoA2k9" // Это ваш реальный ID документа
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
            "vcSelectedButtonTag": viewController.vcSelectedButtonTag
        ]

        getUserDocument().setData(userData, merge: true) { error in
            if let error = error {
                print("Ошибка сохранения в Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Данные успешно сохранены в Firebase!")
                print("✅ Данные успешно сохранены в Firebase! - saveDataToCloud userData - \(userData)")
               
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
                print("Сохранение userData ( FastingTracker ) в Firebase: \(userData)")
            }
        }
    }
    

//MARK:    // ✅ Загрузка данных
    
    func loadAndSaveDataFromFirebase(completion: (() -> Void)? = nil) {
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
                
                print("Данные успешно загружены и сохранены в UserDefaults")
                
                // 🚀 Вызываем переданный completion (например, обновление SaveData)
                           DispatchQueue.main.async {
                               completion?()
                           }
            }
        }
    }

}
