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

    // ✅ Загрузка данных
    func loadDataFromCloud(into viewController: ViewController) {
        getUserDocument().getDocument { snapshot, error in
            
            print("📌 Snapshot Firebase: \(snapshot)")
            print("📌 Error Firebase: \(error)")
            
            guard let data = snapshot?.data(), error == nil else {
                print("❌ Ошибка загрузки Firebase: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            print("📥 Данные загружены из Firebase")
            print("data Firebase - \(data)")

            DispatchQueue.main.async {
                viewController.startDate = Date(timeIntervalSince1970: data["startDate"] as? TimeInterval ?? Date().timeIntervalSince1970)
                viewController.selectedPlan = ViewController.Plan(rawValue: data["selectedMyPlan"] as? String ?? "default") ?? .basic
                viewController.timeResting = data["timeResting"] as? Int ?? 0
                viewController.timeFasting = data["timeFasting"] as? Int ?? 0
                viewController.isStarvation = data["isStarvation"] as? Bool ?? false
                viewController.timeWait = data["timeWait"] as? Int ?? 0
                viewController.endDate = Date(timeIntervalSince1970: data["endDate"] as? TimeInterval ?? Date().timeIntervalSince1970)
                //viewController.isFirstStartApp = data["isFirstStartApp"] as? Bool ?? false
                viewController.isFastingTimeExpired = data["isFastingTimeExpired"] as? Bool ?? false
                viewController.isStarvationTimeExpired = data["isStarvationTimeExpired"] as? Bool ?? false
                viewController.timeIsUp = data["timeIsUp"] as? Bool ?? false
                viewController.vcSelectedButtonTag = data["vcSelectedButtonTag"] as? Int ?? 2

                viewController.updateUI()
                
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
    
    // Метод для загрузки данных о голодании из Firebase
    func loadFastingDataFromCloud(into fastingTracker: FastingTracker) {
        getUserDocument().getDocument { snapshot, error in
            print("📌 Snapshot Firebase: \(snapshot)")  // Добавляем ключевое слово FastingTracker
            print("📌 Error Firebase: \(error)")  // Добавляем ключевое слово FastingTracker
            
            guard let data = snapshot?.data(), error == nil else {
                print(" ❌ Ошибка загрузки данных из Firebase для FastingTracker: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }

            // Если данных нет, выводим это в логи
            if data["fastingData"] == nil {
                print(" ❌ Нет данных для fastingData в Firebase")
            }

            if let fastingDataArray = data["fastingData"] as? [[String: Any]] {
                print("Firebase 📥 Данные fastingData: \(fastingDataArray)")  // Выводим данные

                var fastingDataEntries: [FastingDataEntry] = []
                for fastingDataDict in fastingDataArray {
                    if let date = fastingDataDict["date"] as? String,
                       let hours = fastingDataDict["hours"] as? CGFloat,
                       let fullDate = fastingDataDict["fullDate"] as? String {
                        let entry = FastingDataEntry(date: date, hours: hours, fullDate: fullDate)
                        fastingDataEntries.append(entry)
                    }
                }
                fastingTracker.fastingData = fastingDataEntries
                print(" ✅ Данные о голодании для FastingTracker успешно загружены из Firebase!")
                print(" Загрузка из Firebase (FastingTracker): \(fastingDataEntries)")
            } else {
                print(" ❌ Невозможно загрузить данные fastingData из Firebase")
            }
        }
    }


}
