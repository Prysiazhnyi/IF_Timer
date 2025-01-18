//
//  ViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var datePickerManager: DatePickerManager!
    
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var titleProgressLabel: UILabel!
    @IBOutlet weak var timerProgressLabel: UILabel!
    @IBOutlet weak var percentProgressLabel: UILabel!
    
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var planStackView: UIStackView!
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var finishStackView: UIStackView!
    
    
    
    var imageView: UIImageView!
    // Ссылка на круговой прогресс
    var circularProgressView: CircularProgressView?
    var valueProgress: CGFloat = 0.0 {
        didSet {
            updateProgress(valueProgress)
            percentProgressLabel.text = "━━━━\n\(Int(valueProgress * 100))%"
        }
    }
    
    // Таймер
    private var countdownTimer: Timer?
    private var remainingTime: TimeInterval = 2 * 3600 // Оставшееся время в секундах
    
    
    var timeResting = 16 * 3600 // время голодания
    var timeFasting = 8 * 3600 // время приёма пищи
    var timeWait = 16 * 3600 // стартовое время таймера
    
    var startDate: Date?
    var finishDate: Date?
    
    enum Plan: String {
        case myPlan = "Мой план"
        case basic = "16-8"
        case start = "12-12"
        case startPlus = "14-10"
        case strong = "18-6"
        case strongPlus = "20-4"
        
        var selectedMyPlan: String {
            return self.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем UILabel
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center // Выравнивание по центру
        titleLabel.textColor = .black // Цвет текста (можно изменить)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20) // Увеличиваем шрифт и делаем его жирным
        titleLabel.text = "Вікно голодування"
        // Устанавливаем UILabel как titleView
        navigationItem.titleView = titleLabel
        
        //title = "Вікно голодування"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray
        
        datePickerManager = DatePickerManager(parentViewController: self)
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        view.backgroundColor = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
        progressBar.backgroundColor = .clear
        percentProgressLabel.text = "━━\n\(Int(valueProgress * 100)) %"
        setupCircularProgress()
        setupButtons()
        loadSaveDate() // загрузка данных
        planButton.setTitleColor(.black, for: .normal)
        planButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        planButton.setTitle("16-8", for: .normal)
        
        print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600) ")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600) ")
    }
    
    func loadSaveDate() {
        DispatchQueue.global(qos: .userInitiated).async {
            var savedStartDate: Date?
            // Загрузка сохраненной даты и отображение на кнопке
            if let savedDate = UserDefaults.standard.object(forKey: "startDate") as? Date {
                savedStartDate = savedDate
                print("загрузка savedDate - \(savedDate)")
            } else {
                savedStartDate = Date()  // Если нет сохраненной даты, используем текущую
                print("ошибка загрузки savedDate - (savedDate) = Data")
            }
            
            // Загружаем сохраненное время ожидания
            var savedTimeWait: TimeInterval?
            if let timeWait = UserDefaults.standard.object(forKey: "timeWait") as? TimeInterval {
                savedTimeWait = timeWait
                print("загрузка timeWait - \(timeWait / 3600)")
            } else {
                print("ошибка загрузки timeWait")
            }
            
            // Обновляем UI на главном потоке
            DispatchQueue.main.async {
                if let savedStartDate = savedStartDate {
                    self.setButtonTitle(for: self.startButton, date: savedStartDate)
                    self.startDate = savedStartDate
                }
                
                // Загружаем время завершения
                if let savedTimeWait = savedTimeWait, let savedStartDate = savedStartDate {
                    self.finishDate = savedStartDate.addingTimeInterval(savedTimeWait)
                    self.updateFinishDateButton()  // Обновляем кнопку сразу
                } else {
                    // Если нет сохраненной даты завершения, устанавливаем "Скоро"
                    self.finishButton.setTitle("Скоро", for: .normal)
                    self.finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 17) // Увеличиваем шрифт
                    self.finishButton.setTitleColor(.black, for: .normal) // Черный цвет
                }
                
                if let rawValue = UserDefaults.standard.string(forKey: "selectedMyPlan") {
                    self.planButton.setTitle(rawValue, for: .normal)
                    print("загрузка selectedMyPlan - \(rawValue)")
                } else {
                    print("ошибка загрузки selectedMyPlan")
                }
                
                if let saveTimeResting = UserDefaults.standard.object(forKey: "timeResting") as? Int {
                    self.timeResting = saveTimeResting
                    print("загрузка timeResting - \(self.timeResting / 3600)")
                } else {
                    print("ошибка загрузки timeResting")
                }
                if let saveTimeFasting = UserDefaults.standard.object(forKey: "timeFasting") as? Int {
                    self.timeFasting = saveTimeFasting
                    print("загрузка timeFasting - \(self.timeFasting / 3600)")
                } else {
                    print("ошибка загрузки timeFasting")
                }
            }
        }
    }
    
    func updatePlan(timeResting: Int, timeFasting: Int, selectedPlan: Plan) {
        self.timeResting = timeResting
        self.timeFasting = timeFasting
        
        // Обновляем текст метки
        planButton.setTitle(selectedPlan.selectedMyPlan, for: .normal)
        
        UserDefaults.standard.set(timeResting, forKey: "timeResting")
        UserDefaults.standard.set(timeFasting, forKey: "timeFasting")
        UserDefaults.standard.set(selectedPlan.selectedMyPlan, forKey: "selectedMyPlan")
        
        print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600) ")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgress(valueProgress)
        startTimer()
        updateFinishDateButton()
    }
    
    //MARK: Created buttons
    
    func setupButtons() {
        
        finishButton.isUserInteractionEnabled = false
        
        startButton.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 0.8)  // Светло-голубой
        planButton.backgroundColor = UIColor(red: 174/255, green: 238/255, blue: 238/255, alpha: 0.8)  // Светло-зелено-голубой
        finishButton.backgroundColor = UIColor(red: 255/255, green: 220/255, blue: 130/255, alpha: 0.8)  // Светло-желтый с оранжевым оттенком
        
        let buttons: [UIButton] = [startButton, planButton, finishButton]
        
        for button in buttons {
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.widthAnchor.constraint(equalToConstant: 90).isActive = true
            
            if button !== finishButton {
                imageView = UIImageView(image: UIImage(named: "icon-pencil"))
                imageView.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
                
                imageView.layer.cornerRadius = 10
                imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner] // Верхний левый и нижний правый углы
                imageView.layer.masksToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                // Добавляем UIImageView в кнопку
                button.addSubview(imageView)
                
                // Настроим Auto Layout для изображения
                NSLayoutConstraint.activate([
                    imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 0),
                    imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0),
                    imageView.widthAnchor.constraint(equalToConstant: 24),
                    imageView.heightAnchor.constraint(equalToConstant: 24)
                ])
            }
        }
    }
    
    //MARK: Progress Bar
    
    private func setupCircularProgress() {
        // Создаем экземпляр CircularProgressView
        circularProgressView = CircularProgressView(frame: progressBar.bounds)
        
        // Убедимся, что прогресс-бар существует
        guard let circularProgressView = circularProgressView else { return }
        
        // Добавляем его в progressBar
        progressBar.addSubview(circularProgressView)
        
    }
    
    func updateProgress(_ value: CGFloat) {
        circularProgressView?.progress = value
    }
    
    //MARK: Timer
    
    private func startTimer() {
        // Останавливаем предыдущий таймер, если он существует
        countdownTimer?.invalidate()
        
        // Создаем новый таймер
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    private func updateCountdown() {
        // Уменьшаем оставшееся время
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
            
            // Обновляем прогресс (например, по пропорции)
            valueProgress = CGFloat(1 - remainingTime / TimeInterval(timeWait))
        } else {
            // Останавливаем таймер, если время истекло
            countdownTimer?.invalidate()
            countdownTimer = nil
            timerProgressLabel.text = "00:00:00"
        }
    }
    private func updateTimerLabel() {
        // Форматируем оставшееся время в HH:MM:SS
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        timerProgressLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: Button Start
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        datePickerManager.showDatePicker(mode: .dateAndTime) { [self] selectedDate in
            self.setButtonTitle(for: sender, date: selectedDate)
            
            // Сохраняем выбранную дату
            UserDefaults.standard.set(selectedDate, forKey: "startDate")
            UserDefaults.standard.set(TimeInterval(timeWait), forKey: "timeWait")
            updateFinishDateButton()
            finishDate = selectedDate.addingTimeInterval(TimeInterval(timeWait))
        }
    }
    
    func updateFinishDateButton() {
        if let finishDate = finishDate {
            print("Finish date: \(finishDate)")
            self.setButtonTitle(for: finishButton, date: finishDate)
        }
    }
    
    
    func setButtonTitle(for button: UIButton, date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let selectedDate = calendar.startOfDay(for: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uk_UA") // Украинская локализация
        
        // Форматируем дату и время
        var dateString: String
        
        if selectedDate == today {
            dateString = "Сьогодні"
        } else if selectedDate == tomorrow {
            dateString = "Завтра"
        } else {
            dateFormatter.dateFormat = "dd MMM"
            dateString = dateFormatter.string(from: date)
        }
        
        // Форматируем время
        
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        
        // Создаем атрибутированный текст
        let title = NSMutableAttributedString(
            string: "\(dateString)\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 16), // Жирный шрифт для первой строки
                .foregroundColor: UIColor.black // Черный цвет текста
            ]
        )
        
        let time = NSAttributedString(
            string: timeString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14), // Обычный шрифт для второй строки
                .foregroundColor: UIColor.black // Черный цвет текста
            ]
        )
        
        title.append(time)
        
        // Устанавливаем атрибутированный текст для кнопки
        button.setAttributedTitle(title, for: .normal)
        
        // Включаем многострочный текст
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center // Выравниваем по центру
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectPlanSegue" {
            if let selectPlanVC = segue.destination as? SelectPlanView {
                // Передаем ссылку на текущий контроллер
                selectPlanVC.parentVC = self
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(startDate, forKey: "startDate")
        UserDefaults.standard.set(TimeInterval(timeWait), forKey: "timeWait")
        UserDefaults.standard.set(timeResting, forKey: "timeResting")
        UserDefaults.standard.set(timeFasting, forKey: "timeFasting")
    }

    
    deinit {
        countdownTimer?.invalidate()
    }
    
    
}



