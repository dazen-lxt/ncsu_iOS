//
//  MapViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit
import CoreData

class HistoricViewController: UIViewController {
    
    @IBOutlet weak var noRecordsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var photos: [PhotoInfo] = []
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public static func getInstance() -> HistoricViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Historic"
        let fetchRequest: NSFetchRequest<PhotoInfo> = PhotoInfo.fetchRequest()
        do {
            photos = try managedObjectContext.fetch(fetchRequest) as [PhotoInfo]
            noRecordsLabel.isHidden = photos.count > 0
            tableView.isHidden = photos.count == 0
            tableView.delegate = self
            tableView.dataSource = self
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
    }

}

extension HistoricViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoricTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(photoInfo: photos[indexPath.row])
        return cell
    }
    
    
}
