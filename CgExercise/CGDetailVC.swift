//
//  CGDetailVC.swift
//  CgExercise
//
//  Created by Test User 1 on 11/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class CGDetailVC: UIViewController {
    
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mDescriptionLabel: UILabel!
    
    var selectedIndex = 0
    var model: FactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Beavers"
        addSubviews()
        setData()
    }
    
    func addSubviews() {
        let subviews = (0..<2).map { (_) -> CustomView in
            return UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil,
                                                                         options: nil)[0] as! CustomView
        }
        subviews[0].backgroundColor = UIColor.clear
        subviews[0].label.isHidden = true
        subviews[1].backgroundColor = UIColor.clear
        subviews[1].imageView.isHidden = true
        subviews.forEach { (view) in
            mStackView.addArrangedSubview(view)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {[weak self] (_) in
            
            let orientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
            if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
                // orientation is landscape
                self?.mStackView.axis = .horizontal
                if let view = self?.mStackView.subviews[0] as? CustomView {
                    view.width = 3
                }
                if let view = self?.mStackView.subviews[1] as? CustomView {
                    view.width = 7
                }
            }  else {
                // orientation is portrait
                self?.mStackView.axis = .vertical
                if let view = self?.mStackView.subviews[0] as? CustomView {
                    view.width = 3
                }
                if let view = self?.mStackView.subviews[1] as? CustomView {
                    view.width = 7
                }
                
            }
            
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func setData() {
        
        if let factModel = model {
            if let name = factModel.title {
                self.title = name
            }else {
                self.title = "Detail"
            }
            
            if let imageUrlString = factModel.imageHref {
                ImageLoader.sharedInstance.obtainImageWithPath(imagePath: imageUrlString) { (image,fromCache) in
                    if let view = self.mStackView.subviews[0] as? CustomView {
                        view.imageView.image = image
                    }
                    if let textStr = factModel.descrip {
                        if let view = self.mStackView.subviews[1] as? CustomView {
                            view.label.text = textStr
                        }
                    }
                    
                }
            }
        }
    }
    
}





