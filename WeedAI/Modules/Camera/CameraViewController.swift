//
//  CameraViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/22/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var weedTypeLabel: UILabel!
    @IBOutlet weak var photoContainer: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    weak var cameraDelegate: CameraProtocol?
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    
    var lastZoomFactor: CGFloat = 1.0
    
    var photoViewModel = PhotoViewModel(title: "", image: Data(), description: "", weedNumber: .ONE)
    
    public static func getInstance(cameraDelegate: CameraProtocol) -> CameraViewController {
        let vc: CameraViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        vc.cameraDelegate = cameraDelegate
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Camera"
        setupConditions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
    }
    
    private func checkPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: setupSession()
        case .denied: alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureDevice = input.device
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    @IBAction func didCameraButtonClick(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let photoTitle = formatter.string(from: today)
        let image = UIImage(data: imageData)
        photoContainer.isHidden = false
        photoLabel.text = photoTitle
        photoImageView.image = image
        photoViewModel.title = photoTitle
        photoViewModel.image = imageData
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    @IBAction func didEditPhotoButtonClick(_ sender: Any) {
        let vc = DialogPhotoViewController.getInstance(delegate: self)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didCancelPhotoButtonClick(_ sender: Any) {
        photoContainer.isHidden = true
    }
    
    @IBAction func didAcceptPhotoButtonClick(_ sender: Any) {
        cameraDelegate?.savePhoto(photo: photoViewModel)
        photoContainer.isHidden = true
    }
    
    @IBAction func didFlashButtonClick(_ sender: Any) {
        if let device = captureDevice, device.hasTorch {
            do {
                try device.lockForConfiguration()
            } catch {
                print("\(error.localizedDescription)")
            }
            if device.isTorchActive {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func didConditionButtonClick(_ sender: Any) {
        let vc = DialogConditionsViewController.getInstance(delegate: self)
        present(vc, animated: true, completion: nil)
    }
    
    func setupConditions() {
        switch ConditionManager.shared.weatherType {
        case .SUNNY:
            weatherTypeImageView.image = UIImage(named: "sun")
        case .PARTIAL:
            weatherTypeImageView.image = UIImage(named: "clouds-and-sun")
        case .CLOUDY:
            weatherTypeImageView.image = UIImage(named: "cloud")
        }
        weedTypeLabel.text = ConditionManager.shared.weedType
    }
    
    @IBAction func handleTapToFocus(sender: UITapGestureRecognizer) {
        if let device = captureDevice {
            let focusPoint = sender.location(in: previewView)
            let focusScaledPointX = focusPoint.x / previewView.frame.size.width
            let focusScaledPointY = focusPoint.y / previewView.frame.size.height
            if device.isFocusModeSupported(.autoFocus) && device.isFocusPointOfInterestSupported {
                do {
                    try device.lockForConfiguration()
                } catch {
                    print("ERROR: Could not lock camera device for configuration")
                    return
                }
                device.focusMode = .autoFocus
                device.focusPointOfInterest = CGPoint(x: focusScaledPointX, y: focusScaledPointY)
                device.unlockForConfiguration()
            }
        }
    }
    
    @IBAction func handlePinchToZoom(pinch: UIPinchGestureRecognizer) {
        if let device = captureDevice {
            func minMaxZoom(_ factor: CGFloat) -> CGFloat {
                return min(max(factor, 1.0), device.activeFormat.videoMaxZoomFactor)
            }

            func update(scale factor: CGFloat) {
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    device.videoZoomFactor = factor
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
            let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)

            switch pinch.state {
            case .began: fallthrough
            case .changed: update(scale: newScaleFactor)
            case .ended:
                lastZoomFactor = minMaxZoom(newScaleFactor)
                update(scale: lastZoomFactor)
            default: break
            }
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {

        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.checkPermissions()
                        
                    }
                    
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }

    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
}

protocol CameraProtocol: class {
    func savePhoto(photo: PhotoViewModel)
}

extension CameraViewController: DialogConditionsProtocol {
    func conditionsSelected(weatherType: WeatherType, weedType: String) {
        ConditionManager.shared.weedType = weedType
        ConditionManager.shared.weatherType = weatherType
        setupConditions()
    }
}

extension CameraViewController: DialogPhotoProtocol {
    func photoEdited(description: String, weedNumber: WeedNumber) {
        photoViewModel.description = description
        photoViewModel.weedNumber = weedNumber
    }
}
