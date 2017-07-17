//
//  CircleView.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 7/17/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
}
