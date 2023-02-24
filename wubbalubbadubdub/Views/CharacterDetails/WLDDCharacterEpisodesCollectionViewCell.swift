//
//  WLDDCharacterEpisodesCollectionViewCell.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit

class WLDDCharacterEpisodesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WLDDCharacterEpisodesCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraint() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: WLDDCharacterEpisodesCollectionViewCellViewModel) {
        viewModel.registerForData { data in
            print(data.name)
        }
        
        viewModel.fetchEpisode()
    }
}
