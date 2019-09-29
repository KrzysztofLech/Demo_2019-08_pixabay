//
//  DownloadingProgressView.swift
//
//  Created by Krzysztof Lech on 29/09/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

/**
Downloading Progress Indicator

 1. To start animation use `startAnimation` method.
 2. Change `progressValue` property to show new progress value.
*/

@IBDesignable
final class DownloadingProgressView: UIView {
    
    @IBInspectable var circleWidth: CGFloat = 3.0
    @IBInspectable var circleColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    
    @IBInspectable var counterSize: CGFloat = 22.0
    @IBInspectable var counterColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
    
    @IBInspectable var progressWidth: CGFloat = 4.0
    @IBInspectable var progressColor: UIColor = .blue
    @IBInspectable var progressValue: Float = 0.0 {
        didSet {
            setCounterText()
            showNewProgressValue()
        }
    }
    
    private var diameter: CGFloat = 0.0
    private var maxWidth: CGFloat {
        return max(circleWidth, progressWidth)
    }
    private var formattedText: String {
        return String(format: "%i%@", Int(progressValue * 100), "%")
    }
    
    // MARK: - View objects
    
    private var progressView = UIView()
    private var progressShapeLayer = CAShapeLayer()
    private var counterLabel = UILabel()
     
    // MARK: - Init methods
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Setup methods
    
    private func setup() {
        setupDiameter()
        drawCircle()
        createProgressView()
        addCounterLabel()
    }
    
    private func setupDiameter() {
        diameter = min(bounds.width, bounds.height) - maxWidth
    }
            
    private func drawCircle() {
        let rectangle = CGRect(
            x: maxWidth/2, y: maxWidth/2,
            width: diameter, height: diameter
        )
        let path = UIBezierPath(ovalIn: rectangle)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = circleWidth
        shapeLayer.strokeColor = circleColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    private func createProgressView() {
        progressView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        setupProgressShapeLayer()
        progressView.layer.addSublayer(progressShapeLayer)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: widthAnchor),
            progressView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func setupProgressShapeLayer() {
        let rectangle = CGRect(
            x: maxWidth/2, y: maxWidth/2,
            width: diameter, height: diameter
        )
        let path = UIBezierPath(ovalIn: rectangle)

        progressShapeLayer.path = path.cgPath
        progressShapeLayer.lineWidth = progressWidth
        progressShapeLayer.strokeColor = progressColor.cgColor
        progressShapeLayer.fillColor = UIColor.clear.cgColor
        progressShapeLayer.lineCap = .round
        progressShapeLayer.strokeEnd = CGFloat(progressValue)
    }
    
    private func addCounterLabel() {
        counterLabel.text = formattedText
        counterLabel.textColor = counterColor
        counterLabel.font = UIFont.systemFont(ofSize: counterSize, weight: .ultraLight)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(counterLabel)
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Change Progress Value methods
    
    private func setCounterText() {
        counterLabel.text = formattedText
    }
    
    private func showNewProgressValue() {
        progressShapeLayer.strokeEnd = CGFloat(progressValue)
    }
    
    // MARK: - Animation method
    
    func startAnimation(withInitialProgressValue value: Float = 0.0) {
        progressValue = value
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0.0 - .pi/2
        rotate.toValue = CGFloat.pi * 2 - .pi/2
        rotate.duration = 1.2
        rotate.repeatCount = Float.infinity
        progressView.layer.add(rotate, forKey: nil)
    }
}
