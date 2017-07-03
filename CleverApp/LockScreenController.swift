//
//  LockScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/7/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class LockScreenController: UIViewController {

    let circleLayer = CAShapeLayer()
    var isStarted: Bool = false
    
    @IBOutlet weak var cstHeightBtnLock: NSLayoutConstraint!
    @IBOutlet weak var cstWidthBtnLock: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView3: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView3: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView2: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView2: NSLayoutConstraint!
    @IBOutlet weak var cstHeightView1: NSLayoutConstraint!
    @IBOutlet weak var cstWidthView1: NSLayoutConstraint!
    
    @IBOutlet weak var viewAnimated1: LockAnimationView!
    @IBOutlet weak var viewAnimated2: LockAnimationView!
    @IBOutlet weak var viewAnimated3: LockAnimationView!
    
    @IBOutlet weak var btnLockView: UIButton!
    @IBAction func btnLockTap(_ sender: UIButton) {
        isStarted = !isStarted
        if (isStarted) {
            start()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.stop()
                self.isStarted = !self.isStarted
            }
        } else {
            stop()
        }
    }
    
    func start() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        viewAnimated1.tintColor = appDelegate.uiColorFromHex(rgbValue: 0xd1411d)
        viewAnimated2.tintColor = appDelegate.uiColorFromHex(rgbValue: 0x7e4ae9)
        viewAnimated3.tintColor = appDelegate.uiColorFromHex(rgbValue: 0x07b8e7)
        
        viewAnimated1.startAnimate(duration: 0.6, lineWidth: 5.0)
        viewAnimated2.startAnimate(duration: 0.8, lineWidth: 6.5)
        viewAnimated3.startAnimate(duration: 1.0, lineWidth: 8.0)
    }
    
    func stop() {
        viewAnimated1.tintColor = .clear
        viewAnimated2.tintColor = .clear
        viewAnimated3.tintColor = .clear
        
        viewAnimated1.stopAnimate(true)
        viewAnimated2.stopAnimate(true)
        viewAnimated3.stopAnimate(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnLockSize = UIScreen.main.bounds.width * 0.7
        cstWidthBtnLock.constant = btnLockSize
        cstHeightBtnLock.constant = btnLockSize
        // view 1
        cstWidthView1.constant = cstWidthBtnLock.constant + 0.5
        cstHeightView1.constant = cstHeightBtnLock.constant + 0.5
        // view 2
        cstWidthView2.constant = cstWidthView1.constant + 0.5
        cstHeightView2.constant = cstHeightView1.constant + 0.5
        // view 3
        cstWidthView3.constant = cstWidthView2.constant + 0.5
        cstHeightView3.constant = cstHeightView2.constant + 0.5
    }
    
    func animateButton() {
        btnLockView.transform = CGAffineTransform(scaleX: 0.3, y: 0.1)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: CGFloat(0.2),
            initialSpringVelocity: CGFloat(0.6),
            options: .allowUserInteraction,
            animations: { self.btnLockView.transform = .identity },
            completion: { finished in
                self.animateButton()
            }
        )
    }
}
