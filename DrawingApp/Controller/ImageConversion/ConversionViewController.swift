//
//  ConversionViewController.swift
//  DrawingApp
//
//  Created by Gagan vats on 28/03/21.
//  Copyright © 2021 Ranosys. All rights reserved.
//

import UIKit
import SwiftImage

class ConversionViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    public var typeOfBlindness = Int()
    @IBOutlet weak var SegmentController: UISegmentedControl!
    @IBAction func TypeOfColorBlindness(_ sender: Any) {
        switch SegmentController.selectedSegmentIndex {
        case 0:
            typeOfBlindness = 0
        case 1:
            typeOfBlindness = 1
        default:
            typeOfBlindness = 3
        }
    }
    @IBOutlet weak var imageview: UIImageView!
    
    @IBAction func AddImage(_ sender: UIButton) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = .photoLibrary
        self.present(imagecontroller, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageview.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        imageview.image = rechImage(imageView: imageview)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func rechImage(imageView:UIImageView) -> UIImage {
        var image = Image<RGBA<UInt8>>(uiImage: imageView.image!)
        let height = Int((image.height))
        let width = Int((image.width))
        let blindness = ["Protanope","Deuteranope","Tritanope"]
        let conversionArray = [[0.0,2.02344,-2.52581,0.0, 1.0,0.0,0.0,0.0,1.0],
                              [1.0,0.0, 0.0,0.494207,0.0,1.24827,0.0,0.0,1.0],
                              [1.0,0.0,0.0,0.0,1.0,0.0,-0.395913, 0.801109, 0.0]
                              ]
        let CVDMatrix = Dictionary(uniqueKeysWithValues: zip(blindness,conversionArray))
        let type = blindness[typeOfBlindness]
        let cvd = CVDMatrix[type]
        let cvd_a = cvd?[0]
        let cvd_b = cvd?[1]
        let cvd_c = cvd?[2]
        let cvd_d = cvd?[3]
        let cvd_e = cvd?[4]
        let cvd_f = cvd?[5]
        let cvd_g = cvd?[6]
        let cvd_h = cvd?[7]
        let cvd_i = cvd?[8]

        for y  in 0 ..< height {
            for x in 0 ..< width{
                if image.pixelAt(x: x, y: y) != nil {
                var p = image[x,y]
                let r = p.red
                print("previsouy p.red was \(p.red)")
                let g = p.green
                let b = p.blue
                print("previsouy red was \(image[x,y].red)")
                    // RGB to LMS matrix conversion
            let sumL = [17.8824 * Double(r) , 43.5161 * Double(g) , (4.11935 * Double(b) ) ]
            let sumM = [(3.45565 * Double(r)) , (27.1554 * Double(g)) , (3.86714 * Double(b))]
            let sumS = [(0.0299566 * Double(r)) , (0.184309 * Double(g)) , (1.46709 * Double(b)) ]
                    let L = sumL[0]+sumL[1]+sumL[2]
                    let M = sumM[0]+sumM[1]+sumM[2]
                    let S = sumS[0]+sumS[1]+sumS[2]
                    // Simulate color blindness
            let l = (cvd_a! * L) + (cvd_b! * M) + (cvd_c! * S)
           let  m = (cvd_d! * L) + (cvd_e! * M) + (cvd_f! * S)
            let s = (cvd_g! * L) + (cvd_h! * M) + (cvd_i! * S)
                    // LMS to RGB matrix conversion
            var R = (0.0809444479 * l) + (-0.130504409 * m) + (0.116721066 * s)
            var G = (-0.0102485335 * l) + (0.0540193266 * m) + (-0.113614708 * s)
            var B = (-0.000365296938 * l) + (-0.00412161469 * m) + (0.693511405 * s)
                    // Isolate invisible colors to color vision deficiency (calculate error matrix)
            R = Double(r) - R
            G = Double(g) - G
            B = Double(b) - B
                    // Shift colors towards visible spectrum (apply error modifications)
                    let RR = (0.0 * R) + (0.0 * G) + (0.0 * B);
                    let GG = (0.7 * R) + (1.0 * G) + (0.0 * B);
                    let BB = (0.7 * R) + (0.0 * G) + (1.0 * B);
                    // Add compensation to original values
            R = RR + Double(r)
            G = GG + Double(g)
            B = BB + Double(b)
                    // Clamp values
            if R < 0 {R=0}
            if R > 255 { R = 255 }
            if G < 0 {G = 0}
            if G > 255 { G = 255 }
            if B < 0 { B = 0 }
            if B > 255 { B = 255}
                    // Record color
            p.red = UInt8(R)
            p.green = UInt8(G)
            p.blue = UInt8(B)
            image[x,y] = p
                print("now red is \(image[x,y].red)")
                print("now p.red is \(p.red)")

            } else {
                // `pixel` is safe: `nil` is returned when out of bounds
                print("Out of bounds")
            }
        }
    }
        return  image.uiImage

    }

    


}
