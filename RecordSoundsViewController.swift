//
//  RecordSoundsViewController.swift
//  PitchPerfectApp
//
//  Created by Josh on 7/12/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    func recordButtonBool (enableRec: Bool) {
      stopRecordButton.isEnabled = !enableRec
      recordButton.isEnabled = enableRec
      recordingLabel.text = enableRec ? "Tap to Record" : "Recording in Progress"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButtonBool (enableRec: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear called")
    }
    @IBAction func recordAudio(_ sender: AnyObject) {
        recordButtonBool (enableRec: false)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
@IBAction func stopRecording(_ sender: Any) {
    recordButtonBool(enableRec: true)
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
}
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording Not Successful")
        }
    
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}
