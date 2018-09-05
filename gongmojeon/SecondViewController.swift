//
//  SecondViewController.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 6. 25..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MissionTableView: UITableView!
    var d_missionArray:[Mission] = []
    var w_missionArray:[Mission] = []
    var m_missionArray:[Mission] = []
    var a_missionArray:[Mission] = []
    var cnt : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view,
        self.MissionTableView.delegate = self
        self.MissionTableView.dataSource = self
        
        self.getMissionList()
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        let label = UILabel()
        if(section == 0) {
            label.text = "일간"
        }else if(section == 1) {
            label.text = "주간"
        }else if(section == 2) {
            label.text = "월간"
        }else if(section == 3) {
            label.text = "연간"
        }
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.frame = CGRect(x:0,y:0,width:100,height:30)
        view.addSubview(label)
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int = 0
        if (section == 0) {
            count = self.d_missionArray.count
        }else if (section == 1) {
            count = self.w_missionArray.count
        }else if (section == 2) {
            count = self.m_missionArray.count
        }else if (section == 3) {
            count = self.a_missionArray.count
        }
        
        if(count % 2 == 1){
            count /= 2
            count += 1
        }else{
            count /= 2
        }
        
        return count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MissionListTableCell = tableView.dequeueReusableCell(withIdentifier: "MissionListTableCell", for: indexPath) as! MissionListTableCell
        
        var tmpArray:Array<Any> = []
        
        if indexPath.section == 0 {
            tmpArray = self.d_missionArray
        }else if indexPath.section == 1 {
            tmpArray = self.w_missionArray
        }else if indexPath.section == 2 {
            tmpArray = self.m_missionArray
        }else if indexPath.section == 3 {
            tmpArray = self.a_missionArray
        }
        cell.leftSelectBtn.tag = 2*indexPath.row*10 + indexPath.section
        cell.leftSelectBtn.addTarget(self, action: #selector(showWriteView), for: .touchUpInside)
        let leftdict : Mission = tmpArray[2*indexPath.row] as! Mission
        cell.leftLabel.text = leftdict.title as! String
        if(2*indexPath.row + 1 < tmpArray.count){
            let rightdict : Mission = tmpArray[2*indexPath.row + 1] as! Mission
            cell.rightview.isHidden = false
            cell.rightLabel.text = rightdict.title as! String
            cell.rightSelectkBtn.tag = (2*indexPath.row + 1)*10 + indexPath.section
            cell.rightSelectkBtn.addTarget(self, action: #selector(showWriteView), for: .touchUpInside)
            
        }else{
            cell.rightview.isHidden = true
        }
        
        
        
        return cell
    }
    
    func showWriteView(sender:UIButton) {
        let section:Int = sender.tag%10
        let idx:Int = sender.tag/10
        
        var tmpArray:Array<Any> = []
        
        if section == 0 {
            tmpArray = self.d_missionArray
        }else if section == 1 {
            tmpArray = self.w_missionArray
        }else if section == 2 {
            tmpArray = self.m_missionArray
        }else if section == 3 {
            tmpArray = self.a_missionArray
        }
        let dict : Mission = tmpArray[idx] as! Mission
        
        let controller: WriteViewController = storyboard!.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        controller.setInfo(dict: dict)
        self.present(controller, animated: true, completion: nil)
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getMissionList() {
        let missionListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Mission")
        var missionList : [Mission] = []
        
        var predicate = NSPredicate(format: "type = 1")
        missionListFetch.predicate = predicate
        do {
            missionList = try getContext().fetch(missionListFetch) as! [Mission]
            self.d_missionArray = missionList
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        predicate = NSPredicate(format: "type = 2")
        missionListFetch.predicate = predicate
        do {
            missionList = try getContext().fetch(missionListFetch) as! [Mission]
            self.w_missionArray = missionList
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        predicate = NSPredicate(format: "type = 3")
        missionListFetch.predicate = predicate
        do {
            missionList = try getContext().fetch(missionListFetch) as! [Mission]
            self.m_missionArray = missionList
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        predicate = NSPredicate(format: "type = 4")
        missionListFetch.predicate = predicate
        do {
            missionList = try getContext().fetch(missionListFetch) as! [Mission]
            self.a_missionArray = missionList
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        self.MissionTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

