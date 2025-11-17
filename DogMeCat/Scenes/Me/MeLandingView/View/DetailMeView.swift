//
//  DetailMeView.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

import UIKit

class DetailMeView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    static func loadFromNib() -> DetailMeView? {
        return Bundle.main.loadNibNamed("DetailMeView", owner: nil, options: nil)?.first as? DetailMeView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }
    
    func setuUI() {
        profileImageView.image = UIImage(named: "profile_sample")
        nameLabel.numberOfLines = 0

    }
    
    func comfigure(viewModel: Me.Load.ViewModel) {
        nameLabel.text = viewModel.title
        firstname.text = viewModel.firstName
        lastname.text = viewModel.lastName
        dateLabel.text = viewModel.dateOfBirth
        ageLabel.text = viewModel.ageText
        nationalityLabel.text = viewModel.nationality
        mobileLabel.text = viewModel.mobile
        addressLabel.text = viewModel.address
        genderImage.image = UIImage(named: viewModel.genderIconName)
        
        if let url = viewModel.profileImageURL {
            profileImageView.setImage(from: url,
                                      placeholder: UIImage(named: "profile_sample"))
        }
    }
    
}
