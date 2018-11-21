//
//  VerticalProgressBar.swift
//  VHProgressBar
//
//  Created by Sohei Miyakura on 2018/11/21.
//

import UIKit

@IBDesignable
open class VerticalProgressBar: UIView {
    
    fileprivate var progressView: UIView!
    fileprivate var animator: UIViewPropertyAnimator!
    
    @IBInspectable public var bgColor: UIColor = UIColor.white {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable public var barColor: UIColor = UIColor.init(red: 52/255, green: 181/255, blue: 240/255, alpha: 1) {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable public var frameColor: UIColor = UIColor.init(red: 161/255, green: 161/255, blue: 161/255, alpha: 1) {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable public var frameBold: CGFloat = 0.1 {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable public var pgHeight: CGFloat = 200 {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable public var pgWidth: CGFloat = 20 {
        didSet {
            configureView()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initProgressView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initProgressView()
    }
}

extension VerticalProgressBar {
    
    fileprivate func initProgressView() {
        progressView = UIView()
        addSubview(progressView)
    }
    
    fileprivate func configureProgressView() {
        progressView.backgroundColor = barColor
        progressView.frame.size.height = 0
        progressView.frame.size.width = pgWidth
        progressView.frame.origin.y = self.bounds.origin.y + pgHeight
        progressView.layer.cornerRadius = pgWidth / 2
    }
    
    fileprivate func configureView() {
        setBackgroundColor()
        setFrameColor()
        setFrameBold()
        setProgressBarHeight()
        setProgressBarWidth()
        setProgressBarRadius()
    }
    
    fileprivate func setBackgroundColor() {
        self.backgroundColor = bgColor
    }
    
    fileprivate func setFrameColor() {
        self.layer.borderWidth = frameBold
    }
    
    fileprivate func setFrameBold() {
        self.layer.borderColor = frameColor.cgColor
    }
    
    fileprivate func setProgressBarHeight() {
        self.frame.size.height = pgHeight
    }
    
    fileprivate func setProgressBarWidth() {
        self.frame.size.width = pgWidth
    }
    
    fileprivate func setProgressBarRadius() {
        self.layer.cornerRadius = pgWidth / 2
    }
}

extension VerticalProgressBar {
    
    open func animateProgress(duration: CGFloat,  progressValue: CGFloat) {
        
        if !(0 < progressValue || progressValue < 1.0) {
            return
        }
        
        configureProgressView()
        let timing: UICubicTimingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        animator = UIViewPropertyAnimator(duration: TimeInterval(duration), timingParameters: timing)
        animator.addAnimations {
            self.progressView.frame.size.height -= self.pgHeight * progressValue
        }
        animator.startAnimation()
    }
    
    open func startAnimation(type: String, duration: CGFloat) {
        switch type {
        case "normal":
            runAnimation(reverse: false, duration: duration)
            break
        case "reverse":
            runAnimation(reverse: true, duration: duration)
            break
        default:
            break
        }
    }
    
    fileprivate func runAnimation(reverse: Bool, duration: CGFloat) {
        configureProgressView()
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: TimeInterval(duration), delay: 0.0, options: [.curveEaseInOut], animations: {
            UIView.setAnimationRepeatCount(1000)
            UIView.setAnimationRepeatAutoreverses(reverse)
            self.progressView.frame.size.height -= self.pgHeight
        }, completion: { _ in
        })
        animator.startAnimation()
    }
    
    open func stopAnimation() {
        animator.stopAnimation(true)
    }
    
    open func getProgress() -> CGFloat {
        return self.progressView.frame.size.height
    }
}