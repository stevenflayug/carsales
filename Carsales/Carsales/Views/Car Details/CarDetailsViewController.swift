//
//  CarDetailsViewController.swift
//  Carsales
//
//  Created by Steven Layug on 31/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class CarDetailsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var pricaLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsTitleLabel: UILabel!
    
    private var navTitle: String!
    private var viewModel: CarDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    init(title: String, detailsUrl: String) {
        self.navTitle = title
        self.viewModel = CarDetailsViewModel(detailsUrl: detailsUrl)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupViews()
        self.setupObservables()
        self.viewModel.startCarDetailsRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HUD.show(.progress, onView: self.view)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.imagesCollectionViewHeight.constant = screenWidth - (screenWidth/3)
        self.imagesCollectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = self.navTitle
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        guard let _navigationController = self.navigationController else { return }
        _navigationController.navigationBar.tintColor = .white
        _navigationController.navigationBar.isHidden = false
        _navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        _navigationController.navigationBar.backgroundColor = .primaryColor
        _navigationController.navigationBar.isTranslucent = true
    }
    
    func setupViews() {
        self.locationTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.locationTitleLabel.textColor = .primaryColor
        self.locationTitleLabel.textAlignment = .left
        self.locationTitleLabel.text = ""
        
        self.locationLabel.font = .primaryFont(size: 15)
        self.locationLabel.textColor = .gray
        self.locationLabel.textAlignment = .left
        self.locationLabel.text = ""
        
        self.priceTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.priceTitleLabel.textColor = .primaryColor
        self.priceTitleLabel.textAlignment = .left
        self.priceTitleLabel.text = ""
        
        self.pricaLabel.font = .primaryFont(size: 15)
        self.pricaLabel.textColor = .gray
        self.pricaLabel.textAlignment = .left
        self.pricaLabel.text = ""
        
        self.statusTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.statusTitleLabel.textColor = .primaryColor
        self.statusTitleLabel.textAlignment = .left
        self.statusTitleLabel.text = ""
        
        self.statusLabel.font = .primaryFont(size: 15)
        self.statusLabel.textColor = .gray
        self.statusLabel.textAlignment = .left
        self.statusLabel.text = ""
        
        self.commentsTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.commentsTitleLabel.textColor = .primaryColor
        self.commentsTitleLabel.textAlignment = .left
        self.commentsTitleLabel.text = ""
        
        self.commentsLabel.font = .primaryFont(size: 15)
        self.commentsLabel.textColor = .gray
        self.commentsLabel.textAlignment = .left
        self.commentsLabel.text = ""
    }
    
    private func setupCollectionView() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        self.imagesCollectionViewHeight.constant = screenWidth - (screenWidth/3)
        self.imagesCollectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.imagesCollectionView.collectionViewLayout = layout
        
        self.imagesCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.imagesCollectionView.dataSource = nil
        self.view.backgroundColor = .backgroundColor
        
        if let flow =  self.imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flow.scrollDirection = .horizontal
        }
        
        // Register Cell
        self.imagesCollectionView.register(UINib(nibName: "CarDetailPhotoCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "carDetailPhotoCollectionViewCell")
        
        self.imagesPageControl.currentPageIndicatorTintColor = .primaryColor
        self.imagesPageControl.pageIndicatorTintColor = UIColor.white
        self.imagesPageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    private func setupObservables() {
        self.viewModel.detailImages.asObservable().bind(to: self.imagesCollectionView.rx.items(cellIdentifier: "carDetailPhotoCollectionViewCell", cellType: CarDetailPhotoCollectionViewCell.self)) {
            index, item, cell in
            cell.setupDetailImageCell(imageUrl: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.detailImages.asObservable().subscribe(onNext: {  [weak self] images in
            guard let _self = self else { return }
            _self.imagesPageControl.numberOfPages = images.count
        }).disposed(by: disposeBag)
        
        self.viewModel.carDetails.asObservable().subscribe(onNext: {  [weak self] details in
            guard let _self = self else { return }
            _self.setupDetails(carDetails: details)
            HUD.hide(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupDetails(carDetails: CarDetails) {
        guard !carDetails.title.isEmpty else { return }
        self.locationTitleLabel.text = "Location"
        self.priceTitleLabel.text = "Price"
        self.statusTitleLabel.text = "Sale Status"
        self.commentsTitleLabel.text = "Comments"
        self.locationLabel.text = carDetails.overview.location
        self.pricaLabel.text = carDetails.overview.price
        self.statusLabel.text = carDetails.saleStatus
        self.commentsLabel.text = carDetails.comments
    }
}

extension CarDetailsViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        var noOfCellsInRow: Double!
        
        noOfCellsInRow = 1
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let computedSize = CGFloat((self.imagesCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: computedSize, height: computedSize - (computedSize/3))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("tag = \(scrollView.tag)")
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.imagesPageControl.currentPage = page
        print("page = \(page)")
    }
}
