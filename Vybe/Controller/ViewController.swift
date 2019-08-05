//
//  ViewController.swift
//  Vybe
//
//  Created by Terry Bridges on 31/07/2019.
//  Copyright © 2019 Terry Bridges. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate  {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var dividsor: CGFloat!
    let songController = LoginController()
    var player: SPTAudioStreamingController?
    var session: SPTSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dividsor = (view.frame.width / 2) / 0.51
    }

 
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let scale = min(100 / abs(xFromCenter), 1)
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / dividsor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            thumbImg.image = #imageLiteral(resourceName: "thumbsup")
            thumbImg.tintColor = UIColor.green
        } else {
            thumbImg.image = #imageLiteral(resourceName: "thumbsdown")
            thumbImg.tintColor = UIColor.red
        }
        
        thumbImg.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 {
                //Move card off the left of the screen
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 250, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                //move card off the right of the screen
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 250, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            }
            reset()
        }
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        reset()
        
      
    }
    
    func reset() {
        UIView.animate(withDuration: 0.2) {
            self.card.center = self.view.center
            self.thumbImg.alpha = 0
            self.card.alpha = 1
            self.card.transform = .identity
        }
    }
    
}

