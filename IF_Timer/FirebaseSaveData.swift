import FirebaseFirestore

class FirebaseSaveData {
    
    static let shared = FirebaseSaveData()
    private let db = Firestore.firestore()
    let selectPlanView = SelectPlanView()

    // Получение документа пользователя
    private func getUserDocument() -> DocumentReference {
        let userID = "lZpudjonPmsWukuoA2k9" // ❗️Заменить на реальный UID пользователя
        return db.collection("users").document(userID)
    }

    // ✅ Сохранение данных
    func saveDataToCloud(from viewController: ViewController) {
        let userData: [String: Any] = [
            "startDate": viewController.startDate.timeIntervalSince1970,
            "selectedMyPlan": viewController.selectedPlan.rawValue,
            "timeResting": viewController.timeResting,
            "timeFasting": viewController.timeFasting,
            "isStarvation": viewController.isStarvation,
            "timeWait": viewController.timeWait,
            "endDate": viewController.endDate.timeIntervalSince1970,
            //"isFirstStartApp": viewController.isFirstStartApp,
            "isFastingTimeExpired": viewController.isFastingTimeExpired,
            "isStarvationTimeExpired": viewController.isStarvationTimeExpired,
            "timeIsUp": viewController.timeIsUp,
            "vcSelectedButtonTag": viewController.vcSelectedButtonTag
        ]

        print(" userData - \(userData)")
        
        getUserDocument().setData(userData) { error in
            if let error = error {
                print("Ошибка сохранения: \(error.localizedDescription)")
            } else {
                print("✅ Данные успешно сохранены в Firebase!")
            }
        }
    }

    // ✅ Загрузка данных
    func loadDataFromCloud(into viewController: ViewController) {
        getUserDocument().getDocument { snapshot, error in
            
            print("📌 Snapshot: \(snapshot)")
            print("📌 Error: \(error)")
            
            guard let data = snapshot?.data(), error == nil else {
                print("❌ Ошибка загрузки: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            print("📥 Данные загружены из Firebase")
            print("data - \(data)")

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
}
