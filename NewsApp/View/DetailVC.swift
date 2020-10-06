//
//  DetailVC.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    var viewModel: DetailViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addGradient() {
        func cgColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
            UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0).cgColor
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hexString: "#FF5733").cgColor,
            UIColor(hexString: "#C87D6D").cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
