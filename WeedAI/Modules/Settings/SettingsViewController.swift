//
//  SettingsViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var isAzureSelected = true
    var sensorsSelected: [Int] = []
    
    @IBOutlet var sensorCheckboxes: [UIImageView]!
    @IBOutlet var radioButtons: [UIImageView]!
    public static func getInstance() -> SettingsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        readData()
    }
    
    private func readData() {
        isAzureSelected = SettingsManager.shared.checkIfUseAzureStorage()
        sensorsSelected = SettingsManager.shared.getSensors().map { $0.rawValue }
        updateViews()
    }
    
    @IBAction func selectStorage(_ sender: UIButton) {
        isAzureSelected = sender.tag == 1
        updateViews()
    }
    
    @IBAction func enableSensor(_ sender: UIButton) {
        if(sensorsSelected.contains(sender.tag)) {
            sensorsSelected.remove(at: sensorsSelected.firstIndex(of: sender.tag) ?? 0)
        } else {
            sensorsSelected.append(sender.tag)
        }
        updateViews()
    }
    
    @IBAction func didSaveButtonClick(_ sender: Any) {
        SettingsManager.shared.saveSensors(sensorsSelected)
        SettingsManager.shared.saveStorageMethod(isAzure: isAzureSelected)
        let alert = UIAlertController(
            title: "Done",
            message: "The settings were saved",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func updateViews() {
        radioButtons.forEach { $0.image = UIImage(systemName: "circle") }
        radioButtons[isAzureSelected ? 1 : 0].image = UIImage(systemName: "largecircle.fill.circle")
        sensorCheckboxes.forEach { sc in  sc.image = UIImage(systemName: sensorsSelected.contains(sc.tag) ? "checkmark.square" : "square")  }
    }
}
