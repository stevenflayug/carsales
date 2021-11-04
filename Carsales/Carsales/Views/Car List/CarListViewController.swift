//
//  CarListViewController.swift
//  Carsales
//
//  Created by Steven Layug on 31/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class CarListViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var carCollectionView: UICollectionView!
    
    private var refreshControl = UIRefreshControl()
    private var filterBarButton = UIBarButtonItem()
    private var searchByPickerView = UIPickerView()
    private var filterPickerView = UIPickerView()
    
    private let viewModel = CarListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        HUD.dimsBackground = false
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupViews()
        self.setupObservables()
        
        HUD.show(.progress, onView: self.view)
        self.viewModel.startCarListRequest()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.carCollectionView.reloadData()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = "Vehicle List"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.backgroundColor = .primaryColor
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupCollectionView() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.carCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.carCollectionView.dataSource = nil
        
        self.view.backgroundColor = .backgroundColor
        
        carCollectionView.layer.cornerRadius = 8.0
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(reloadCarList), for: .valueChanged)
        self.carCollectionView.addSubview(refreshControl)
        
        // Register Cell
        self.carCollectionView.register(UINib(nibName: "CarCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "carCollectionViewCell")
    }
    
    func setupViews() {
        self.carCollectionView.isHidden = true
    }
    
    private func setupObservables() {
        self.viewModel.carList.asObservable().bind(to: carCollectionView.rx.items(cellIdentifier: "carCollectionViewCell", cellType: CarCollectionViewCell.self)) {
            index, item, cell in
            cell.setupCell(car: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.carList.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            HUD.hide(animated: true)
            
            if $0.isEmpty {
                _self.carCollectionView.isHidden = true
            } else {
                _self.carCollectionView.isHidden = false
            }
            
            _self.carCollectionView.reloadData()
            _self.carCollectionView.reloadInputViews()
            _self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        self.carCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let _self = self else { return }
            let carDetailsVC = CarDetailsViewController(title: _self.viewModel.carList.value[indexPath.row].title, detailsUrl: _self.viewModel.carList.value[indexPath.row].detailsURL)
            _self.navigationController?.pushViewController(carDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asObservable().subscribe(onNext: { (error) in
            if error != "" {
                HUD.flash(.labeledError(title: "Car List Service Error", subtitle: error), onView: self.view, delay: 1, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func reloadCarList() {
        HUD.show(.progress, onView: self.view)
        self.viewModel.startCarListRequest()
    }
}

extension CarListViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        var noOfCellsInRow: Double!
        
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                if interfaceOrientation == .landscapeRight || interfaceOrientation == .landscapeLeft {
                    noOfCellsInRow = 3.03
                    
                    let totalSpace = flowLayout.sectionInset.left
                        + flowLayout.sectionInset.right
                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    let computedSize = CGFloat((self.carCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: computedSize, height: (self.carCollectionView.frame.size.height-10)/2.2)
                }
                else{
                    noOfCellsInRow = 2.03
                    
                    let totalSpace = flowLayout.sectionInset.left
                        + flowLayout.sectionInset.right
                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    let computedSize = CGFloat((self.carCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: computedSize, height: (self.carCollectionView.frame.size.height-10)/2.83)
                }
            default:
                if interfaceOrientation == .landscapeRight || interfaceOrientation == .landscapeLeft {
                    
                    noOfCellsInRow = 2.03
                    
                    let totalSpace = flowLayout.sectionInset.left
                        + flowLayout.sectionInset.right
                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    let computedSize = CGFloat((self.carCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: computedSize, height: computedSize - 40)
                }
                else{
                    noOfCellsInRow = 1
                    
                    let totalSpace = flowLayout.sectionInset.left
                        + flowLayout.sectionInset.right
                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    let computedSize = CGFloat((self.carCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: computedSize, height: computedSize - 40)
                }
            }
        } else {
            noOfCellsInRow = 1
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let computedSize = CGFloat((self.carCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: computedSize, height: computedSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
