//
//  FastingChartView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 26.01.2025.
//

import UIKit

class FastingChartView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let scaleView = UIView() // Шкала
    
    var data: [(day: String, fastingHours: CGFloat)] = [] {
        didSet {
            setupBars()
        }
    }
    
    private let maxHours: CGFloat = 24.0 // Максимум часов в сутках
    private let barWidth: CGFloat = 20.0
    private let barSpacing: CGFloat = 16.0
    private let barHeight: CGFloat = 150.0 // Фиксированная высота для всех баров

    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(scrollView)
        addSubview(scaleView)  // Добавляем шкалу в FastingChartView (вне scrollView)

        scrollView.addSubview(contentView)
        
        // Настройка ScrollView
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Настройка автолэйаута
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40), // Увеличиваем отступ для шкалы
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Настройка шкалы (scaleView)
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scaleView.leadingAnchor.constraint(equalTo: leadingAnchor), // Шкала слева
            scaleView.topAnchor.constraint(equalTo: topAnchor),
            scaleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scaleView.widthAnchor.constraint(equalToConstant: 40) // Ширина шкалы
        ])
        
        addScale() // Добавляем метки шкалы
    }

    private func addScale() {
        let stepValues: [Int] = [0, 6, 12, 18, 24] // Шкала от 0 до 24
        
        // Высота шкалы
        let scaleHeight = self.frame.height
        
        // Очистим старые метки, если они есть
        scaleView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, value) in stepValues.enumerated() {
            let label = UILabel()
            label.text = "\(value)"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .darkGray
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            scaleView.addSubview(label)
            
            // Пропорциональное распределение меток от 0 до 24
            let position = (CGFloat(value) / 24.0) * scaleHeight // Рассчитываем позицию по вертикали (от 0 до 24)

            NSLayoutConstraint.activate([
                label.bottomAnchor.constraint(equalTo: scaleView.bottomAnchor, constant: -position),
                label.leadingAnchor.constraint(equalTo: scaleView.leadingAnchor),
                label.widthAnchor.constraint(equalTo: scaleView.widthAnchor),
                label.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
    }


    // MARK: - Отрисовка столбцов
    private func setupBars() {
        // Удаляем старые столбцы
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Рассчитываем ширину contentView
        let contentWidth = CGFloat(data.count) * (barWidth + barSpacing) - barSpacing // Убираем последний отступ
        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true

        // Столбцы
        for (index, item) in data.enumerated() {
            let barView = createBar(day: item.day, fastingHours: item.fastingHours)
            contentView.addSubview(barView)
            
            barView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(index) * (barWidth + barSpacing)),
                barView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), // Столбцы растягиваются от низа
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.heightAnchor.constraint(equalToConstant: barHeight) // Все столбцы имеют одинаковую высоту
            ])
        }
        contentView.layoutIfNeeded() // Обновление верстки
    }

    private func createBar(day: String, fastingHours: CGFloat) -> UIView {
        let barView = UIView()
        
        let totalBar = UIView()
        totalBar.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        totalBar.translatesAutoresizingMaskIntoConstraints = false
        totalBar.layer.cornerRadius = 10.0 // Скругление для общего бара
        totalBar.layer.masksToBounds = true // Обеспечиваем, чтобы скругление применялось к виду

        
        let fastingBar = UIView()
        fastingBar.backgroundColor = UIColor.systemGreen
        fastingBar.translatesAutoresizingMaskIntoConstraints = false
        fastingBar.layer.cornerRadius = 10.0 // Скругление для бара голодания
        fastingBar.layer.masksToBounds = true // Обеспечиваем, чтобы скругление применялось к виду
        
        let label = UILabel()
        label.text = day
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        barView.addSubview(totalBar)
        barView.addSubview(fastingBar)
        barView.addSubview(label)
        
        // Настройка Constraints
        NSLayoutConstraint.activate([
            // Общий столбец
            totalBar.leadingAnchor.constraint(equalTo: barView.leadingAnchor),
            totalBar.trailingAnchor.constraint(equalTo: barView.trailingAnchor),
            totalBar.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -4),
            totalBar.heightAnchor.constraint(equalTo: barView.heightAnchor, multiplier: 1.0),
            
            // Столбец голодания
            fastingBar.leadingAnchor.constraint(equalTo: totalBar.leadingAnchor),
            fastingBar.trailingAnchor.constraint(equalTo: totalBar.trailingAnchor),
            fastingBar.bottomAnchor.constraint(equalTo: totalBar.bottomAnchor),
            fastingBar.heightAnchor.constraint(equalTo: totalBar.heightAnchor, multiplier: fastingHours / maxHours), // Заполнение бара в зависимости от часов голодания
            
            // Метка
            label.leadingAnchor.constraint(equalTo: barView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: barView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return barView
    }
}
