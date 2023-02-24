//
//  WLDDEpisodeInfoCollectionViewCell.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 24/02/23.
//

import UIKit

class WLDDEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WLDDEpisodeInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
    
    func configure(with viewModel: WLDDEpisodeInfoCollectionViewViewModel) {
        
    }
}
