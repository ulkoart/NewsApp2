//
//  DetailVC.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit
import SafariServices

class DetailVC: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sourceLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var openSourceButton: UIButton!
    @IBOutlet private var shareButton: UITabBarItem!
    @IBOutlet private var tabBar: UITabBar!
    
    var viewModel: DetailViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func openSourceButtonPressed(_ sender: UIButton) {
        guard
            let urlString = viewModel?.url,
            let url = URL(string: urlString) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    private func addGradient() {
        func cgColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
            UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0).cgColor
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hexString: "#ff9500").cgColor,
            UIColor(hexString: "#ffffff").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setup() {
        addGradient()
        
        openSourceButton.backgroundColor = .clear
        openSourceButton.layer.cornerRadius = 15
        openSourceButton.layer.borderWidth = 1
        openSourceButton.layer.borderColor = UIColor.red.cgColor
        openSourceButton.setTitleColor(.red, for: .normal)
        
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            sourceLabel.text = viewModel.sourse
            descriptionLabel.text = viewModel.description
            
            if viewModel.offLine == true {
                openSourceButton.isHidden = true
            }
            
        }
    }
    
}

extension DetailVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 10:
            print("10")
        case 20:
            guard
                let urlString = viewModel?.url,
                let url = URL(string: urlString) else { return }
            let items = [url]
            let shareController = UIActivityViewController(activityItems:items, applicationActivities: nil)
            
            shareController.completionWithItemsHandler = {_, bool, _, _ in
                if bool {
                    print ("Done")
                }
            }
            
            present(shareController, animated: true, completion: nil)
        default:
            fatalError()
        }
    }
}
