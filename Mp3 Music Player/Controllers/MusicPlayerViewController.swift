//
//  MusicPlayerViewController.swift
//  Mp3 Music Player
//
//  Created by Shahzaib Mumtaz on 01/04/2022.
//  Copyright © 2022 Shahzaib. All rights reserved.
//

import UIKit
import MediaPlayer
import MediaAccessibility
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songPlayProgress: UIProgressView!
    @IBOutlet weak var seekBackward: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var seekForwad: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var totalPlayTime: UILabel!
    @IBOutlet weak var currentPlayTime: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    
    var name:String?
    var index : Int = 0
    var audioPlay = true
    var currentTime = 0
    var totalMusicProgress = 0
    
    deinit {
        print("Deinit Method Called")
    }
    
    var progressBarTimer = Timer()
    var SongProgressTimer  = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        
        PlayingSong()
        audioPlayer.play()
        audioPlayer.volume = 0.5
        audioPlay = false
        
        songPlayProgress.progress = 0.0
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        SongProgressTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar() {
    
        if songPlayProgress.progress == Float(totalMusicProgress) {
            SongProgressTimer.invalidate()
        } else {
            self.songPlayProgress.progress += 0.01
        }
    }
    
    // method for update Music Play Time
    @objc func updateTime()
    {
        if audioPlayer.isPlaying {
            
            currentTime += 1
            let original = Int(currentTime)
            let minutes = String(format: "%02d", (original % 3600) / 60)
            let hours = (original % 3600) % 60
            currentPlayTime.text = "\(minutes):\(hours)"
        }
    }
    
    @IBAction func btnSeekForwadTapped(_ sender: UIButton) {
        currentTime += 10
        audioPlayer.currentTime += 10
        print("Forwad Tapped")
    }
    
    @IBAction func BtnPlayPauseButtonTapped(_ sender: UIButton) {
        if audioPlay
        {
            audioPlayer.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            audioPlay = false
        }
        else
        {
            audioPlayer.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            audioPlay = true
        }
    }
    
    @IBAction func btnSeekBackwardTapped(_ sender: UIButton) {
        currentTime -= 10
        audioPlayer.currentTime -= 10
        print("Reverse Tapped")
    }
    
    @IBAction func VolumeSliderChanged(_ sender: UISlider) {
        let value = volumeSlider.value
        audioPlayer.volume = value
    }
}

extension MusicPlayerViewController {
    
    // Function to get path to directory
    func getDirectory() -> URL {
        
        let folderPath = URL(fileURLWithPath: Bundle.main.resourcePath!)
        return folderPath
    }
    
    // Function to Play Song
    func PlayingSong()
    {
        do
        {
            let audioPath = Bundle.main.path(forResource: name, ofType: ".mp3")!
            GetSongImage(fileURL: audioPath)
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL )
            let audioAsset = AVURLAsset.init(url: NSURL(fileURLWithPath: audioPath) as URL, options: nil)
            let duration = audioAsset.duration
            let durationInSeconds = CMTimeGetSeconds(duration)
            let original = Int(durationInSeconds)
            totalMusicProgress = original
            let minutes = (original % 3600) / 60
            let hours = (original % 3600) % 60
            
            totalPlayTime.text = "0\(minutes):\(hours)"
        }
        catch
        {
            print("Error")
        }
    }
    
    // Second into Minutes and hours
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> String
    {
        let second = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let hours = (seconds % 3600) % 60
        
        return "0\(second):0\(minutes):\(hours)"
    }
    
    func GetSongImage(fileURL: String) {
        
        //transforming it to url
        let fileUrl = NSURL(fileURLWithPath: fileURL)
        
        //instanciating asset with url associated file
        let asset = AVAsset(url: fileUrl as URL) as AVAsset
        
        //using the asset property to get the metadata of file
        for metaDataItems in asset.commonMetadata {
            
            //  getting the title of the song
            if metaDataItems.commonKey == .commonKeyTitle {
                let titleData = metaDataItems.value as! NSString
                let title = titleData.substring(to: 9)
                let singerData = titleData.substring(from: 12)
                let singer = (singerData as NSString).substring(to: 13)
                print("title ---> \(title)")
                print("singer ---> \(singer)")
            }
            
            //getting the "Artist of the mp3 file"
            if metaDataItems.commonKey == .commonKeyArtist {
                let artistData = metaDataItems.value as! NSString
                print("artist ---> \(artistData)")
            }
            
            //   getting the thumbnail image associated with file
            if metaDataItems.commonKey == .commonKeyArtwork
            {
                let imageData = metaDataItems.value as! NSData
                let image2: UIImage = UIImage(data: imageData as Data)!
                songImage.image = image2
            }
        }
    }
}
