//
//  AnnotationViewController.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/19.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var tutorialViews: [UIView]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.Oval(center: CGPoint(x: screenSize.width - 26, y: 42), diameter: 50))
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: 25, y: 42), diameter: 50))
        case 2:
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Map") as! MapViewController
            //self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.present(viewController, animated: false, completion: nil)

            //spotlightView.move(Spotlight.RoundedRect(center: CGPointMake(screenSize.width / 2, 42), size: CGSizeMake(120, 40), cornerRadius: 6), moveType: .Disappear)
        case 3:
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: 200), diameter: 220), moveType: .disappear)
        case 4:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        tutorialViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
                view.alpha = index == self.stepIndex ? 1 : 0
            }) 
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
