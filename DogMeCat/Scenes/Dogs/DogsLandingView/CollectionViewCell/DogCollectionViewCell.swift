//
//  DogCollectionViewCell.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    func setUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configure(title: String, image: URL) {
        imageShow.image = UIImage(named: "image-placeholder")
        detail.text = title
        imageShow.setImage(from: image,
                           placeholder: UIImage(named: "image-placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageShow.image = UIImage(named: "image-placeholder")
        detail.text = nil
    }
    
}
