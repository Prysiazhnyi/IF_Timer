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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addScale()  // Обновляем шкалу после того, как размеры точно установлены
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
            scaleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),// выравнивание по высоте с barview
            scaleView.widthAnchor.constraint(equalToConstant: 40) // Ширина шкалы
        ])
        
        //addScale() // Добавляем метки шкалы
    }
    
    private func addScale() {
        // Очистим старые метки, если они есть
        scaleView.subviews.forEach { $0.removeFromSuperview() }
        
        // Параметры для всех меток (одинаковые для всех)
        let scaleLabels = ["0", "6", "12", "18", "24"]
        let font = UIFont.systemFont(ofSize: 12)
        let textColor = UIColor.darkGray
        
        // Вычисляем высоту шкалы
        // let scaleHeight = self.frame.height
        
        // Рассчитываем высоту шкалы относительно barView
        guard let barView = contentView.subviews.first else { return }
        barView.layoutIfNeeded() // Убедимся, что layout обновлен
        let barHeight = barView.frame.height
        print("barHeight - \(barHeight)")
        
        // Добавляем метки по очереди
        for (index, value) in scaleLabels.enumerated() {
            let label = UILabel()
            label.text = value
            label.font = font
            label.textColor = textColor
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            scaleView.addSubview(label)
            
            // Рассчитываем положение метки относительно всей высоты шкалы
            //let relativeHeight = (CGFloat(positions[index]) / 24.0) * barHeight
            
            // Рассчитываем положение метки
            let positionMultiplier = CGFloat(index) / CGFloat(scaleLabels.count - 1) // Пропорциональное положение (0.0, 0.25, 0.5, 0.75, 1.0)
            let relativeHeight = positionMultiplier * (barHeight - font.pointSize) // Высота относительно бара
            
            // Привязываем метки с учетом пропорции от верхней части шкалы
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 20),
                label.leadingAnchor.constraint(equalTo: scaleView.leadingAnchor),
                label.widthAnchor.constraint(equalTo: scaleView.widthAnchor),
                label.bottomAnchor.constraint(equalTo: scaleView.bottomAnchor, constant: -relativeHeight)
            ])
            
            print("relativeHeight - \(relativeHeight)")
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
        // Обновляем верстку
           contentView.layoutIfNeeded()
           scrollView.layoutIfNeeded()
           
           // Перемещаем scrollView на последний элемент
           showLastBar()
    }
    
    private func showLastBar() {
        guard !data.isEmpty else { return } // Проверяем, что данные существуют
        
        let lastBarOffset = CGFloat(data.count) * (barWidth + barSpacing) - scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: max(0, lastBarOffset), y: 0), animated: false)
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
