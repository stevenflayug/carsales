//
//  CarCollectionViewCell.swift
//  Carsales
//
//  Created by Steven Layug on 31/10/21.
//

import UIKit

class CarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    func setupViews() {
        self.mainView.layer.cornerRadius = 8.0
        self.mainView.clipsToBounds = true
        self.mainView.backgroundColor = .backgroundColor
        self.carImageView.contentMode = .scaleToFill
        self.carImageView.clipsToBounds = true
        self.carImageView.image = UIImage(named: "brandImage")
        self.titleLabel.textAlignment = .left
        self.priceTitleLabel.textAlignment = .left
        self.priceLabel.textAlignment = .left
        self.locationTitleLabel.textAlignment = .right
        self.locationLabel.textAlignment = .right
        self.titleLabel.textColor = .primaryColor
        self.titleLabel.font = .primaryFontSemiBold(size: 15)
        self.priceTitleLabel.textColor = .primaryColor
        self.priceTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.priceLabel.textColor = .gray
        self.priceLabel.font = .primaryFont(size: 15)
        self.locationTitleLabel.textColor = .primaryColor
        self.locationTitleLabel.font = .primaryFontSemiBold(size: 15)
        self.locationLabel.textColor = .gray
        self.locationLabel.font = .primaryFont(size: 15)
    }
    
    func setupCell(car: Car) {
        self.titleLabel.text = car.title
        self.priceLabel.text = car.price ?? "Not Specified"
        self.locationLabel.text = car.location ?? "Not Specified"
        self.priceTitleLabel.text = "Price"
        self.locationTitleLabel.text = "Location"
        
        if let imageUrl = URL(string: car.mainPhoto) {
            self.getData(from: imageUrl) { data, response, error in
                guard let data = data, error == nil else {
                    self.carImageView.image = UIImage(named: "carsaleIcon")
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    guard let _self = self else { return }
                    _self.carImageView.image = UIImage(data: data)
                }
            }
        } else {
            self.carImageView.image = UIImage(named: "carsaleIcon")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
