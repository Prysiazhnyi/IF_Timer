//
//  FastingChartView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 26.01.2025.
//

import Foundation
import UIKit

class FastingChartView: UIView {
    
    // MARK: - Параметры диаграммы
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let scaleView = UIView() // Шкала
    
    
    var data: [(day: String, fastingHours: CGFloat)] = [] {
        didSet {
            setupBars()
            print("Data count: \(data.count)")

        }
    }
    
    private let maxHours: CGFloat = 24.0 // Максимум часов в сутках
    private let barWidth: CGFloat = 20.0
    private let barSpacing: CGFloat = 16.0

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
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func addScale() {
            let stepValues: [Int] = [0, 6, 12, 18, 24] // Шкала от 0 до 24
            
            // Высота шкалы
            let scaleHeight = self.frame.height
            
            // Распределение шагов шкалы по высоте
            let stepHeight = scaleHeight / CGFloat(stepValues.count - 1)
            
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
                
                // Размещение меток от нижней границы
                NSLayoutConstraint.activate([
                    label.bottomAnchor.constraint(equalTo: scaleView.bottomAnchor, constant: -(CGFloat(index) * stepHeight)),
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
        
        // Получаем высоту родительского вью для корректной пропорции
            let chartHeight = self.frame.height
        
        // Рассчитываем ширину contentView
        let contentWidth = CGFloat(data.count) * (barWidth + barSpacing) - barSpacing // Убираем последний отступ
        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = false
        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true

           // Столбцы
        for (index, item) in data.enumerated() {
            let barView = createBar(day: item.day, fastingHours: item.fastingHours)
            contentView.addSubview(barView)
            
            barView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(index) * (barWidth + barSpacing)),
                barView.topAnchor.constraint(equalTo: contentView.topAnchor),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        let offsetX = max(0, contentView.frame.width - scrollView.frame.width)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

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
            fastingBar.heightAnchor.constraint(equalTo: totalBar.heightAnchor, multiplier: fastingHours / maxHours),
            
            // Метка
            label.leadingAnchor.constraint(equalTo: barView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: barView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return barView
    }
}

