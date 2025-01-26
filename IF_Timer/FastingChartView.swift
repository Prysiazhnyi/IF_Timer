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
        addScale()  // Добавляем шкалу сразу в основной контейнер (не в scrollView)
        scrollView.addSubview(contentView)
        
        // Конфигурация ScrollView
        scrollView.showsHorizontalScrollIndicator = false
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
    
    // MARK: - Отрисовка столбцов
//    private func setupBars() {
//        // Удаляем старые столбцы
//        contentView.subviews.forEach { $0.removeFromSuperview() }
//        
//        // Рассчитываем ширину contentView
//        let contentWidth = CGFloat(data.count) * (barWidth + barSpacing)
//        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
//        
//        for (index, item) in data.enumerated() {
//            let barView = createBar(day: item.day, fastingHours: item.fastingHours)
//            contentView.addSubview(barView)
//            
//            // Устанавливаем позицию
//            let xPosition = CGFloat(index) * (barWidth + barSpacing)
//            barView.frame = CGRect(x: xPosition, y: 0, width: barWidth, height: contentView.frame.height)
//        }
//        contentView.layoutIfNeeded() // обновление верстки
//        contentView.backgroundColor = .lightGray
//
//        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = false
//        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
//
//    }
    
    private func setupBars() {
        // Удаляем старые столбцы
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
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

    private func addScale() {
        let scaleView = UIView()
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scaleView)  // Добавляем шкалу в FastingChartView, а не в contentView
        
        // Настройка Constraints для шкалы
        NSLayoutConstraint.activate([
            scaleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Расположение шкалы слева
            scaleView.topAnchor.constraint(equalTo: topAnchor),  // Шкала начинается сверху
            scaleView.bottomAnchor.constraint(equalTo: bottomAnchor),  // Шкала занимает всю высоту
            scaleView.widthAnchor.constraint(equalToConstant: 40)  // Ширина шкалы
        ])
        
        let stepValues: [CGFloat] = [0, 6, 12, 18, 24]
        
        for (index, value) in stepValues.enumerated() {
            let label = UILabel()
            label.text = "\(Int(value))"
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            scaleView.addSubview(label)
            
            // Устанавливаем расположение меток по вертикали
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: scaleView.topAnchor, constant: CGFloat(index) * (contentView.frame.height / 5)),
                label.leadingAnchor.constraint(equalTo: scaleView.leadingAnchor),
                label.widthAnchor.constraint(equalTo: scaleView.widthAnchor),
                label.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
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

