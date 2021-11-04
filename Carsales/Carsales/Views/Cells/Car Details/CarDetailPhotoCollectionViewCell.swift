//
//  CarDetailPhotoCollectionViewCell.swift
//  Carsales
//
//  Created by Steven Layug on 31/10/21.
//

import UIKit

class CarDetailPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailImageView.contentMode = .scaleToFill
    }
    
    func setupDetailImageCell(imageUrl: String) {
        if let url = URL(string: imageUrl), imageUrl != "" {
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    self.detailImageView.image = UIImage(named: "carsaleIcon")
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    guard let _self = self else { return }
                    _self.detailImageView.image = UIImage(data: data)
                }
            }
        } else {
            self.detailImageView.image = UIImage(named: "carsaleIcon")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
