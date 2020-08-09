//
//  ViewControllerAlamofire.swift
//  dz12-2
//
//  Created by Mikhail Danilov on 15.07.2020.
//  Copyright © 2020 Mikhail Danilov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

var weather: Results<Weather>!
var realm = try! Realm()

class ViewControllerAlamofire: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var day = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(weather.count)
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellAlamofire") as! TableViewCellAlamofire
        let weatherDayss = weather[indexPath.row]
        cell.labelTempCell.text = weatherDayss.weatherDay
//        let celcia = Double(day[indexPath.row])! - 243
//        cell.labelTempCell.text = String(celcia)
        return cell
    }
    

    @IBOutlet weak var tableViewAlamofere: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = realm.objects(Weather.self)
        tableViewAlamofere.dataSource = self
        tableViewAlamofere.delegate = self
        reload()
        
        let myUrl = "https://samples.openweathermap.org/data/2.5/forecast/daily?id=524901&appid=03ebaded996fcf8211b40937aef352c5"
        Alamofire.request(myUrl, method: .get).responseJSON{ (response) in
            switch response.result{
            case .success:
                print(response.result)
                let myResult = try? JSON(data: response.data!)
                let resultArray = myResult!["list"]
                //print(resultArray)
                
                try! realm.write {
                    realm.deleteAll()
                }
                
//                self.day.removeAll()
                
                for i in resultArray.arrayValue{
                    
                    let day = i["temp"]["day"].stringValue
                    
                    let weatherDays = Weather()
                    weatherDays.weatherDay = day

                    
                    try! realm.write{
                        realm.add(weatherDays)
                    }
//                    self.day.append(day)
                    DispatchQueue.main.async {
                        self.tableViewAlamofere.reloadData()
                    }
                }
                
                break
            case .failure:
                print(response.error!)
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    func reload(){
        tableViewAlamofere.reloadData()
    }
}
class Weather: Object{
    @objc dynamic var weatherDay = ""
}
