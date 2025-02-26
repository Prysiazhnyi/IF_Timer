//
//  GraphStatisticView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 26.02.2025.
//

import UIKit

class GraphStatisticView: UIView {
    var dataPoints: [CGPoint] = [] // Добавляем это свойство

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !dataPoints.isEmpty else { return }
        
        // Настройки линий
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.blue.cgColor)
        
        // Рисуем линии между точками
        context.move(to: dataPoints.first!)
        for point in dataPoints.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
        
        // Рисуем точки
        for point in dataPoints {
            drawCircle(at: point, in: context)
        }
    }

    private func drawCircle(at point: CGPoint, in context: CGContext) {
        let circleRadius: CGFloat = 4
        let circleRect = CGRect(
            x: point.x - circleRadius,
            y: point.y - circleRadius,
            width: circleRadius * 2,
            height: circleRadius * 2
        )
        
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: circleRect)
    }
}
