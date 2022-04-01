//
//  ViewController.swift
//  Mp3 Music Player
//
//  Created by Shahzaib on 3/11/22.
//  Copyright © 2022 Shahzaib. All rights reserved.
//

import UIKit

class MusicPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var songs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        GetSongs()
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func GetSongs()
    {
        let folderPath = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        print("Folder Path: \(folderPath)")
        
        do
        {
            let audioPath = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for audio in audioPath
            {
                var myAudio = audio.absoluteString
                
                if myAudio.contains(".mp3")
                {
                    let findAudioName = myAudio.components(separatedBy: "/")
                    myAudio = findAudioName[findAudioName.count-1]
                    myAudio = myAudio.replacingOccurrences(of: "%20", with: " ")
                    myAudio = myAudio.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(myAudio)
                    print(myAudio)
                }
            }
        }
        catch
        {
            print("Error Getting Recordings")
        }
    }
}

extension MusicPlaylistViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MusicListTableViewCell
        cell.musicName.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.name = songs[indexPath.row]
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
