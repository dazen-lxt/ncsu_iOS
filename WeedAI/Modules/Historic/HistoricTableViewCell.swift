//
//  HistoricTableViewCell.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/22/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class HistoricTableViewCell: UITableViewCell {
    
    @IBOutlet weak var syncedLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weedTypeLabel: UILabel!
    
    func configureCell(photoInfo: PhotoInfo) {
        if let photo = photoInfo.photo {
            photoImageView.image = UIImage(data: photo)
        }
        titleLabel.text = photoInfo.name
        descriptionLabel.text = photoInfo.photoDescription
        weedTypeLabel.text = "\(photoInfo.typeWeed ?? "") (\(photoInfo.weedsAmount ?? ""))"
        locationLabel.text = "Lat: \(photoInfo.latitude.format(f: ".2")) Lng:\(photoInfo.longitude.format(f: ".2"))"
        weatherLabel.text = photoInfo.weather
        syncedLabel.isHidden = !photoInfo.synced
        switch WeatherType.getFromStringValue(value: photoInfo.weather ?? "") {
        case .SUNNY:
            weatherImageView.image = UIImage(named: "sun")
        case .PARTIAL:
            weatherImageView.image = UIImage(named: "clouds-and-sun")
        case .CLOUDY:
            weatherImageView.image = UIImage(named: "cloud")
        }
    }
    
}
