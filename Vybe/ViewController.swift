//
//  ViewController.swift
//  Vybe
//
//  Created by Terry Bridges on 31/07/2019.
//  Copyright © 2019 Terry Bridges. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 0 {
            thumbImg.image = #imageLiteral(resourceName: "thumbsup")
            thumbImg.tintColor = UIColor.green
        } else {
            thumbImg.image = #imageLiteral(resourceName: "thumbsdown")
            thumbImg.tintColor = UIColor.red
        }
        
        thumbImg.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
                self.thumbImg.alpha = 0
            }
        }
    }
    
}

