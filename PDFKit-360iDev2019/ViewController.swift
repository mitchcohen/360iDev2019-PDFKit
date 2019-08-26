//
//  ViewController.swift
//  PDFKit-360iDev2019
//
//  Created by Mitch Cohen on 8/25/19.
//  Copyright © 2019 Proactive Interactive, LLC. All rights reserved.
//

//TODO:
//Share
//Add QRCode to presentation
//REVIEW AND PRACTICE!


import UIKit
import PDFKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet var pdfViewContainer: UIView!
    @IBOutlet var name: UITextField!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    
    var pdfView:PDFView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pdfView = PDFView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: pdfViewContainer.frame.width,
                                        height: pdfViewContainer.frame.height))
        pdfView?.document = pdfDocumentFromFile()
        pdfView?.autoScales = true
        pdfViewContainer.addSubview(pdfView!)
        
        self.printBounds()
        
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        if name.text?.lengthOfBytes(using: .utf8) ?? 0 < 3 {
            return
        }
        let annotation = self.annotationForName()
        self.addAnnotationToFirstPage(annotation: annotation)
        
        let button = self.buttonAnnotation()
        self.addAnnotationToFirstPage(annotation: button)
        sendButton.isHidden = false
        
        addAnnotationToFirstPage(annotation: annotationForQRCode())

        savePDF()
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sharePDF()
    }
    
    func pdfDocumentFromFile() -> PDFDocument? {
        let url = Bundle.main.url(forResource: "faketicket2", withExtension: "pdf")
        let document = PDFDocument.init(url: url!)
        return document
    }
    
    func printBounds() {
        let bounds = pdfView?.bounds
        print("PDF View Bounds: \(String(describing: bounds))")
        
        let displayBox = (pdfView?.displayBox)!
        let firstPage = pdfView?.document?.page(at: 0)
        let pageBounds = firstPage?.bounds(for: displayBox) ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        print("pageBounds: \(pageBounds)")
    }

    func addAnnotationToFirstPage(annotation:PDFAnnotation) {
        let firstPage = pdfView?.document?.page(at: 0)
        firstPage?.addAnnotation(annotation)
    }

    func annotationForName() -> PDFAnnotation {
        let frame = CGRect(x: 80, y: 600, width: 200, height: 80)
        
        //flag value 128 = locked - https://www.xspdf.com/api/html/T_XsPDF_Pdf_Annotations_PdfAnnotationFlags.htm
        let properties = [PDFAnnotationKey.flags : 128]
        
        let annotation = PDFAnnotation.init(bounds: frame, forType: PDFAnnotationSubtype.freeText, withProperties: properties)
//        annotation.setValue(128, forAnnotationKey: PDFAnnotationKey.flags)

        annotation.contents = name.text
        annotation.fontColor = UIColor.red
        annotation.font = UIFont.systemFont(ofSize: 36)
        annotation.color = UIColor.clear
        //annotation.isReadOnly = true //Just for text entry fields
        
        return annotation
    }
    
    func buttonAnnotation() -> PDFAnnotation {
        let frame = CGRect(x: 150, y: 0, width: 400, height: 80)
        let annotation = PDFAnnotation.init(bounds: frame, forType: .freeText, withProperties: nil)
        
        annotation.contents = "Click for Mitch!"
        annotation.alignment = .center
        annotation.fontColor = UIColor.purple
        annotation.font = UIFont.systemFont(ofSize: 36)
        annotation.color = UIColor.lightGray
        
        let url = URL.init(string: "http://www.cocoaheadsboston.org")
        let action = PDFActionURL(url: url!)
        annotation.action = action
        
        return annotation
    }
    
    func annotationForQRCode() -> PDFAnnotation {
        let frame = CGRect(x: 0, y: 80, width: 200-35, height: 200-35)
        let image = qrcode()
        let annotation = ImageAnnotation(imageBounds: frame, image: image)
        return annotation
    }
    
    func qrcode() -> UIImage {
        let urlString = "http://www.cocoaheadsboston.org/ticket/\(name.text ?? ""))"
        let data = urlString.data(using: .utf8)!
        let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data])
        let transform = CGAffineTransform(scaleX: 7, y: 7)
        if let output = qrCodeFilter?.outputImage?.transformed(by: transform) {
            let context = CIContext(options: [:])
            let image = UIImage.init(cgImage: context.createCGImage(output, from: output.extent)!)
            return image
        }
        assertionFailure()
        return UIImage()
    }
    
    func savePDF() {
        #if targetEnvironment(simulator)
            let path = URL(string: "file:///Users/mcohen/Desktop/PDFKit/awesome.pdf")!
        #else
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("awesome.pdf")
        #endif
        print(path)
        self.pdfView?.document?.write(to: path) //We don't really need to write this here - just demo'ing code
    }
    
    func sharePDF() {
        let pdfData = pdfView?.document?.dataRepresentation()
        let vc = UIActivityViewController.init(activityItems: [pdfData!], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = sendButton
        self.present(vc, animated: true) {
            //
        }
    }
    
}

public class ImageAnnotation: PDFAnnotation {
    
    private var _image: UIImage?
    
    public init(imageBounds: CGRect, image: UIImage?) {
        self._image = image
        super.init(bounds: imageBounds, forType: .stamp, withProperties: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = self._image?.cgImage else {
            return
        }
        let drawingBox = self.page?.bounds(for: box)
        //Virtually changing reference frame since the context is agnostic of them. Necessary hack.
        context.draw(cgImage, in: self.bounds.applying(CGAffineTransform(
            translationX: (drawingBox?.origin.x)! * -1.0,
            y: (drawingBox?.origin.y)! * -1.0)))
    }
    
}
