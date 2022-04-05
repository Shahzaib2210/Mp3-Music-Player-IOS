//
//  MusicListTableViewCell.swift
//  Mp3 Music Player
//
//  Created by Shahzaib Mumtaz on 11/03/2022.
//  Copyright © 2022 Shahzaib. All rights reserved.
//

import UIKit

class MusicListTableViewCell: UITableViewCell {

    @IBOutlet weak var MusicNameView: UIView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var mp3: UIImageView!
    @IBOutlet weak var forwad: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  MusicNameView.layer.borderWidth = 1
     //   MusicNameView.layer.borderColor = UIColor(#colorLiteral(red: 155, green: 89, blue: 182, alpha: 1)).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
