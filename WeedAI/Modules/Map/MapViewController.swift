//
//  MapViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController {
    
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public static func getInstance() -> MapViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        let fetchRequest: NSFetchRequest<PhotoInfo> = PhotoInfo.fetchRequest()
        do {
            let photos = try managedObjectContext.fetch(fetchRequest) as [PhotoInfo]
            if(photos.count > 0) {
                mapView.delegate = self
                mapView.addAnnotations(photos.map { addMarker(photo: $0) })
                if let lastPhoto = photos.last {
                    let locationLastPhoto = CLLocationCoordinate2D(latitude: lastPhoto.latitude, longitude: lastPhoto.longitude)
                    centerMapOnLocation(locationLastPhoto)
                }
            } else {
                mapView.isHidden = true
            }
        } catch {
            mapView.isHidden = true
        }
    }

    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addMarker(photo: PhotoInfo) -> PhotoMKPointAnnotation {
        let annotation = PhotoMKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude)
        annotation.title = photo.name
        annotation.photoInfo = photo
        return annotation
    }
    
    @IBAction func closeModal(_ sender: Any) {
        photoContainerView.isHidden = true
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let photoMKPointAnnotation  = view.annotation as? PhotoMKPointAnnotation, let photoInfo = photoMKPointAnnotation.photoInfo, let data = photoInfo.photo {
            photoTitleLabel.text = photoInfo.name
            photoImageView.image = UIImage(data: data)
            photoContainerView.isHidden = false
            mapView.deselectAnnotation(photoMKPointAnnotation, animated: false)
        }
    }
}

class PhotoMKPointAnnotation: MKPointAnnotation {
    var photoInfo: PhotoInfo?
}
