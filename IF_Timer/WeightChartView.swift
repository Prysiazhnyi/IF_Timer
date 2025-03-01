// WeightChartView.swift
import UIKit

class WeightChartView: UIView {
    // MARK: - Properties
    private var weightData: [String: Double] = [:] // Хранение данных веса в формате ISO 8601
    private let lineColor = UIColor(red: 181/255, green: 228/255, blue: 217/255, alpha: 1) // Светло-зеленый
    private let pointColor = UIColor(red: 181/255, green: 228/255, blue: 217/255, alpha: 1) // Цвет точек
    private let pointBorderColor = UIColor.black // Черная обводка точек
    
    private let scrollView = UIScrollView() // Для скроллинга, если больше 6 точек
    private let graphContentView = UIView() // Контейнер для графика внутри scrollView
    private let yAxisView = UIView() // Фиксированная шкала Y вне scrollView
    
    // Фиксированные размеры
    private let fixedWidth: CGFloat = 340
    private let fixedHeight: CGFloat = 200
    private let yAxisWidth: CGFloat = 30 // Ширина шкалы Y
    private let padding: CGFloat = 20 // Отступы слева и справа для графика
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadWeightData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        loadWeightData()
    }
    
    // MARK: - Setup
    private func setupView() {
        // Устанавливаем фиксированные размеры
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: fixedWidth, height: fixedHeight)
        
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        
        // Фиксированная шкала Y
        yAxisView.translatesAutoresizingMaskIntoConstraints = false
        yAxisView.backgroundColor = .clear
        addSubview(yAxisView)
        
        // ScrollView для графика
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        // ContentView внутри ScrollView
        graphContentView.translatesAutoresizingMaskIntoConstraints = false
        graphContentView.backgroundColor = .clear
        scrollView.addSubview(graphContentView)
        
        // Constraints для фиксированных размеров
        NSLayoutConstraint.activate([
            yAxisView.topAnchor.constraint(equalTo: topAnchor),
            yAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yAxisView.widthAnchor.constraint(equalToConstant: yAxisWidth),
            yAxisView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: yAxisView.trailingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: fixedWidth - yAxisWidth),
            scrollView.heightAnchor.constraint(equalToConstant: fixedHeight),
            
            graphContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            graphContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            graphContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            graphContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            graphContentView.heightAnchor.constraint(equalToConstant: fixedHeight)
        ])
        
        // Инициализация данных (пример с датой и временем)
        weightData = [
            "2025-02-24T00:00:00Z": 118.6,
            "2025-02-25T00:00:00Z": 117.5,
            "2025-02-26T00:00:00Z": 116.8,
            "2025-02-27T00:00:00Z": 115.9,
            "2025-02-28T00:00:00Z": 114.3
        ]
    }
    
    // MARK: - Data Management
    private func loadWeightData() {
        if let savedData = UserDefaults.standard.dictionary(forKey: "weightDataString") as? [String: Double] {
            weightData = savedData
            updateChart()
        } else {
            updateChart() // Отобразить пустой график, если данных нет
        }
    }
    
    private func saveWeightData() {
        UserDefaults.standard.set(weightData, forKey: "weightDataString")
    }
    
    // MARK: - Chart Drawing
    private func updateChart() {
        // Очистка графика
        graphContentView.subviews.forEach { $0.removeFromSuperview() }
        graphContentView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        yAxisView.subviews.forEach { $0.removeFromSuperview() }
        
        // Если данных нет, показываем пустой график
        guard !weightData.isEmpty else {
            let noDataLabel = UILabel()
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            noDataLabel.text = "Нет данных о весе"
            noDataLabel.textColor = .gray
            noDataLabel.font = .systemFont(ofSize: 16, weight: .regular)
            graphContentView.addSubview(noDataLabel)
            
            NSLayoutConstraint.activate([
                noDataLabel.centerXAnchor.constraint(equalTo: graphContentView.centerXAnchor),
                noDataLabel.centerYAnchor.constraint(equalTo: graphContentView.centerYAnchor)
            ])
            return
        }
        
        // Сортируем даты
        let sortedDates = weightData.keys.sorted()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Ограничиваем до 6 точек для отображения, если больше
        let displayDates = Array(sortedDates.prefix(6))
        let minY = weightData.values.min() ?? 57 // Минимальное значение веса (57 кг)
        let maxY = weightData.values.max() ?? 99 // Максимальное значение веса (99 кг)
        
        // Фиксированные размеры графика
        let graphHeight = fixedHeight - 40 // Учитываем отступы сверху и снизу (20 + 20)
        let graphWidth: CGFloat
        let totalPoints = displayDates.count
        
        if totalPoints <= 6 {
            graphWidth = fixedWidth - yAxisWidth - (padding * 2) // Фиксированная ширина для 1–6 точек с учетом шкалы Y и отступов
        } else {
            graphWidth = CGFloat(totalPoints) * 60 // Динамическая ширина для скроллинга (60 — ширина точки + отступы)
        }
        
        // Устанавливаем ширину contentView
        graphContentView.widthAnchor.constraint(equalToConstant: graphWidth).isActive = true
        
        // Настраиваем contentSize для scrollView
        scrollView.contentSize = CGSize(width: graphWidth + (padding * 2), height: fixedHeight)
        
        // Распределяем точки
        let xSpacing: CGFloat
        if totalPoints == 1 {
            xSpacing = 0 // Одна точка — посередине
        } else {
            xSpacing = (graphWidth - padding * 2) / CGFloat(max(1, totalPoints - 1)) // Равномерное распределение с учетом отступов
        }
        
        // Рисуем ось X (даты)
        for (index, dateString) in displayDates.enumerated() {
            let x = totalPoints == 1 ? (graphWidth + padding) / 2 : CGFloat(index) * xSpacing + padding
            guard let date = dateFormatter.date(from: dateString) else { continue }
            let dateLabel = UILabel()
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.text = date.toString(format: "dd MMM") // Формат даты, например, "24 фев"
            dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
            dateLabel.textColor = .gray
            graphContentView.addSubview(dateLabel)
            
            NSLayoutConstraint.activate([
                dateLabel.bottomAnchor.constraint(equalTo: graphContentView.bottomAnchor, constant: -5),
                dateLabel.centerXAnchor.constraint(equalTo: graphContentView.leadingAnchor, constant: x + yAxisWidth) // Сдвиг для избежания наложения на шкалу Y
            ])
        }
        
        // Рисуем фиксированную ось Y (значения веса) вне scrollView
        let ySteps = 5 // Количество отметок на оси Y
        let ySpacing = graphHeight / CGFloat(ySteps)
        for i in 0...ySteps {
            let yValue = maxY - (CGFloat(i) * (maxY - minY) / CGFloat(ySteps))
            let y = CGFloat(i) * ySpacing + 20 // Сдвиг для верхнего отступа
        
            let yLabel = UILabel()
            yLabel.translatesAutoresizingMaskIntoConstraints = false
            yLabel.text = String(Int(yValue))
            yLabel.font = .systemFont(ofSize: 12, weight: .regular)
            yLabel.textColor = .gray
            yAxisView.addSubview(yLabel)
            
            NSLayoutConstraint.activate([
                yLabel.trailingAnchor.constraint(equalTo: yAxisView.trailingAnchor), // Привязка к правому краю шкалы Y
                yLabel.centerYAnchor.constraint(equalTo: yAxisView.topAnchor, constant: y)
            ])
        }
        
        // Рисуем график
        let path = UIBezierPath()
        var firstPoint = true
        
        for (index, dateString) in displayDates.enumerated() {
            guard let weight = weightData[dateString] else { continue }
            let x = totalPoints == 1 ? (graphWidth + padding) / 2 : CGFloat(index) * xSpacing + padding
            let yRange = maxY - minY == 0 ? 1 : maxY - minY
            let normalizedY = (maxY - weight) / yRange * graphHeight + 20 // Сдвиг для верхнего отступа
            
            let point = CGPoint(x: x + yAxisWidth, y: normalizedY) // Сдвиг для избежания наложения на шкалу Y
            
            if firstPoint {
                path.move(to: point)
                firstPoint = false
            } else {
                path.addLine(to: point)
            }
            
            // Точка
            let pointView = UIView()
            pointView.translatesAutoresizingMaskIntoConstraints = false
            pointView.backgroundColor = pointColor
            pointView.layer.cornerRadius = 4
            pointView.layer.borderWidth = 1
            pointView.layer.borderColor = pointBorderColor.cgColor
            graphContentView.addSubview(pointView)
            
            NSLayoutConstraint.activate([
                pointView.centerXAnchor.constraint(equalTo: graphContentView.leadingAnchor, constant: x + yAxisWidth),
                pointView.centerYAnchor.constraint(equalTo: graphContentView.topAnchor, constant: normalizedY),
                pointView.widthAnchor.constraint(equalToConstant: 8),
                pointView.heightAnchor.constraint(equalToConstant: 8)
            ])
        }
        
        // Рисуем линию графика
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        graphContentView.layer.addSublayer(shapeLayer)
    }
}

// MARK: - Date Extension
extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "uk_UA")
        return formatter.string(from: self)
    }
}
