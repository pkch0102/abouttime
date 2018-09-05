//
//  GalleryViewController.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 7. 11..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import CoreData

class GalleryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var galleryTableView: UITableView!
    
    var completeMissionArray:[CompleteMission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getCompleteMissionList()
    }
    
    func getImage(fileName: String) -> UIImage {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL: URL! = documentsURL.appendingPathComponent("\(fileName)")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        }
        return UIImage()
 
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getCompleteMissionList() {
        let completeMissionListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CompleteMission")
        do{
            self.completeMissionArray = try getContext().fetch(completeMissionListFetch) as! [CompleteMission]
        }
        catch{
            fatalError("Failed to fetch employees: \(error)")
        }
        self.galleryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completeMissionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GalleryTableCell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableCell", for: indexPath) as! GalleryTableCell
        let model : CompleteMission = self.completeMissionArray[indexPath.row]
        let date : NSDate = model.date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate: String = dateFormatter.string(from: date as Date)
        
        cell.firstImageView.image = getImage(fileName: model.path!)
        cell.completeMissionDate.text = stringDate
        cell.completeMissionTitle.text = model.relationship?.title
        cell.completeMissionComent.text = model.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
