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
    var setupTimer: SetupTimer!
    var circularProgressView: CircularProgressView?
    var resultViewController: ResultViewController?
    var customAlertViewController: CustomAlertViewController?
    let setButtonTitle = SetButtonTitle()
    
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
    
    
    var isStarvation: Bool = false // это голодание или окно приема пищи
    var timeIsUp: Bool = false // время вышло
    var isFastingTimeExpired: Bool = false // вышло время приема пищ
    var isStarvationTimeExpired: Bool = false // вышло время голодания
    
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
    var finishDate = Date()
    var endDate = Date()
    let currentTime = Date() // Получить текущее время
    
    var tempStartDateForResult = Date()
    var tempFinishDateForResult = Date()
    
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
        sd.loadSaveDate() // загрузка данных
       
        sd.viewController = self
        // Инициализация CircularProgressView перед инициализацией SetupTimer
        circularProgressView = CircularProgressView(frame: progressBar.bounds)
        guard let circularProgressView = circularProgressView else { return }
        // Инициализация SetupTimer и передача ссылки на circularProgressView
        setupTimer = SetupTimer(viewController: self, circularProgressView: circularProgressView)
        
        datePickerManager = DatePickerManager(parentViewController: self)
        
        // Инициализируем resultViewController после того, как self уже доступен
        //resultViewController = ResultViewController()
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        view.backgroundColor = backgroundTab
        progressBar.backgroundColor = .clear
        percentProgressLabel.text = "━━\n\(Int(valueProgress * 100)) %"
        
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear triggered")
        sd.loadSaveDate() // загрузка данных
       
    }
    
    func updateUI() {
        print("Вызов updateUI()")
        timeIsUp = finishDate < currentTime || endDate < currentTime
        isStarvationTimeExpired = isStarvation && timeIsUp
        
        setupTitle()
        setupTitleProgressLabel()
        setupTitleProgressLabel()
        setupCircularProgress()
        updateProgress(valueProgress)
        setupButtonsInfo(100)
        setupButtonsStart()
        updateFinishDateButton()
        setupTimer.startTimer(Date())
        setupIfFastingTimeExpired()
       
    }
    
    
    func setupTitle() {
        // Создаем UILabel
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center // Выравнивание по центру
        titleLabel.textColor = .black // Цвет текста (можно изменить)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23) // Увеличиваем шрифт и делаем его жирным
        if isStarvation {
            timeIsUp ? (titleLabel.text = "Ти живий? Закінчуй з цим!") : (titleLabel.text = "Вікно голодування")
        } else {
            timeIsUp ? (titleLabel.text = "Час розпочати інтервал голоду") : (titleLabel.text = "Почніть вікно голодування")
        }
       setupIfFastingTimeExpired()
        // isStarvation ? (titleLabel.text = "Вікно голодування") : (titleLabel.text = "Почніть вікно голодування")
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
        setupIfFastingTimeExpired()
        
        sd.saveDateUserDefaults()
        
       // print("timeResting - \(timeResting / 3600), timeFasting - \(timeFasting / 3600), timeWait - \(timeWait / 3600), selectedPlan - \(selectedPlan) ")
    }
    
    
    //MARK: Created buttons
    
    func setupButtonsInfo(_ equalToConstant: Int) {
        
        finishButton.isUserInteractionEnabled = false
        
        planButton.backgroundColor = UIColor(red: 180/255, green: 235/255, blue: 250/255, alpha: 0.6)
        startButton.backgroundColor = UIColor(red: 186/255, green: 217/255, blue: 181/255, alpha: 0.6)
        finishButton.backgroundColor = UIColor(red: 250/255, green: 245/255, blue: 228/255, alpha: 0.6)
        
        let buttonsInfo: [UIButton] = [startButton, planButton, finishButton]
        
        for button in buttonsInfo {
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            // Задаем ширину кнопок
            button.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
            button.widthAnchor.constraint(equalToConstant: CGFloat(equalToConstant)).isActive = true
            
            if button !== finishButton {
                
                let originalImage = UIImage(named: "iconPencil")
                let newSize = CGSize(width: 16, height: 16) // Новый размер изображения
                
                // Создаем уменьшенное изображение
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage?.draw(in: CGRect(origin: .zero, size: newSize))
                }
                
                // Присваиваем уменьшенное изображение в ImageView
                imageView = UIImageView(image: resizedImage)
                imageView.contentMode = .center // Центрируем изображение внутри UIImageView
                
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
        planButton.setTitleColor(.darkGray, for: .normal)
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
       //print("isFastingTimeExpired - \(isFastingTimeExpired), isStarvation - \(isStarvation), timeIsUp - \(timeIsUp)")
        if isStarvation {
            timeWait = timeFasting
            finishStackView.isHidden = false
            setupButtonsInfo(100)
        } else {
            timeWait = timeResting
            finishStackView.isHidden = true
            setupButtonsInfo(140)
        }
        
        finishDate = startDate.addingTimeInterval(TimeInterval(timeWait))
        //guard let finishDate = finishDate else { return }
        setButtonTitle.setButtonTitle(for: finishButton, date: finishDate)
        //setButtonTitle(for: startButton, date: startDate)
        isStarvation ? setButtonTitle.setButtonTitle(for: self.startButton, date: startDate) : setButtonTitle.setButtonTitle(for: self.startButton, date: endDate)
       // print("isStarvation - \(isStarvation), startDate - \(startDate), finishDate - \(finishDate), timeWait - \(timeWait)")
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
        datePickerManager.showDatePicker(mode: .dateAndTime, startFromDate: isStarvation ? startDate : endDate) { [self] selectedDate in
            setButtonTitle.setButtonTitle(for: sender, date: selectedDate)
            
            if isStarvation {startDate = selectedDate
            } else {
                endDate = selectedDate
                startDate =  endDate - TimeInterval(timeResting)
            }
            
            updateFinishDateButton()
            setupTimer.startTimer(Date())
            sd.saveDateUserDefaults()
            setupIfFastingTimeExpired()
        }
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
            isStarvationTimeExpired = isStarvation && timeIsUp
          // print("isStarvationTimeExpired - \(isStarvationTimeExpired), isStarvation - \(isStarvation), timeIsUp - \(timeIsUp)")
            tempStartDateForResult = startDate
            tempFinishDateForResult = Date()
            //tempFinishDateForResult = finishDate
            let alertviewController = CustomAlertViewController()
            // Устанавливаем делегат перед презентацией
            alertviewController.delegate = self
            alertviewController.isStarvationTimeExpiredAlert = isStarvationTimeExpired
            alertviewController.parentviewController = self  // Передаём текущий контроллер
            alertviewController.modalPresentationStyle = .overFullScreen
            self.present(alertviewController, animated: true) {
                alertviewController.showCustomAlert(true)
            }
            
        } else {
            didTapYesButton()
        }
    }
    
    func didTapYesButton() {
        //print("ВЫЗОВ   ---    didTapYesButton")
        
        isStarvation.toggle()
        startDate = Date()
        valueProgress = 0
        setupButtonsStart()
        setupTitle()
        setupTimer.startTimer(Date())
        sd.saveDateUserDefaults()
        updateFinishDateButton()
        //updateProgress(valueProgress)
        
        if isStarvation {
            setButtonTitle.setButtonTitle(for: self.startButton, date: startDate)
        } else {
            endDate = startDate.addingTimeInterval(TimeInterval(timeResting))
            //print("endDate \(endDate), timeResting \(timeResting / 3600), valueProgress \(valueProgress)")
            setButtonTitle.setButtonTitle(for: self.startButton, date: endDate)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupTimer.countdownTimer?.invalidate()
        sd.saveDateUserDefaults()
    }
    
    deinit {
        setupTimer.countdownTimer?.invalidate()
        sd.saveDateUserDefaults()
    }
    
    func setupIfFastingTimeExpired() {
        //print("Beffor isFastingTimeExpired - \(isFastingTimeExpired), isStarvation - \(isStarvation), timeIsUp - \(timeIsUp)")
        isFastingTimeExpired = !isStarvation && timeIsUp ? true : false
       // print("Affter isFastingTimeExpired - \(isFastingTimeExpired), isStarvation - \(isStarvation), timeIsUp - \(timeIsUp)")
        if isFastingTimeExpired {
            startStackView.isHidden = true
            setupButtonsInfo(320)
            planButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        } else {
            updateFinishDateButton()
            startStackView.isHidden = false
        }
    }
    
    func setupTitleProgressLabel() {
        
        if isStarvation {
            titleProgressLabel.text = timeIsUp ? "Ви вже закінчили?" : "Залишилось часу"
        } else {
            percentProgressLabel.text = ""
            titleProgressLabel.text = timeIsUp ? "Ви почали\n голодувати?" :  "До наступного\n інтервального голодування"
        }
    }
    
}



