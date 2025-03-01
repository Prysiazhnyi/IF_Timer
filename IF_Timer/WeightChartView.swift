//
//  WeightChartView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 01.03.2025.
//

// WeightChartView.swift
import UIKit

class WeightChartView: UIView {
    // MARK: - Properties
    private var weightData: [String: Double] = [:] // Хранение данных веса в формате ISO 8601
    private let lineColor = UIColor(red: 181/255, green: 228/255, blue: 217/255, alpha: 1) // Светло-зеленый
    private let pointColor = UIColor(red: 181/255, green: 228/255, blue: 217/255, alpha: 1) // Цвет точек
    private let pointBorderColor = UIColor.black // Черная обводка точек
    
    private let graphView = UIView() // Контейнер для графика
    
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
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        
        // График
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.backgroundColor = .clear
        addSubview(graphView)
        
        // Constraints
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            graphView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            graphView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
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
        graphView.subviews.forEach { $0.removeFromSuperview() }
        graphView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Если данных нет, показываем пустой график
        guard !weightData.isEmpty else {
            let noDataLabel = UILabel()
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            noDataLabel.text = "Нет данных о весе"
            noDataLabel.textColor = .gray
            noDataLabel.font = .systemFont(ofSize: 16, weight: .regular)
            graphView.addSubview(noDataLabel)
            
            NSLayoutConstraint.activate([
                noDataLabel.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
                noDataLabel.centerYAnchor.constraint(equalTo: graphView.centerYAnchor)
            ])
            return
        }
        
        // Сортируем даты (строки в формате ISO 8601 можно сортировать напрямую)
        let sortedDates = weightData.keys.sorted()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Преобразуем строки в даты для вычислений
        guard let firstDate = dateFormatter.date(from: sortedDates.first!),
              let lastDate = dateFormatter.date(from: sortedDates.last!) else {
            return
        }
        
        let minY = weightData.values.min() ?? 57 // Минимальное значение веса (57 кг)
        let maxY = weightData.values.max() ?? 99 // Максимальное значение веса (99 кг)
        
        // Находим размеры графика
        let graphHeight = graphView.bounds.height
        let graphWidth = graphView.bounds.width
        
        // Рисуем ось X (даты)
        let xSpacing = graphWidth / CGFloat(sortedDates.count - 1)
        for (index, dateString) in sortedDates.enumerated() {
            let x = CGFloat(index) * xSpacing
            guard let date = dateFormatter.date(from: dateString) else { continue }
            let dateLabel = UILabel()
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.text = date.toString(format: "dd MMM") // Формат даты, например, "24 фев"
            dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
            dateLabel.textColor = .gray
            graphView.addSubview(dateLabel)
            
            NSLayoutConstraint.activate([
                dateLabel.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: -5),
                dateLabel.centerXAnchor.constraint(equalTo: graphView.leadingAnchor, constant: x)
            ])
        }
        
        // Рисуем ось Y (значения веса)
        let ySteps = 5 // Количество отметок на оси Y
        let ySpacing = graphHeight / CGFloat(ySteps)
        for i in 0...ySteps {
            let yValue = maxY - (CGFloat(i) * (maxY - minY) / CGFloat(ySteps))
            let y = CGFloat(i) * ySpacing
            
            let yLabel = UILabel()
            yLabel.translatesAutoresizingMaskIntoConstraints = false
            yLabel.text = String(Int(yValue))
            yLabel.font = .systemFont(ofSize: 12, weight: .regular)
            yLabel.textColor = .gray
            graphView.addSubview(yLabel)
            
            NSLayoutConstraint.activate([
                yLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: -20),
                yLabel.centerYAnchor.constraint(equalTo: graphView.topAnchor, constant: y)
            ])
        }
        
        // Рисуем график
        let path = UIBezierPath()
        var firstPoint = true
        
        for (index, dateString) in sortedDates.enumerated() {
            guard let weight = weightData[dateString] else { continue }
            let x = CGFloat(index) * xSpacing
            let normalizedY = (maxY - weight) / (maxY - minY) * graphHeight
            let point = CGPoint(x: x, y: normalizedY)
            
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
            graphView.addSubview(pointView)
            
            NSLayoutConstraint.activate([
                pointView.centerXAnchor.constraint(equalTo: graphView.leadingAnchor, constant: x),
                pointView.centerYAnchor.constraint(equalTo: graphView.topAnchor, constant: normalizedY),
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
        graphView.layer.addSublayer(shapeLayer)
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
