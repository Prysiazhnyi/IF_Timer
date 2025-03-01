import UIKit

class WeightChartView: UIView {
    // MARK: - Properties
    var weightData: [(date: Date, weight: Double)] = [] // Массив кортежей для даты и веса
    private let scrollView = UIScrollView() // Для скроллинга, если больше 5 точек
    private let graphContentView = UIView() // Контейнер для графика внутри scrollView
    private let yAxisView = UIView() // Фиксированная шкала Y вне scrollView
    
    // Фиксированные размеры
    private let fixedWidth: CGFloat = 340
    private let fixedHeight: CGFloat = 200
    private let yAxisWidth: CGFloat = 35 // Ширина шкалы Y
    private let padding: CGFloat = 10 // Отступы слева и справа для графика
    
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
    
    // Восстановление данных из UserDefaults
    func loadWeightData() {
        if let savedData = UserDefaults.standard.array(forKey: "weightDataArray") as? [[String: Any]] {
            weightData = savedData.compactMap { dict in
                guard let dateString = dict["date"] as? String,
                      let weight = dict["weight"] as? Double,
                      let date = ISO8601DateFormatter().date(from: dateString) else {
                    return nil
                }
                return (date: date, weight: weight)
            }
         updateChart()
    } else {
        updateChart() // Отобразить тестовые данные, если данных нет
    }
    }
    
    // MARK: - Setup
    private func setupView() {
        // Устанавливаем фиксированные размеры
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: fixedWidth, height: fixedHeight)
        
        backgroundColor = .clear
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
        
        if weightData.isEmpty {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
                weightData = [
                    (date: dateFormatter.date(from: "2025-02-24T00:00:00Z")!, weight: 118.6),
                    (date: dateFormatter.date(from: "2025-02-25T00:00:00Z")!, weight: 117.5),
                    (date: dateFormatter.date(from: "2025-02-26T00:00:00Z")!, weight: 116.8),
                    (date: dateFormatter.date(from: "2025-02-27T00:00:00Z")!, weight: 115.9),
                    (date: dateFormatter.date(from: "2025-02-28T00:00:00Z")!, weight: 114.3),
                    (date: dateFormatter.date(from: "2025-03-01T00:00:00Z")!, weight: 114.3),
                    (date: dateFormatter.date(from: "2025-03-02T00:00:00Z")!, weight: 110.3),
                    (date: dateFormatter.date(from: "2025-03-03T00:00:00Z")!, weight: 112.3)
                ]
            }
    }
    
    // MARK: - Chart Drawing
     func updateChart() {
        print("weightData - updateChart - updateChart  \(weightData)")
        
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
                noDataLabel.rightAnchor.constraint(equalTo: graphContentView.rightAnchor, constant: 205),
               // noDataLabel.centerXAnchor.constraint(equalTo: graphContentView.centerXAnchor, constant: 50),
                noDataLabel.centerYAnchor.constraint(equalTo: graphContentView.centerYAnchor)
            ])
            return
        }
        
        // Сортируем данные по дате
        let sortedData = weightData.sorted { $0.date < $1.date }
        
        // Ограничиваем до 5 точек для отображения, если больше
        let displayData = Array(sortedData.prefix(5))
        let minY = displayData.map { $0.weight }.min() ?? 50 - 1
        let maxY = displayData.map { $0.weight }.max() ?? 120 + 1
        
        // Фиксированные размеры графика
        let graphHeight = fixedHeight - 40 // Учитываем отступы сверху и снизу (20 + 20)
        let graphWidth: CGFloat
        let totalPoints = displayData.count
        
        if totalPoints <= 5 {
            graphWidth = fixedWidth - yAxisWidth - (padding * 2) // Фиксированная ширина для 1–5 точек
        } else {
            graphWidth = CGFloat(totalPoints) * 62 // Динамическая ширина для скроллинга
        }
        
        // Устанавливаем ширину contentView
        graphContentView.widthAnchor.constraint(equalToConstant: graphWidth).isActive = true
        
        // Настраиваем contentSize для scrollView
        scrollView.contentSize = CGSize(width: graphWidth + (padding * 2), height: fixedHeight)
        
        // Распределяем точки
        let xSpacing: CGFloat
        if totalPoints > 1 {
            xSpacing = (graphWidth - padding * 2) / CGFloat(totalPoints)
        } else {
            xSpacing = graphWidth / 2
        }
        
        // Рисуем ось X (даты)
        for (index, entry) in displayData.enumerated() {
            let x = totalPoints == 1 ? (graphWidth - padding * 7) / 2 : CGFloat(index) * xSpacing + padding
            let dateLabel = UILabel()
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.text = entry.date.toString(format: "dd MMM") // Формат даты, например, "24 фев"
            dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
            dateLabel.textColor = .gray
            graphContentView.addSubview(dateLabel)
            
            NSLayoutConstraint.activate([
                dateLabel.bottomAnchor.constraint(equalTo: graphContentView.bottomAnchor, constant: 1),
                dateLabel.centerXAnchor.constraint(equalTo: graphContentView.leadingAnchor, constant: x + yAxisWidth)
            ])
        }
        
        // Рисуем фиксированную ось Y (значения веса) вне scrollView
        let ySteps = 5 // Количество отметок на оси Y
        let ySpacing = graphHeight / CGFloat(ySteps)
        for i in 0...ySteps {
            let yValue = maxY - (CGFloat(i) * (maxY - minY) / CGFloat(ySteps))
            let y = CGFloat(i) * ySpacing + 15 // Сдвиг для верхнего отступа
        
            let yLabel = UILabel()
            yLabel.translatesAutoresizingMaskIntoConstraints = false
            yLabel.text = String(Int(yValue))
            yLabel.font = .systemFont(ofSize: 14, weight: .regular)
            yLabel.textColor = .gray
            yAxisView.addSubview(yLabel)
            
            NSLayoutConstraint.activate([
                yLabel.trailingAnchor.constraint(equalTo: yAxisView.trailingAnchor, constant: -2), // Привязка к правому краю шкалы Y
                yLabel.centerYAnchor.constraint(equalTo: yAxisView.topAnchor, constant: y)
            ])
        }
        
        // Рисуем линии разметки по оси Y в graphContentView с отступами
        let gridLines: [CAShapeLayer] = (0...ySteps).map { i in
            let y = CGFloat(i) * ySpacing + 15 // Позиция Y соответствует меткам
            let path = UIBezierPath()
            let leftPadding = padding // Отступ слева (используем padding, чтобы совпадало с отступами точек)
            let rightPadding = padding // Отступ справа (также используем padding для симметрии)
            path.move(to: CGPoint(x: leftPadding, y: y)) // Начало линии с отступом слева
            path.addLine(to: CGPoint(x: graphWidth - rightPadding, y: y)) // Конец линии с отступом справа
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.3).cgColor // Цвет линий разметки
            shapeLayer.lineWidth = 0.5 // Тонкие линии для разметки
            return shapeLayer
        }

        // Добавляем линии в graphContentView
        gridLines.forEach { graphContentView.layer.addSublayer($0) }
        
        // Рисуем график
        let path = UIBezierPath()
        var firstPoint = true
        
        for (index, entry) in displayData.enumerated() {
            let x = totalPoints == 1 ? (graphWidth - padding * 7) / 2 : CGFloat(index) * xSpacing + padding
            let yRange = maxY - minY == 0 ? 1 : maxY - minY
            let normalizedY = (maxY - entry.weight) / yRange * graphHeight + 20 // Сдвиг для верхнего отступа
            
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
            pointView.backgroundColor = .systemGreen
            pointView.layer.cornerRadius = 9
            graphContentView.addSubview(pointView)
            
            NSLayoutConstraint.activate([
                pointView.centerXAnchor.constraint(equalTo: graphContentView.leadingAnchor, constant: x + yAxisWidth),
                pointView.centerYAnchor.constraint(equalTo: graphContentView.topAnchor, constant: normalizedY),
                pointView.widthAnchor.constraint(equalToConstant: 18),
                pointView.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        // Рисуем линию графика
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        graphContentView.layer.addSublayer(shapeLayer)
        
        // Скроллим к концу, если точек больше 5
        if totalPoints > 5 {
            let contentWidth = scrollView.contentSize.width
            let scrollViewWidth = scrollView.bounds.width
            let offsetX = max(0, contentWidth - scrollViewWidth) // Прокрутка к правому краю
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false) // Без анимации для немедленного скроллинга
        }
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
