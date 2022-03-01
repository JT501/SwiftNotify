//
//  MainTableViewCell.swift
//  SwiftNotifyExample
//
//  Created by Johnny Tsoi on 25/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(white: 0.9, alpha: 0.7).cgColor
        containerView.layer.shadowColor = UIColor.white.cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 2
    }
}
