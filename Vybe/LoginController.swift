//
//  LoginController.swift
//  Vybe
//
//  Created by Terry Bridges on 01/08/2019.
//  Copyright © 2019 Terry Bridges. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

class LoginController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var loginURL: URL?

    @IBOutlet weak var logInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.UpdateAfterFirstLogin ), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    
    func setup() {
        let redirectURL = "Vybe://returnAfterLogin"
        let clientID = "86a2db9578d74c93bcd18c5913964cf7"
        
        auth.redirectURL = URL(string: redirectURL)
        auth.clientID =  clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = auth.spotifyAppAuthenticationURL()
    }
    
    func initialisePlayer(authSession: SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player?.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player?.login(withAccessToken: authSession.accessToken)
        }
    }
    @objc func UpdateAfterFirstLogin() {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?{
            
            print("first Login")
            let sessionDataObject = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObject) as! SPTSession
            self.session = firstTimeSession
            logInBtn.isHidden = true
            initialisePlayer(authSession: session)
            
        }
        
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print("Logged in")
//        self.player?.playSpotifyURI("spotify:track:7dvM0LbJ4pu1tDJnCH1Ahg", startingWith: 0, startingWithPosition: 0, callback: { (error) in
//            if (error != nil) {
//                print("playing")
//            }
//        })
    }
    
    

    @IBAction func LoginButtonAction(_ sender: Any) {
        if UIApplication.shared.openURL(loginURL!) {
            if auth.canHandle(auth.redirectURL) {
                
            }
        }
    }
    
}
