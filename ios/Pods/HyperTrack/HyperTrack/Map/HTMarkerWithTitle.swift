//
//  HTMarkerWithTitle.swift
//  HyperTrack
//
//  Created by ravi on 10/23/17.
//  Copyright © 2017 HyperTrack. All rights reserved.
//

import UIKit

class HTMarkerWithTitle: UIView {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var markerImage: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var radiatingImageView: UIImageView!

    @IBOutlet weak var radiationSize: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    let minWidth = CGFloat(100)

    override func awakeFromNib() {

        titleLabel?.layer.cornerRadius =  (self.titleLabel?.frame.width)! / (10.0)
        titleLabel?.layer.masksToBounds = true

        titleLabel?.shadowColor = UIColor.white
        titleLabel?.shadowOffset = CGSize.init(width: 0, height: 1)

    }

    func setTitle(title: String?) {
        self.titleLabel?.text = ""

        if let title = title {
            self.titleLabel?.text = title
            var width =  self.titleLabel?.intrinsicContentSize.width  ?? 0
            width +=  10.0
            if width < minWidth {
                self.widthConstraint.constant = width
            } else {
                self.widthConstraint.constant = minWidth
            }
        } else {
            self.titleLabel?.text = ""
        }
        self.titleLabel?.needsUpdateConstraints()
    }

    func radiate() {

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {

            UIView.animate(withDuration: 2, delay: 0, options: [.repeat], animations: {
                self.radiatingImageView.transform = CGAffineTransform(scaleX: 30, y: 30)
                self.radiatingImageView.alpha = 0
            }, completion: { (_) in
                self.radiatingImageView.alpha = 1
                self.radiatingImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            })
        })
    }

    func stopRadiation() {
        radiatingImageView.layer.removeAllAnimations()
    }

}
