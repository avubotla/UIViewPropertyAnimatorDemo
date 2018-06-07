//
//  UICubicTimingParametersViewController.swift
//  UIViewPropertyAnimatorDemo
//
//  Created by Botla on 07/06/18.
//  Copyright © 2018 botla. All rights reserved.
//

import UIKit

class CubicTimingParametersViewController: UIViewController {

    // This records our circle's center for use as an offset while dragging
    var circleCenter: CGPoint!
    
    // We will attach various animations to this in response to drag evetns
    var circleAnimator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a draggable view
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green
        
        circleAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            circle.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        })
        
        circleAnimator?.addAnimations({
            circle.backgroundColor = UIColor.blue
        }, delayFactor: 0.75)
        
        // Add pan gesture recognizer to
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragCircle)))
        
        self.view.addSubview(circle)

    }
    
    @objc func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began:
            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            circleAnimator?.fractionComplete = target.center.y / self.view.frame.height
        default:
            break
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
