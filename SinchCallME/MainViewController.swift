//
//  MainViewController.swift
//  SinchCallME
//
//  Created by Chhagan Singh on 28/02/18.
//  Copyright © 2018 Chhagan Singh. All rights reserved.
//

import UIKit
import Sinch

class MainViewController: UIViewController, SINCallClientDelegate {
    
    @IBOutlet var destination: PaddedTextField!
    @IBOutlet var callButton: UIButton!
    
    var client: SINClient {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.client!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        self.client.call().delegate = self
    }
    
    @IBAction func call(_ sender: AnyObject) {
        
        let destination = self.destination.text
        
        
        if (destination != nil) && self.client.isStarted()
        {
            
            weak var call: SINCall? = client.call().callUser(withId: destination)
            
            //let call: SINCall = self.client.call().callUserwithId: destination)
            performSegue(withIdentifier: "callView", sender: call)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let callViewController = segue.destination as? CallViewController
        callViewController?.call = (sender as! SINCall)
    }
    
    // MARK: - SINCallClientDelegate
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        performSegue(withIdentifier: "callView", sender: call)
    }
    
    func client(_ client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
        let notification = SINLocalNotification()
        notification.alertAction = "Answer"
        notification.alertBody = String(format: "Incoming call from %@", arguments: [call.remoteUserId])
        return notification
    }
    
}
