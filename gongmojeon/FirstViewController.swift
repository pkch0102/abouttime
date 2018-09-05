//
//  FirstViewController.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 6. 25..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    @IBOutlet weak var wAchievement: UILabel!
    @IBOutlet weak var dAchievement: UILabel!
    @IBOutlet weak var mAchievement: UILabel!
    @IBOutlet weak var aAchievement: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    var d_missionArray:[Mission] = []
    var w_missionArray:[Mission] = []
    var m_missionArray:[Mission] = []
    var a_missionArray:[Mission] = []
    var completeMissionArray:[CompleteMission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "is_first") {
            //
           
            if let arr : [Dictionary<String ,Any>] =  self.readJson() as! [Dictionary<String, Any>] {
                var cnt : Int = 0;
                
                for var dict in arr{
                    dict["idx"] = cnt
                    cnt += 1
                    self.saveData(dict: dict)
                }
            }
            
            
            
            defaults.set(true, forKey:"is_first")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getCompleteMissionList()
        self.getMissionList()
        
        
        var resTime : Int = 0
        for time in completeMissionArray {
            if ((time.relationship?.costtime) != nil) {
                resTime += Int(time.relationship?.costtime as! Int32)
            }else{
                
            }
        }
        
        let day : Int = resTime/24/60
        resTime -= day*24*60
        let hour : Int = resTime/60
        resTime -= hour*60
        let min = resTime
        self.setTimer(day: day, hour: hour, min: min)
        
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: Date())

        
        var dDict : [Int : Int] = [ : ]
        var wDict : [Int : Int] = [ : ]
        var mDict : [Int : Int] = [ : ]
        var aDict : [Int : Int] = [ : ]
        var cIdx : Int = 0;
        
        for cM in completeMissionArray{
            if(cM.relationship?.type == 1){
                if cM.date as! Date > yesterday!{
                    cIdx = Int(cM.missionidx as! Int32)
                    dDict[cIdx] = 1
                }
            }else if(cM.relationship?.type == 2){
                if cM.date! as Date > lastWeek!{
                    cIdx = Int(cM.missionidx as! Int32)
                    wDict[cIdx] = 1
                }
            }else if(cM.relationship?.type == 3){
                if cM.date! as Date > lastMonth!{
                    cIdx = Int(cM.missionidx as! Int32)
                    mDict[cIdx] = 1
                }
            }else if(cM.relationship?.type == 4){
                if cM.date! as Date > lastYear!{
                    cIdx = Int(cM.missionidx as! Int32)
                    aDict[cIdx] = 1
                }
            }
        }
        
        var dAchievement : String = String(Int(Double(dDict.count) / Double(self.d_missionArray.count)  * 100)) + "%"
        var wAchievement : String = String(Int(Double(wDict.count) / Double(self.w_missionArray.count)  * 100)) + "%"
        var mAchievement : String = String(Int(Double(mDict.count) / Double(self.m_missionArray.count)  * 100)) + "%"
        var aAchievement : String = String(Int(Double(aDict.count) / Double(self.a_missionArray.count)  * 100)) + "%"
        
        self.dAchievement.text = dAchievement
        self.wAchievement.text = wAchievement
        self.mAchievement.text = mAchievement
        self.aAchievement.text = aAchievement
    }

    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveData(dict : Dictionary<String, Any>) {
        let context = self.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Mission", in: context)
        let mission: Mission = NSManagedObject(entity: entityDescription!, insertInto: context) as! Mission
        /*
        dict2["title"] = "운동하기"
        dict2["descript"] = "가족과 함께 운동하기"
        dict2["date"] = NSDate()
        dict2["cost"] = 0
        dict2["type"] = 0
         1 : 일간
         2 : 주간
         3 : 월간
         4 : 연간
        */
        
        let title : String = dict["title"] as! String
        
        if (!title.isEmpty) {
            mission.title = title
        }
        
        let idx: Int = dict["idx"] as! Int
        if (idx != nil){
            mission.idx = Int32(idx)
        }
        
        let descript : String = (dict["descript"] as? String)!
        if(!descript.isEmpty){
        mission.descript = descript
        }
        
        let type : Int = dict["type"] as! Int
        if (type != nil){
            mission.type = Int32(type)
        }
        
        let cost : Int = dict["cost"] as! Int
        if (cost != nil){
            mission.costtime = Int32(cost)
        }
        
        do {
            try context.save()
            
        }catch let error as NSError {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setData(){
        var dict: Dictionary <String, Any> = Dictionary();
        dict["cost"] = 0
        
        self.saveData(dict: dict)
        
        
    }

    private func readJson() -> Array<Any>{
        do {
            if let file = Bundle.main.url(forResource: "data", withExtension: "json", subdirectory: "Resource") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                } else if let object = json as? [Any] {
                    // json is an array
                    return object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return []
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
    }
    
    func getCompleteMissionList() {
        let completeMissionListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CompleteMission")
        do{
            self.completeMissionArray = try getContext().fetch(completeMissionListFetch) as! [CompleteMission]
        }
        catch{
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func setTimer(day : Int, hour : Int , min : Int){
        var dayStr : String = ""
        var hourStr : String  = ""
        var minStr : String = ""
        
        if day < 10 {
            dayStr = "0" + String(day)
        }else{
            dayStr = String(day)
        }
        if hour < 10{
            hourStr = "0" + String(hour)
        }else{
            hourStr = String(hour)
        }
        if min < 10{
            minStr = "0" + String(min)
        }else{
            minStr = String(min)
        }
        
        var myString = dayStr + "일" + " " + hourStr + "시" + " " + minStr + "분"
        
        var myMutableString = NSMutableAttributedString(string: myString as String, attributes:[NSFontAttributeName: UIFont(name:self.timelabel.font.fontName, size: 60.0)!])
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name:self.timelabel.font.fontName,size: 18.0)!,range: NSRange(location: 2,length: 1))
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name:self.timelabel.font.fontName,size: 18.0)!,range: NSRange(location: 6,length: 1))
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name:self.timelabel.font.fontName,size: 18.0)!,range: NSRange(location: 10,length: 1))
        
        self.timelabel.attributedText = myMutableString
    }
}

