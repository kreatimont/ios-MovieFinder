//
//  SuccessIndicator.swift
//  spot2d-dev
//
//  Created by Alexandr Nadtoka on 10/18/18.
//  Copyright © 2018 gmoby-dev. All rights reserved.
//

import UIKit

class SuccessIndicator: UIView {

    let margin: CGFloat
    let strokeWidth: CGFloat
    
    let checkMarkLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        self.margin = frame.width / 10
        self.strokeWidth = frame.width / 20
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.clipsToBounds = true
        
        self.clipsToBounds = true
        
        self.insertSubview(bluredView, at: 0)
        bluredView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not implemented")
    }
    
    //MARK: -public
    
    func animate(duration: Double) {
        self.addAnimation(duration: duration)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    //MARK: -private
    
    private func setup() {
        checkMarkLayer.removeFromSuperlayer()
        checkMarkLayer.removeAllAnimations()
        
        checkMarkLayer.path = self.createPath().cgPath
        
        checkMarkLayer.strokeColor = UIColor.white.cgColor
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.lineWidth = 6.0
        checkMarkLayer.lineCap = .round
        
        checkMarkLayer.strokeEnd = 0
        
        self.layer.addSublayer(checkMarkLayer)
        
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: self.frame.width / 2 - 14, y: self.frame.height / 2)
        let middlePoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 10)
        let endPoint = CGPoint(x: self.frame.width / 2 + 24, y: self.frame.height / 2 - 20)
        
        path.move(to: startPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        
        return path
    }
    
    private func addAnimation(duration: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.byValue = 1.0
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.checkMarkLayer.add(animation, forKey: "drawLineAnimation")
    }
    
}
