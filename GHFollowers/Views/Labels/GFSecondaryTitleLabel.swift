//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 7.10.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
