//
//  DialogPhotoViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/28/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class DialogPhotoViewController: UIViewController {
    
    weak var delegate: DialogPhotoProtocol?
    
    var weedNumber: WeedNumber = .ONE
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sensorsTextView: UITextView!
    @IBOutlet var radioButtons: [UIImageView]!
    
    public static func getInstance(delegate: DialogPhotoProtocol) -> DialogPhotoViewController {
        let vc: DialogPhotoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        vc.delegate = delegate
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        enableRadioButton()
    }
    
    @IBAction func didCloseClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didContinueButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.photoEdited(description: descriptionTextField.text ?? "", weedNumber: weedNumber)
    }
    
    @IBAction func didRadioButtonClick(_ sender: UIButton) {
        weedNumber = WeedNumber(rawValue: sender.tag) ?? .ONE
        enableRadioButton()
    }
    
    private func enableRadioButton() {
        radioButtons.forEach { $0.image = UIImage(systemName: "circle") }
        radioButtons[weedNumber.rawValue].image = UIImage(systemName: "largecircle.fill.circle")
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        descriptionTextField.resignFirstResponder()
    }

}

protocol DialogPhotoProtocol: class {
    func photoEdited(description: String, weedNumber: WeedNumber)
}

