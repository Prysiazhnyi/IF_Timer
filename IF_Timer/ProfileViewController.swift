//
//  ProfileViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 25.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let fastingTracker = FastingTracker()
    let chartView = FastingChartView()
    
    @IBOutlet weak var viewTab: UIView!
    
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var fastingTrackerView: UIView!
    @IBOutlet weak var statisticsFastingView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var imtView: UIView!
    
    @IBOutlet weak var settingsButton: UIButton!
    //  для первого View achievementsView
    @IBOutlet weak var mainAchievementLabel: UILabel!
    @IBOutlet weak var firstLabelAchievementLabel: UILabel!
    @IBOutlet weak var firstValueAchievementLabel: UILabel!
    @IBOutlet weak var secondLabelAchievementLabel: UILabel!
    @IBOutlet weak var secondValueAchievementLabel: UILabel!
    @IBOutlet weak var thirdLabelAchievementLabel: UILabel!
    @IBOutlet weak var thirdValueAchievementLabel: UILabel!
    @IBOutlet weak var fourthLabelAchievementLabel: UILabel!
    @IBOutlet weak var fourthValueAchievementLabel: UILabel!
    @IBOutlet weak var fifthLabelAchievementLabel: UILabel!
    @IBOutlet weak var fifthValueAchievementLabel: UILabel!
    @IBOutlet weak var sixthLabelAchievementLabel: UILabel!
    @IBOutlet weak var sixthValueAchievementLabel: UILabel!
    //  для третего View statisticsFastingView
    @IBOutlet weak var statisticsFastingLabel: UILabel!
    @IBOutlet weak var progressStatisticView: UIProgressView!
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!
    @IBOutlet weak var dot1Label: UILabel!
    @IBOutlet weak var dot2Label: UILabel!
    @IBOutlet weak var dot3Label: UILabel!
    @IBOutlet weak var dropMarketView: UIView!
    var dot2LabelText = "7"
    var dot3LabelText = "14"
    // для четвертого View weightView
    
    // для пятого View imtView
    @IBOutlet weak var changeWeightImtViewButton: UIButton!
    @IBOutlet weak var titleImtView: UILabel!
    @IBOutlet weak var countImtView: UILabel!
    @IBOutlet weak var descriptionImtView: UILabel!
    @IBOutlet weak var progressImtView: UIProgressView!
    @IBOutlet weak var markerImtView: UIView!
    var imtCount = 30.0
    let text15Imt  = "Недостатня маса тіла"
    let text16Imt  = "Недостатня маса тіла"
    let text18Imt  = "Нормальна маса тіла"
    let text25Imt  = "Зайва маса тіла"
    let text30Imt  = "Ожиріння першого ступеня"
    let text35Imt  = "Ожиріння другого ступеня"
    let text40Imt  = "Ожиріння третього ступеня"
   
    
    
    let backgroundTab = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
    let backgroundView = UIColor(red: 234/255, green: 254/255, blue: 255/255, alpha: 1)

    
    var profileFastingData: [FastingDataEntry] = []
    var profileFastingDataCycle: [FastingDataCycle] = []
    
    var tottalDaysFasting: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        viewTab.backgroundColor = .clear
        
        title = "Профіль"
        self.view.backgroundColor = backgroundTab
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal), // SF Symbol с заливкой
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        // Устанавливаем оранжевый цвет
        settingsButton.tintColor = .orange
        navigationItem.rightBarButtonItem = settingsButton
        
        // Создаем объект UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Убираем прозрачность
        appearance.backgroundColor = backgroundTab //  цвет фона экрана
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста заголовка
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста большого заголовка
        appearance.shadowColor = nil // Убираем разделительную полосу
        // Применяем настройки
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Изначальные значения
        progressStatisticView.progress = 0.00
        
        setupView()
        setupSettingsButton()
        setupLabelsAchievementsView()
        setupFastingTrackerView()
        setupStatisticsFastingView()
        setupWeightAccountingView()
        setupImtView()
        addBlackTriangle(to: markerImtView)
    }
    
    func setupView() {
        let arrayViews: [UIView] = [achievementsView, fastingTrackerView, statisticsFastingView, weightView, imtView]
        for view in arrayViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            // Настройка контейнера с информацией
            view.backgroundColor = backgroundView
            view.layer.cornerRadius = 25
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 8
            view.layer.masksToBounds = false
            view.layer.masksToBounds = true
        }
    }
    
    func setupSettingsButton() {
        settingsButton.backgroundColor = backgroundView
        settingsButton.layer.cornerRadius = 15
        settingsButton.layer.masksToBounds = true
        settingsButton.setTitleColor(.darkGray, for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        // Устанавливаем изображение шестеренки перед текстом
        let gearImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.darkGray)
        settingsButton.setImage(gearImage, for: .normal)
        
        // Устанавливаем текст кнопки
        settingsButton.setTitle(NSLocalizedString("   Налаштування", comment: ""), for: .normal)
        
        // Настроим отступы между изображением и текстом
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)  // отступ для изображения
        settingsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)  // отступ для текста
        
    }
    
    func setupLabelsAchievementsView() {
        
        mainAchievementLabel.text = "Ваші досягнення"
        
        firstLabelAchievementLabel.text = "Днів у додутку"
        let calendar = Calendar.current
        let tempfirstDateUseApp = UserDefaults.standard.object(forKey: "firstDateUseApp") as? Date
        let firstDateUseApp = tempfirstDateUseApp ?? Date()
        let startOfFirstDate = calendar.startOfDay(for: firstDateUseApp)
        let startOfCurrentDate = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: startOfFirstDate, to: startOfCurrentDate)
        firstValueAchievementLabel.text = "\(components.day ?? 0)"
        
        secondLabelAchievementLabel.text = "Загальна кількість годин голодування"
        if let savedData = UserDefaults.standard.data(forKey: "fastingDataKey"),
           let decodedData = try? JSONDecoder().decode([FastingDataEntry].self, from: savedData) {
            profileFastingData = decodedData
        }
        var totalHours: CGFloat = 0
        for entry in profileFastingData {
            totalHours += entry.hours
        }
        // Округляем до целого числа
        let roundedTotalHours = Int(round(totalHours))
        secondValueAchievementLabel.text = "\(roundedTotalHours)"
        
        thirdLabelAchievementLabel.text = "Поточний план голодування"
        var valueString: String = ""
        if let rawValue = UserDefaults.standard.string(forKey: "selectedMyPlan") {
            valueString = rawValue
        }
        thirdValueAchievementLabel.text = valueString
        
        fourthLabelAchievementLabel.text = "Днів, коли ви голодували"
        var uniqueDaysSet = Set<String>()  // Множество для уникальных дат
        for entry in profileFastingData {
            if entry.hours > 1 {
                uniqueDaysSet.insert(entry.date)  // Добавляем дату в множество
            }
        }
        tottalDaysFasting = uniqueDaysSet.count
        fourthValueAchievementLabel.text = "\(tottalDaysFasting)"  // Количество уникальных дней
        
        fifthLabelAchievementLabel.text = "Максимальна тривалість голодування"
        if let savedDataCycle = UserDefaults.standard.data(forKey: "fastingDataCycleKey"),
           let decodedData = try? JSONDecoder().decode([FastingDataCycle].self, from: savedDataCycle) {
            profileFastingDataCycle = decodedData
        }
        // Находим максимальное значение по hoursFasting
        if let maxFasting = profileFastingDataCycle.max(by: { $0.hoursFasting < $1.hoursFasting }) {
            fifthValueAchievementLabel.text = "\(Int(maxFasting.hoursFasting))"
        } else {
            fifthValueAchievementLabel.text = "0"
        }
        
        sixthLabelAchievementLabel.text = "Мінімальна тривалість голодування"
        // Находим минимальное значение по hoursFasting
        if let minFasting = profileFastingDataCycle.min(by: { $0.hoursFasting < $1.hoursFasting }) {
            sixthValueAchievementLabel.text = "\(Int(minFasting.hoursFasting))"
        } else {
            sixthValueAchievementLabel.text = "0"
        }
    }
    
    func setupFastingTrackerView() {
        chartView.data = fastingTracker.getFastingData().map { ($0.date, $0.hours) }
        
        if fastingTracker.fastingData.isEmpty {
            imageWhenViewIsEmpty(fastingTrackerView)
        } else {
            fastingTrackerView.addSubview(chartView)
            chartView.translatesAutoresizingMaskIntoConstraints = false
            fastingTrackerView.heightAnchor.constraint(equalToConstant: 200).isActive = true // Задай нужную высоту
            
            
            NSLayoutConstraint.activate([
                chartView.leadingAnchor.constraint(equalTo: fastingTrackerView.leadingAnchor, constant: 10),
                chartView.trailingAnchor.constraint(equalTo: fastingTrackerView.trailingAnchor, constant: -10),
                chartView.topAnchor.constraint(equalTo: fastingTrackerView.topAnchor, constant: 10),
                chartView.bottomAnchor.constraint(equalTo: fastingTrackerView.bottomAnchor, constant: -10)
            ])
        }
    }
    
    func setupStatisticsFastingView() {
        statisticsFastingLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        statisticsFastingLabel.textColor = .black
        statisticsFastingLabel.text = "Загальний час голодування  \(tottalDaysFasting) д."
        
        
        setupProgressStatics()
        // Установим цвет прогресс-бара
        progressStatisticView.progressTintColor = .systemGreen // Зеленый для заполненной части
        // Устанавливаем цвет не заполненной части прогресс-бара
        progressStatisticView.trackTintColor = .gray // Серый для не заполненной части
        progressStatisticView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Толщина в 3 раза больше стандартной
        
        dot1.layer.cornerRadius = dot1.frame.size.width / 2
        dot2.layer.cornerRadius = dot2.frame.size.width / 2
        dot3.layer.cornerRadius = dot3.frame.size.width / 2
        
        
        // Изменяем цвет точек в зависимости от прогресса
        // Рассчитаем позицию точек на основе текущего прогресса
        let progressWidth = progressStatisticView.frame.width
        let progress = progressStatisticView.progress
        dot1.backgroundColor = .systemGreen
        dot2.backgroundColor = progress >= 0.43 ? .systemGreen : .gray // 0.4327
        dot3.backgroundColor = progress >= 0.86 ? .systemGreen : .gray // 0.8655
        
        let imageView = UIImageView(image: UIImage(named: "dropMarketLabel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit  // Сохраняет пропорции изображения
        imageView.clipsToBounds = true  // Обрезает изображение по границам

        dropMarketView.addSubview(imageView)
        moveDropMarketView()
        
        dot1Label.text = "0"
        dot2Label.text = "7"
        dot3Label.text = "14"
        
        progressDidChange()
        
    }
    
    @objc func progressDidChange() {
        // Убираем старую маску
        progressStatisticView.layer.mask = nil
        // Создаем маску с прозрачностью для правой части
        let maskLayer = CALayer()
        maskLayer.frame = progressStatisticView.bounds
        let progressWidth = progressStatisticView.bounds.width * CGFloat(progressStatisticView.progress)
        // Создаем градиент
        let gradient = CAGradientLayer()
        gradient.frame = maskLayer.bounds
        gradient.colors = [UIColor.gray.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [NSNumber(value: 0.9), NSNumber(value: 1.0)]  // Сначала непрозрачная, потом прозрачная часть
        // Применяем маску
        maskLayer.addSublayer(gradient)
        progressStatisticView.layer.mask = maskLayer
    }
// MARK: Перемещение View за прогрессом
    @objc func moveDropMarketView() {
        let progressWidth = progressStatisticView.bounds.width * CGFloat(progressStatisticView.progress)
        // Убираем возможность автогенерации констрейнтов для dropMarketView, чтобы вручную управлять констрейнтами
        dropMarketView.translatesAutoresizingMaskIntoConstraints = false
        // Если у вас уже есть старые констрейнты для dropMarketView, находим и удаляем только тот, который отвечает за позицию по X
        if let existingConstraint = dropMarketView.superview?.constraints.first(where: {
            $0.firstItem as? UIView == dropMarketView && $0.firstAttribute == .leading
        }) {
            dropMarketView.superview?.removeConstraint(existingConstraint)
        }
        // Создаем новый констрейнт только для изменения позиции по оси X
        let leadingConstraint = dropMarketView.leadingAnchor.constraint(equalTo: progressStatisticView.leadingAnchor, constant: progressWidth - dropMarketView.bounds.width / 1.5)
        leadingConstraint.isActive = true
        
        // Применяем обновления для метки
        dropMarketView.superview?.layoutIfNeeded()
    }

    func setupProgressStatics() {
      
        let constFactor = tottalDaysFasting % 7
        
        dot2LabelText  = "\(constFactor * 7)"
        dot3LabelText = "\(constFactor * 14)"
        
        if tottalDaysFasting < 15 {
            progressStatisticView.progress = 0.06181 * Float(tottalDaysFasting)
        } else {
            progressStatisticView.progress = 0.06181 * Float(tottalDaysFasting - 7 * (constFactor - 1))
        }
    }
    
    func imageWhenViewIsEmpty(_ view: UIView) {
        let emptyImageView = UIImageView(image: UIImage(named: "AppIconFasting"))
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyImageView)
        view.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 0.91, alpha: 1.0)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            emptyImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.99)
        ])
    }
    
    func setupWeightAccountingView() {
        imageWhenViewIsEmpty(weightView)
    }
    
    func setupImtView() {
        //imageWhenViewIsEmpty(imtView)
        setupProgressImt()
        
        changeWeightImtViewButton.layer.cornerRadius = 20
        changeWeightImtViewButton.layer.masksToBounds = true
        changeWeightImtViewButton.backgroundColor = .lightGray
        let originalImage = UIImage(named: "iconPencil")
        let scaledImage = originalImage?.resized(to: CGSize(width: 25, height: 25))
        changeWeightImtViewButton.setImage(scaledImage, for: .normal) // Устанавливаем уменьшенное изображение на кнопку
        changeWeightImtViewButton.contentMode = .center // Центрируем изображение на кнопке
        changeWeightImtViewButton.imageEdgeInsets = .zero

        
        countImtView.text = "\(imtCount)"
        updateImtMarker(for: imtCount) // Пример для ИМТ 30.9
        
        switch imtCount {
        case ..<16:
            descriptionImtView.text = text15Imt
        case 16..<18:
            descriptionImtView.text = text16Imt
        case 18..<25:
            descriptionImtView.text = text18Imt
        case 25..<30:
            descriptionImtView.text = text25Imt
        case 30..<35:
            descriptionImtView.text = text30Imt
        case 35..<40:
            descriptionImtView.text = text35Imt
        default:
            descriptionImtView.text = text40Imt
        }


    
    }
    
    func setupProgressImt() {
        guard progressImtView.bounds.width > 0 else { return } // Защита от краша

        progressImtView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // Очищаем старые слои
        progressImtView.transform = CGAffineTransform(scaleX: 1.0, y: 2.5) // Толщина

        // Ширина всей шкалы
        let totalWidth: CGFloat = 300
        let totalMargins: CGFloat = 0.01 * totalWidth * 5 // Уменьшили отступы между сегментами
        let availableWidth: CGFloat = totalWidth - totalMargins // Доступная ширина для сегментов

        // Распределяем доступную ширину между сегментами
        let segmentWidths = [
            (1.0 / 25.0),  // 15-16
            (2.5 / 25.0),  // 16-18.5
            (6.5 / 25.0),  // 18.5-25
            (5.0 / 25.0),  // 25-30
            (5.0 / 25.0),  // 30-35
            (5.0 / 25.0)   // 35-40
        ].map { $0 * availableWidth }

        // Масштабируем так, чтобы в сумме они дали доступную ширину
        let totalSegmentWidth = segmentWidths.reduce(0, +)
        let scaleFactor = availableWidth / totalSegmentWidth
        let scaledSegmentWidths = segmentWidths.map { $0 * scaleFactor }

        // Массив цветов для каждого сегмента
        let colors: [UIColor] = [
            .blue,        // <16
            .systemBlue,  // 16-18.5
            .green,       // 18.5-25
            .yellow,      // 25-30
            .orange,      // 30-35
            .red          // >35
        ]

        var currentX: CGFloat = 0
        for (index, segmentWidth) in scaledSegmentWidths.enumerated() {
            // Сегмент с заданным цветом
            let segmentLayer = CALayer()
            segmentLayer.frame = CGRect(x: currentX, y: 0, width: segmentWidth, height: progressImtView.bounds.height)
            segmentLayer.backgroundColor = colors[index].cgColor
            
            // Добавляем закругления
            segmentLayer.cornerRadius = progressImtView.bounds.height / 2
            segmentLayer.masksToBounds = true

            // Добавляем сегмент на шкалу
            progressImtView.layer.addSublayer(segmentLayer)

            // Обновляем текущую позицию для следующего сегмента
            currentX += segmentWidth + 0.01 * totalWidth  // Уменьшенные отступы
        }
        
        // Маска с закруглениями
        let maskLayer = createRoundedSegmentsMask()
        progressImtView.layer.mask = maskLayer
    }

    // ✅ Маска с правильными закруглениями
    func createRoundedSegmentsMask() -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()

        let totalWidth: CGFloat = 300 // Ширина всей шкалы
        let totalMargins: CGFloat = 0.01 * totalWidth * 5 // Уменьшенные отступы между сегментами
        let availableWidth: CGFloat = totalWidth - totalMargins // Доступная ширина для сегментов

        // Распределяем доступную ширину между сегментами
        let segmentWidths = [
            (1.0 / 25.0),  // 15-16
            (2.5 / 25.0),  // 16-18.5
            (6.5 / 25.0),  // 18.5-25
            (5.0 / 25.0),  // 25-30
            (5.0 / 25.0),  // 30-35
            (5.0 / 25.0)   // 35-40
        ].map { $0 * availableWidth }

        // Масштабируем так, чтобы в сумме они дали доступную ширину
        let totalSegmentWidth = segmentWidths.reduce(0, +)
        let scaleFactor = availableWidth / totalSegmentWidth
        let scaledSegmentWidths = segmentWidths.map { $0 * scaleFactor }

        var currentX: CGFloat = 0
        for segmentWidth in scaledSegmentWidths {
            let rect = CGRect(x: currentX, y: 0, width: segmentWidth, height: progressImtView.bounds.height)
            let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: progressImtView.bounds.height / 2)
            path.append(roundedRect)

            // Добавляем отступ между сегментами
            currentX += segmentWidth + 0.01 * totalWidth  // Уменьшенные отступы
        }

        maskLayer.path = path.cgPath
        return maskLayer
    }



    
     func updateImtMarker(for imt: CGFloat) {
        let minIMT: CGFloat = 15
        let maxIMT: CGFloat = 40
        let progress = (imt - minIMT) / (maxIMT - minIMT)
        let progressWidth = progressImtView.bounds.width

        // Проверка на нулевую ширину
        if progressWidth == 0 { return }

        let markerX = progress * progressWidth

        // Убираем возможность автогенерации констрейнтов для markerImtView, чтобы вручную управлять констрейнтами
        markerImtView.translatesAutoresizingMaskIntoConstraints = false

        // Если у вас уже есть старые констрейнты для markerImtView, находим и удаляем только тот, который отвечает за позицию по X
        if let existingConstraint = markerImtView.superview?.constraints.first(where: {
            $0.firstItem as? UIView == markerImtView && $0.firstAttribute == .leading
        }) {
            markerImtView.superview?.removeConstraint(existingConstraint)
        }

        // Создаем новый констрейнт только для изменения позиции по оси X
        let leadingConstraint = markerImtView.leadingAnchor.constraint(equalTo: progressImtView.leadingAnchor, constant: markerX - markerImtView.bounds.width / 8)
        leadingConstraint.isActive = true

        // Применяем обновления для маркера
        markerImtView.superview?.layoutIfNeeded()
    }
    
    func addBlackTriangle(to view: UIView) {
        view.backgroundColor = .clear  // Устанавливаем прозрачный фон
        view.layer.sublayers?.removeAll()  // Убираем все старые слои
        // Создаем слой для треугольника
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height))  // Вершина треугольника вниз
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))  // Левый верхний угол
        trianglePath.addLine(to: CGPoint(x: view.bounds.width, y: 0))  // Правый верхний угол
        trianglePath.close()  // Закрываем путь
        
        // Настроим слой с треугольником
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.black.cgColor  // Чёрный цвет
        
        // Добавляем слой в вью
        view.layer.addSublayer(triangleLayer)
    }




 
    @objc func openSettings() {
        //        let settingsVC = SettingsViewController() // Замените на ваш класс настроек
        //        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
