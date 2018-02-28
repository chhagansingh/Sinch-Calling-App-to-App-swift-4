//
//  CallViewController.swift
//  SinchCallME
//
//  Created by Chhagan Singh on 28/02/18.
//  Copyright © 2018 Chhagan Singh. All rights reserved.
//



import UIKit
import Sinch

enum EButtonsBar: Int {
    
    case decline
    case hangup
    
}


class CallViewController:UIViewController,SINCallDelegate {
    
    
    @IBOutlet weak var remoteUserName: UILabel!
    @IBOutlet var callStateLabel: UILabel!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var answerButton: UIButton!
    @IBOutlet var endCallBUtton: UIButton!
    
    
    
    
    var durationTimer: Timer?
    var call: SINCall!
    
    var audioController:SINAudioController {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        return (appDelegate.client?.audioController())!
    }
    
    
    // MARK: - UIViewController Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        call.delegate=self
        
        if call.direction == .incoming
        {
            setCallStatus("")
            showButtons(.decline)
            self.audioController.enableSpeaker()
            self.audioController.startPlayingSoundFile(self.pathForSound("incoming.wav"), loop: true)
        }
        else
        {
            // setCallStatus.text = "calling..."
            setCallStatus("calling.....")
            showButtons(.hangup)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        remoteUserName.text = call?.remoteUserId!
    }
    
    
    // MARK: - Call Actions
    @IBAction func accept(_ sender: Any) {
        
        self.audioController.disableSpeaker()
        self.audioController.stopPlayingSoundFile()
        call.answer()
    }
    
    @IBAction func decline(_ sender: Any) {
        self.audioController.disableSpeaker()
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hangup(_ sender: Any) {
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func onDurationTimer(_ unused: Timer) {
        let duration = Int(Date().timeIntervalSince(call.details.establishedTime))
        
        DispatchQueue.main.async {
            self.setDuration(duration)
        }
        
    }
    
    // MARK: - SINCallDelegate
    
    func callDidProgress(_ call: SINCall)
    {
        callStateLabel.text = "ringing..."
        audioController.startPlayingSoundFile(pathForSound("ringback.wav"), loop: true)
    }
    
    func callDidEstablish(_ call: SINCall)
    {
        
        startCallDurationTimerWithSelector(#selector(CallViewController.onDurationTimer(_:)))
        showButtons(.hangup)
        audioController.stopPlayingSoundFile()
    }
    
    func callDidEnd(_ call: SINCall)
    {
        audioController.stopPlayingSoundFile()
        stopCallDurationTimer()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Sounds
    func pathForSound(_ soundName: String) -> String {
        let resourcePath = Bundle.main.resourcePath! as NSString
        return resourcePath.appendingPathComponent(soundName)
    }
}


// MARK: - This extension contains UI helper methods for CallViewController

extension CallViewController {
    
    // MARK: - Call Status
    
    func setCallStatusText(_ text: String) {
        callStateLabel.text = text
    }
    
    func setCallStatus(_ text: String) {
        self.callStateLabel.text = text
    }
    
    // MARK: - Buttons
    
    func showButtons(_ buttons: EButtonsBar) {
        if buttons == .decline {
            answerButton.isHidden = false
            declineButton.isHidden = false
            endCallBUtton.isHidden = true
        }
        else if buttons == .hangup {
            endCallBUtton.isHidden = false
            answerButton.isHidden = true
            declineButton.isHidden = true
        }
    }
    
    // MARK: - Duration
    
    func setDuration(_ seconds: Int)
    {
        setCallStatusText(String(format: "%02d:%02d", arguments: [Int(seconds / 60), Int(seconds % 60)]))
    }
    
    @objc func internal_updateDurartion(_ timer: Timer)
    {
        
        let selector:Selector = NSSelectorFromString(timer.userInfo as! String)
        
        if self.responds(to: selector)
        {
            self.performSelector(inBackground: selector, with: timer)
        }
        
    }
    
    func startCallDurationTimerWithSelector(_ selector: Selector) {
        let selectorString  = NSStringFromSelector(selector)
        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(CallViewController.internal_updateDurartion(_:)), userInfo: selectorString, repeats: true)
    }
    
    func stopCallDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
    }
    
}

