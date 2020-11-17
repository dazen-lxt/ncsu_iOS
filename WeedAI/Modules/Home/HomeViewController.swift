//
//  HomeViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData
import GoogleSignIn
import AZSClient

class HomeViewController: UIViewController {
    
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var timer: Timer!
    var accelerometerData: CMAccelerometerData?
    var gyroData: CMGyroData?
    var magnetometerData: CMMagnetometerData?
    var altimeterData: CMAltitudeData?
    let motion = CMMotionManager()
    let altimeter = CMAltimeter()
    let queue = OperationQueue()
    var azureContainer: AZSCloudBlobContainer?
    
    public static func getInstance() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        startSensors()
        setupAzure()
    }
    
    func startSensors() {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
        }
        if self.motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0
            self.motion.startGyroUpdates()
        }
        if self.motion.isMagnetometerAvailable {
            self.motion.magnetometerUpdateInterval = 1.0 / 60.0
            self.motion.startMagnetometerUpdates()

        }
        altimeter.startRelativeAltitudeUpdates(to: queue) { [weak self] (data, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            self?.altimeterData = data
        }

        // Configure a timer to fetch the data.
        self.timer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
            if let data = self.motion.accelerometerData {
                self.accelerometerData = data
            }
            if let data = self.motion.gyroData {
                self.gyroData = data
            }
            if let data = self.motion.magnetometerData {
                self.magnetometerData = data
            }
        })
        RunLoop.current.add(self.timer, forMode: .default)
       
    }

    @IBAction func didStartButtonClicked(_ sender: Any) {
        if(GoogleManager.shared.email == nil) {
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            if ConditionManager.shared.weedType.isEmpty {
                let vc = DialogConditionsViewController.getInstance(delegate: self)
                present(vc, animated: true, completion: nil)
            } else {
                let vc = CameraViewController.getInstance(cameraDelegate: self)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setupAzure() {
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: "SharedAccessSignature=sv=2019-12-12&ss=btqf&srt=sco&st=2020-10-09T15%3A05%3A52Z&se=2020-12-31T15%3A05%3A00Z&sp=rwdxlacup&sig=BZtGRAP3ZqZiFi7vq6e7wZ6unMMC%2BLNOweKPtVGSRvQ%3D;BlobEndpoint=https://weedsmedia.blob.core.usgovcloudapi.net")
            let blobClient = account.getBlobClient()
            azureContainer = blobClient.containerReference(fromName: "images")
            uploadImagesByAzure()
        } catch {
            print(error)
        }
    }
    
    func uploadImagesByAzure() {
        let fetchRequest : NSFetchRequest<PhotoInfo> = PhotoInfo.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for photoInfo in (results as [PhotoInfo]) where photoInfo.photo != nil {
                let data = PhotoInfoModelData(name: photoInfo.name ?? "", description: photoInfo.photoDescription ?? "", weather: photoInfo.weather ?? "", weedType: photoInfo.typeWeed ?? "", weedsAmount: photoInfo.weedsAmount ?? "", latitude: "\(photoInfo.latitude)", longitude: "\(photoInfo.longitude)", email: GoogleManager.shared.email ?? "", sensors: (photoInfo.sensors?.allObjects as? [SensorInfo] ?? []).map { SensorModelData(name: $0.sensorName ?? "", unit: $0.units ?? "", values: ($0.values?.allObjects as? [SensorValue] ?? []).map { sensorValue in "\(sensorValue.value)" } ) })
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(data)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                let blobInfo = azureContainer?.blockBlobReference(fromName: "\(photoInfo.name ?? "").info")
                blobInfo?.upload(fromText: json ?? "", completionHandler: { (err) in
                    print(err)
                })
                let blob = azureContainer?.blockBlobReference(fromName: "\(photoInfo.name ?? "").jpg")
                blob?.upload(from: photoInfo.photo!, completionHandler: { (err) in
                    print(err)
                })
            }
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
    }
}


extension HomeViewController: DialogConditionsProtocol {
    func conditionsSelected(weatherType: WeatherType, weedType: String) {
        ConditionManager.shared.weedType = weedType
        ConditionManager.shared.weatherType = weatherType
        let vc = CameraViewController.getInstance(cameraDelegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: CameraProtocol {
    func savePhoto(photo: PhotoViewModel) {
        //Accelerometer
        let accValueX = SensorValue(context: managedObjectContext)
        if let value = self.accelerometerData?.acceleration.x {
            accValueX.value = value
        }
        let accValueY = SensorValue(context: managedObjectContext)
        if let value = self.accelerometerData?.acceleration.y {
            accValueY.value = value
        }
        let accValueZ = SensorValue(context: managedObjectContext)
        if let value = self.accelerometerData?.acceleration.z {
            accValueZ.value = value
        }
        let sensorAccelerometer = SensorInfo(context: managedObjectContext)
        sensorAccelerometer.sensorName = "Accelerometer"
        sensorAccelerometer.units = "m/s2"
        sensorAccelerometer.values = NSSet(array: [accValueX, accValueY, accValueZ])
        //Gyroscopio
        let gyrValueX = SensorValue(context: managedObjectContext)
        if let value = self.gyroData?.rotationRate.x {
            gyrValueX.value = value
        }
        let gyrValueY = SensorValue(context: managedObjectContext)
        if let value = self.gyroData?.rotationRate.y {
            gyrValueY.value = value
        }
        let gyrValueZ = SensorValue(context: managedObjectContext)
        if let value = self.gyroData?.rotationRate.z {
            gyrValueZ.value = value
        }
        let sensorGyro = SensorInfo(context: managedObjectContext)
        sensorGyro.sensorName = "Gyroscope"
        sensorGyro.units = "rad/s"
        sensorGyro.values = NSSet(array: [gyrValueX, gyrValueY, gyrValueZ])
        //Magnetometer
        let magValueX = SensorValue(context: managedObjectContext)
        if let value = self.magnetometerData?.magneticField.x {
            magValueX.value = value
        }
        let magValueY = SensorValue(context: managedObjectContext)
        if let value = self.magnetometerData?.magneticField.y {
            magValueY.value = value
        }
        let magValueZ = SensorValue(context: managedObjectContext)
        if let value = self.magnetometerData?.magneticField.z {
            magValueZ.value = value
        }
        let sensorMagnetometer = SensorInfo(context: managedObjectContext)
        sensorMagnetometer.sensorName = "Magnetometer"
        sensorMagnetometer.units = "μT"
        sensorMagnetometer.values = NSSet(array: [magValueX, magValueY, magValueZ])
        //Pressure
        let pressureValue = SensorValue(context: managedObjectContext)
        if let value = self.altimeterData?.pressure {
            pressureValue.value = value.doubleValue
        }
        let sensorPressure = SensorInfo(context: managedObjectContext)
        sensorPressure.sensorName = "Pressure"
        sensorPressure.units = "hPa"
        sensorPressure.values = NSSet(array: [pressureValue])
        //Photo
        let photoInfo = PhotoInfo(context: managedObjectContext)
        photoInfo.name = photo.title
        photoInfo.photo = photo.image
        photoInfo.photoDescription = photo.description
        photoInfo.weedsAmount = photo.weedNumber.getStringValue()
        photoInfo.weather = ConditionManager.shared.weatherType.getStringValue()
        photoInfo.typeWeed = ConditionManager.shared.weedType
        photoInfo.sensors = NSSet(array: [sensorAccelerometer, sensorGyro, sensorMagnetometer, sensorPressure])
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
