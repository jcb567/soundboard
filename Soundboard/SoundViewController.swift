//
//  SoundViewController.swift
//  Soundboard
//
//  Created by Jake Cameron Booth on 31/03/2017.
//  Copyright © 2017 Jake Cameron Booth. All rights reserved.
//

import UIKit
import AVFoundation


class SoundViewController: UIViewController {
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer? = nil
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            
            // Create an audio session - I want to be able to play and record
            
            let session =  AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker) // allow sound through IOS speakers
            try session.setActive(true)
            
            // Create URL for audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            // Create settings for AudioRecorder
            
            var settings : [String : AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            // Create audioRecorder object - say where we want it to be saved, and add any settings such as clarity
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch {

        }
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //Stop the recording if true
            audioRecorder?.stop()
            
            //Change button title to record
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //start the recording
            audioRecorder?.record()
            
            //change button to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {}
        }
    
    @IBAction func addTapped(_ sender: Any) {
        //setting up core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        //save the code
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
       navigationController!.popViewController(animated: true)
    }
    
}
