//
//  ViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit

class ViewController: UIViewController, CustomAlertDelegate {
    
    private var datePickerManager: DatePickerManager!
    let sd = SaveData()
    let setupTimer = SetupTimer()
    var circularProgressView: CircularProgressView?
    
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
    
    @IBOutlet weak var startOrFinishButton: UIButton!
    @IBOutlet weak var remindeButton: UIButton!
    @IBOutlet weak var myProfilButton: UIButton!
    
    
    var isStarvation: Bool = false
    
    var imageView: UIImageView!
    // Ссылка на круговой прогресс
   
    var valueProgress: CGFloat = 0.0 {
        didSet {
            updateProgress(valueProgress)
            if isStarvation {
                percentProgressLabel.text = "━━━━\n\(Int(valueProgress * 100))%"
            } else {
                percentProgressLabel.text = ""
            }
        }
    }

    var backgroundTab = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
    
    var timeResting = 8 * 3600 // время голодания
    var timeFasting = 16 * 3600 // время приёма пищи
    var timeWait = 16 * 3600
    var selectedPlan: Plan = .basic // Установите дефолтный план
    
    var startDate = Date()
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
        sd.viewController = self
        setupTimer.viewController = self
        sd.loadSaveDate() // загрузка данных
        setupTitle()
        
        datePickerManager = DatePickerManager(parentViewController: self)
        
        if !isStarvation {startDate = Date()}
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        view.backgroundColor = backgroundTab
        progressBar.backgroundColor = .clear
        percentProgressLabel.text = "━━\n\(Int(valueProgress * 100)) %"
        updateFinishDateButton()
        setupCircularProgress()
        setupButtonsInfo(90)
        setupButtonsStart()
        setupTimer.startTimer()
        
        print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600), isStarvation - \(isStarvation) ")
        print("startDate начало  - \(startDate)) ")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgress(valueProgress)
        updateFinishDateButton()
        setupTimer.startTimer()
    }
    
    func setupTitle() {
        // Создаем UILabel
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center // Выравнивание по центру
        titleLabel.textColor = .black // Цвет текста (можно изменить)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25) // Увеличиваем шрифт и делаем его жирным
        isStarvation ? (titleLabel.text = "Вікно голодування") : (titleLabel.text = "Почніть вікно голодування")
        // Устанавливаем UILabel как titleView
        navigationItem.titleView = titleLabel
        
        //title = "Вікно голодування"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray
    }
    
    func updatePlan(timeResting: Int, timeFasting: Int, selectedPlan: Plan) {
        self.timeResting = timeResting
        self.timeFasting = timeFasting
        self.selectedPlan = selectedPlan // Обновляем выбранный план
        updateFinishDateButton()
        // Обновляем текст метки
        planButton.setTitle(selectedPlan.selectedMyPlan, for: .normal)
        
        sd.saveDateUserDefaults()
        
        print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600), selectedPlan - \(selectedPlan) ")
    }
    
    
    //MARK: Created buttons
    
    func setupButtonsInfo(_ equalToConstant: Int) {
        
        finishButton.isUserInteractionEnabled = false
        
        startButton.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 0.8)  // Светло-голубой
        planButton.backgroundColor = UIColor(red: 174/255, green: 238/255, blue: 238/255, alpha: 0.8)  // Светло-зелено-голубой
        finishButton.backgroundColor = UIColor(red: 255/255, green: 220/255, blue: 130/255, alpha: 0.8)  // Светло-желтый с оранжевым оттенком
        
        let buttonsInfo: [UIButton] = [startButton, planButton, finishButton]
        
        for button in buttonsInfo {
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            // Задаем ширину кнопок
            button.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
            button.widthAnchor.constraint(equalToConstant: CGFloat(equalToConstant)).isActive = true
            
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
        planButton.setTitleColor(.black, for: .normal)
        planButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        planButton.setTitle(selectedPlan.selectedMyPlan, for: .normal)
    }
    
    func setupButtonsStart() {
        let buttonsStart: [UIButton] = [startOrFinishButton, remindeButton, myProfilButton]
        
        for button in buttonsStart {
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            if button == startOrFinishButton {
                if isStarvation {
                    startOrFinishButton.backgroundColor = .systemRed
                    startOrFinishButton.setTitle("Закінчити голодування", for: .normal)
                } else {
                    button.backgroundColor = UIColor.systemGreen
                    startOrFinishButton.setTitle("Почати голодування", for: .normal)
                }
            }
            if button == remindeButton {
                button.backgroundColor = .clear
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.systemGreen.cgColor
                isStarvation ? (button.isHidden = true) : (button.isHidden = false)
            }
            if button == myProfilButton {
                button.layer.borderColor = UIColor.systemBlue.cgColor
            }
        }
    }
    func updateFinishDateButton() {
       
        if isStarvation {
            timeWait = timeFasting
            finishStackView.isHidden = false
            setupButtonsInfo(90)
        } else {
            timeWait = timeResting
            finishStackView.isHidden = true
            setupButtonsInfo(140)
        }
        
        finishDate = startDate.addingTimeInterval(TimeInterval(timeWait))
        guard let finishDate = finishDate else { return }
        setButtonTitle(for: finishButton, date: finishDate)
        setButtonTitle(for: startButton, date: startDate)
        
    }
    
    //MARK: Progress Bar
    
    private func setupCircularProgress() {
        // Создаем экземпляр CircularProgressView
        circularProgressView = CircularProgressView(frame: progressBar.bounds)
        
        // Убедимся, что прогресс-бар существует
        guard let circularProgressView = circularProgressView else { return }
        
        // Передаем viewController после инициализации
        circularProgressView.viewController = self
        
        // Добавляем его в progressBar
        progressBar.addSubview(circularProgressView)
    }
    
    func updateProgress(_ value: CGFloat) {
        circularProgressView?.progress = value
    }
    
    // MARK: Button Start Info
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        datePickerManager.showDatePicker(mode: .dateAndTime, startDate: isStarvation ? startDate : Date()) { [self] selectedDate in
            self.setButtonTitle(for: sender, date: selectedDate)
            startDate = selectedDate
            updateFinishDateButton()
            setupTimer.startTimer()
            sd.saveDateUserDefaults()
        }
        //print("startDate начало  - \(startDate)) ")
        //startTimer()
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
            if let selectPlanviewController = segue.destination as? SelectPlanView {
                // Передаем ссылку на текущий контроллер
                selectPlanviewController.parentviewController = self
            }
        }
    }
    
    // MARK: Button Start Starvation
    
    @IBAction func startStarvationButtonPressed(_ sender: Any) {
        
        if isStarvation {
            let alertviewController = CustomAlertViewController()
            // Устанавливаем делегат перед презентацией
            alertviewController.delegate = self
            
            self.present(alertviewController, animated: true) {
                alertviewController.showCustomAlert()
            }
        } else {
            didTapYesButton()
        }
    }
    
    func didTapYesButton() {
        isStarvation.toggle()
        startDate = Date()
        valueProgress = 0
        setupButtonsStart()
        setupTitle()
        setupTimer.startTimer()
        sd.saveDateUserDefaults()
        updateFinishDateButton()
        //updateProgress(valueProgress)
        
        if isStarvation {
            setButtonTitle(for: self.startButton, date: startDate)
        } else {
            let endDate = startDate.addingTimeInterval(TimeInterval(timeResting))
            print("endDate \(endDate), timeResting \(timeResting / 3600), valueProgress \(valueProgress)")
            setButtonTitle(for: self.startButton, date: endDate)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sd.saveDateUserDefaults()
    }
    
    deinit {
        setupTimer.countdownTimer?.invalidate()
    }
}



