//
//  ViewController.swift
//  sampleTakePictureApp
//
//  Created by Muneharu Onoue on 2017/03/23.
//  Copyright © 2017年 Muneharu Onoue. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var mySession : AVCaptureSession!
    var myDevice : AVCaptureDevice!
    var myImageOutput : AVCapturePhotoOutput!
    @IBOutlet weak var takeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mySession = AVCaptureSession()

        let myDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        let videoInput = try! AVCaptureDeviceInput(device: myDevice)
        
        mySession.addInput(videoInput)
        myImageOutput = AVCapturePhotoOutput()
        mySession.addOutput(myImageOutput)
        
        let myVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession)
        myVideoLayer.frame = view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(myVideoLayer)
        view.bringSubview(toFront: takeButton)
        
        mySession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicture(_ sender: UIButton) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        myImageOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }

}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        savePhoto(imageDataBuffer: photoSampleBuffer!)
    }

    func savePhoto(imageDataBuffer: CMSampleBuffer) {
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: imageDataBuffer,
                previewPhotoSampleBuffer: nil) else {
            return
        }
        guard let image = UIImage(data: imageData) else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
