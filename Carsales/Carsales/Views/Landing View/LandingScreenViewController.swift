//
//  LandingScreenViewController.swift
//  CarSales
//
//  Created by Steven Layug on 31/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class LandingScreenViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var brandImageViiew: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.setupNavigationBar()
        self.setupViews()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = "Carsales"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        guard let _navigationController = self.navigationController else { return }
        _navigationController.navigationBar.tintColor = .white
        _navigationController.navigationBar.isHidden = false
        _navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        _navigationController.navigationBar.backgroundColor = .primaryColor
        _navigationController.navigationBar.isTranslucent = true
    }
    
    private func setupViews() {
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.image = UIImage(named: "backgroundImage")
        
        self.brandImageViiew.contentMode = .scaleAspectFit
        self.brandImageViiew.image = UIImage(named: "brandImage")
        
        self.startButton.layer.cornerRadius = 5.0
        self.startButton.setTitle(" See Available Vehicles ", for: .normal)
        self.startButton.titleLabel?.font = .primaryFontSemiBold(size: 15)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.backgroundColor = .primaryColor
        self.startButton.addTarget(self, action: #selector(navigateToList), for: .touchUpInside)
    }
    
    @objc private func navigateToList() {
        let carListVC = CarListViewController()
        self.navigationController?.pushViewController(carListVC, animated: true)
    }
}
