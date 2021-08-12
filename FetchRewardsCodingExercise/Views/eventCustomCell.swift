//
//  eventCustomCell.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/3/21.
//

import Foundation
import UIKit



class eventCustomCell: UITableViewCell {
    
    @IBOutlet weak var customCell: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartFill: UIImageView!

    override func awakeFromNib() {
        
        customCell.backgroundColor = .white
        customCellSettings()
        dataSettings()
        heartFill.isHidden = true
        customSeparator()
    }
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: - Custom Cell View Settings
    func customSeparator() {
        let border = CALayer()
        border.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 15, y: customCell.frame.size.height - 1.5, width: customCell.frame.size.width - 15, height: 1.5)
        customCell.layer.addSublayer(border)
    }

    
    func customCellSettings() {
        eventImage.layer.cornerRadius = 15
        eventImage.contentMode = .scaleAspectFill
        titleLabel.frame.size.width = 245
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        titleLabel.adjustsFontForContentSizeCategory = true
        locationLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        locationLabel.textColor = .systemGray
        dateLabel.textColor = .systemGray
        locationLabel.textAlignment = .left
        dateLabel.textAlignment = .left
        titleLabel.textColor = .black
    }
    
    // default settings
    
    func dataSettings() {
        
        titleLabel.text = "Los Angeles Rams at \nTampa Bay\nBuccaneers"
        locationLabel.text = "Tampa, FL"
        dateLabel.text = "Tuesday, 24 Nov 2020\n8:00 PM"
        eventImage.backgroundColor = .black
        
    }
}
