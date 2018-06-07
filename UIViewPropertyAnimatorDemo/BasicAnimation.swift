//
//  BasicAnimation.swift
//  UIViewPropertyAnimatorDemo
//
//  Created by Botla on 07/06/18.
//  Copyright © 2018 botla. All rights reserved.
//


// Exapansion circle
import UIKit

class BasicAnimation: UIViewController {

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
        case .began, .ended:
            circleCenter = target.center
            
            if circleAnimator.state == .active {
                // rest animator to inactive state
                circleAnimator.stopAnimation(true)
            }
            
            if gesture.state == .began {
                circleAnimator.addAnimations {
                    target.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }
            } else {
                circleAnimator.addAnimations {
                    target.transform = CGAffineTransform.identity
                }
            }
            circleAnimator.startAnimation()
            case .changed:
                let translation = gesture.translation(in: self.view)
                target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
            default:
                break
            }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let springVC = self.storyboard?.instantiateViewController(withIdentifier: "SpringTimigParametersViewController") as! SpringTimigParametersViewController
        
        self.present(springVC, animated: true, completion: nil)
        
    }
    
    
}

