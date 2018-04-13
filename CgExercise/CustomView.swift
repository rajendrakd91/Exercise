//
//  CustomView.swift
//  CgExercise
//
//  Created by Test User 1 on 13/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit
import Foundation

class CustomView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var height: CGFloat = 1.0
    var width: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }

}
