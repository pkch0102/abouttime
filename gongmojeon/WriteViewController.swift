//
//  WriteViewController.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 7. 1..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuartzCore
import CoreData

class WriteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var moonjang: UITextField!
    let imagePicker = UIImagePickerController()
    var mission : Mission = Mission()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInfo(dict : Mission){
        self.mission = dict
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if(self.photoView.image == nil){
            let dialog = UIAlertController(title: "알람", message: "사진을 기입해 주세요!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
            
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            
            return
        }
        
        self.saveData()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func imagePicker(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "사진을 가져올 곳을 선택해 주세요.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "카메라", style: UIAlertActionStyle.default){
            UIAlertAction in
                self.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "앨범", style: UIAlertActionStyle.cancel){
            
            UIAlertAction in
            self.openPhotoLibrary()
            
        })
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        //        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePicker, animated: true)
    }
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        self.photoView.image = image
        // do something with it
        //imageView.image = image
        
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveData() {
        
        
        
        let context = self.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "CompleteMission", in: context)
        let completeMiission: CompleteMission = NSManagedObject(entity: entityDescription!, insertInto: context) as! CompleteMission
        let imageName: String! = self.writePhoto(image: self.photoView.image!)
        
        if(imageName != nil) {
            completeMiission.path = imageName
        }
        
        
        
        let idx = mission.idx
        if(idx != nil){
            completeMiission.missionidx = idx
        }
        
        let date = NSDate()
        if(date != nil){
            completeMiission.date = date
        }
        
        let text = self.moonjang.text
        completeMiission.text = text
        
        completeMiission.relationship = self.mission
        
        
        
        do {
            try context.save()
            
        }catch let error as NSError {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
    
    func writePhoto(image: UIImage) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fileName: String = formatter.string(from: Date()) + ".png"
        
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL: URL! = documentsURL.appendingPathComponent("\(fileName)")
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: fileURL, options: .atomic)
                
            }
        } catch {
        }
        return fileName
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
