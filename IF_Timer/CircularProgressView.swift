//
//  CircularProgressView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit

class CircularProgressView: UIView {
    
    weak var viewController: ViewController?
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var colorStep = UIColor.green.cgColor
    
    // Настройка прогресса (от 0 до 1)
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: frame.size.width / 2 - 10,
                                      startAngle: -CGFloat.pi / 2,
                                      endAngle: 3 * CGFloat.pi / 2,
                                      clockwise: true)
        
        // Трек (фон круга)
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 0.6).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        layer.addSublayer(trackLayer)
        
        // Прогресс
        progressLayer.path = circlePath.cgPath
        
        changeColorProgressView()
        
        //progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 20
        progressLayer.strokeEnd = 0 // Изначально 0% прогресса
        layer.addSublayer(progressLayer)
    }
    
    func changeColorProgressView() {
        guard let viewController = viewController else {return}
        colorStep = !viewController.isStarvation ? UIColor.systemOrange.cgColor : UIColor.green.cgColor
        progressLayer.strokeColor = !viewController.timeIsUp ? colorStep : UIColor.systemPink.cgColor
        viewController.setupTitle()
        viewController.setupTitleProgressLabel()
    }
    
}
