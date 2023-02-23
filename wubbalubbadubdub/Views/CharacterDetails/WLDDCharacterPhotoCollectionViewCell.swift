//
//  WLDDCharacterPhotoCollectionViewCell.swift
//  wubbalubbadubdub
//
//  Created by Agni Muhammad on 23/02/23.
//

import UIKit

class WLDDCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WLDDCharacterPhotoCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraint() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: WLDDCharacterPhotoCollectionViewCellViewModel) {
        
    }
}
