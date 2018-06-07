//
//  UISpringTimigParametersViewController.swift
//  UIViewPropertyAnimatorDemo
//
//  Created by Botla on 07/06/18.
//  Copyright © 2018 botla. All rights reserved.
//

import UIKit

class SpringTimigParametersViewController: UIViewController {

    // This records our circle's center for use as an offset while dragging
    var circleCenter: CGPoint!
    
    // We will attach various animations to this in response to drag evetns
    var circleAnimator: UIViewPropertyAnimator!
    var expansionAnimator: UIViewPropertyAnimator!
    let animationDuration = 2.0
    let expansionDuration = 2.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a draggable view
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 50.0
        circle.backgroundColor = UIColor.green
        
        circleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut, animations: {
            [unowned circle] in
            circle.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        })
        
        expansionAnimator = UIViewPropertyAnimator(duration: expansionDuration, curve: .easeIn, animations: {
            [unowned circle] in
            circle.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        })
        
        // Add pan gesture recognizer to
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragCircle)))
        
        self.view.addSubview(circle)
    }
    
    @objc func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began:
            if circleAnimator != nil && circleAnimator!.isRunning {
                circleAnimator!.stopAnimation(false)
            }

            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        case .ended:
            let v = gesture.velocity(in: target)
            let velocity = CGVector(dx: v.x / 500, dy: v.y / 500)
            let springParameters = UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: velocity)
            circleAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
            
            circleAnimator!.addAnimations {
                target.center = self.view.center
            }
            circleAnimator!.startAnimation()
        default:
            break
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButton(_ sender: Any) {
        let cubicVC = self.storyboard?.instantiateViewController(withIdentifier: "CubicTimingParametersViewController") as! CubicTimingParametersViewController
        
        self.present(cubicVC, animated: true, completion: nil)
    }

}
