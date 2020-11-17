//
//  DialogConditionsViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/24/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class DialogConditionsViewController: UIViewController {

    weak var delegate: DialogConditionsProtocol?
    
    var weatherSelected = ConditionManager.shared.weatherType
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var weedSearchTextField: WeedSearchTextField!
    
    @IBOutlet var radioButtons: [UIImageView]!
    
    public static func getInstance(delegate: DialogConditionsProtocol) -> DialogConditionsViewController {
        let vc: DialogConditionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        enableRadioButton()
        weedSearchTextField.delegate = self
        weedSearchTextField.text = ConditionManager.shared.weedType
        checkTextField(text: weedSearchTextField.text ?? "")
    }
    
    @IBAction func didCloseClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didContinueButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.conditionsSelected(weatherType: weatherSelected, weedType: weedSearchTextField.text ?? "")
    }
    
    @IBAction func didRadioButtonClick(_ sender: UIButton) {
        weatherSelected = WeatherType(rawValue: sender.tag) ?? .SUNNY
        enableRadioButton()
    }
    
    private func enableRadioButton() {
        radioButtons.forEach { $0.image = UIImage(systemName: "circle") }
        radioButtons[weatherSelected.rawValue].image = UIImage(systemName: "largecircle.fill.circle")
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        weedSearchTextField.resignFirstResponder()
    }
        
}

extension DialogConditionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextField(text: textField.text ?? "")
    }
    
    func checkTextField(text: String) {
        continueButton.isEnabled = !(text).isEmpty
        continueButton.backgroundColor = !(text).isEmpty ? UIColor.white : UIColor.gray
        continueButton.alpha = !text.isEmpty ? 1.0 : 0.5
    }
}

protocol DialogConditionsProtocol: class {
    func conditionsSelected(weatherType: WeatherType, weedType: String)
}
