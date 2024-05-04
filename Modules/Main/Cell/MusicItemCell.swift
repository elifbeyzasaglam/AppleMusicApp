//
//  MusicItemCell.swift
//  AppleMusicApp
//
//  Created by ELİF BEYZA SAĞLAM on 5.03.2024.
//

import UIKit
import Kingfisher

final class MusicItemCell: UITableViewCell {

    @IBOutlet private weak var songImageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        songImageView.layer.cornerRadius = 5
    }
    
    func prepareCell(with model: MusicResultsResponse) {
        songNameLabel.text = model.name ?? ""
        artistNameLabel.text = model.artistName ?? ""
        guard let url = model.artworkUrl100 else { return }
        songImageView.kf.setImage(with: url)
    }
}
