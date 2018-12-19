//
//  FailureIndicator.swift
//  spot2d-dev
//
//  Created by Alexandr Nadtoka on 10/18/18.
//  Copyright © 2018 gmoby-dev. All rights reserved.
//

import UIKit

class FailureIndicator: UIView {
    
    let margin: CGFloat
    let strokeWidth: CGFloat
    
    let crossLayer = CAShapeLayer()
    
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
        crossLayer.removeFromSuperlayer()
        crossLayer.removeAllAnimations()
        
        crossLayer.path = self.createPath().cgPath
        
        crossLayer.strokeColor = UIColor.white.cgColor
        crossLayer.fillColor = UIColor.clear.cgColor
        crossLayer.lineWidth = 6.0
        crossLayer.lineCap = .round
        
        crossLayer.strokeEnd = 0
        
        self.layer.addSublayer(crossLayer)
        
    }
    
    private func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let startPointLineOne = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height / 2 - 20)
        let endPointLineOne = CGPoint(x: self.frame.width / 2 + 20, y: self.frame.height / 2 + 20)
        
        let startPointLineTwo = CGPoint(x: self.frame.width / 2 + 20, y: self.frame.height / 2 - 20)
        let endPointLineTow = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height / 2 + 20)
        
        path.move(to: startPointLineOne)
        path.addLine(to: endPointLineOne)
        
        path.move(to: startPointLineTwo)
        path.addLine(to: endPointLineTow)
        
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
        self.crossLayer.add(animation, forKey: "drawLineAnimation")
    }
    
}
