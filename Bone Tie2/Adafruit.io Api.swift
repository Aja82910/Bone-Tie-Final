
import UIKit
import Foundation
import CloudKit

var latlon: String = ""
var longitude: Double = 0.0
var latitude: Double = 0.0
var BatPercent: String = ""
var Rssi: String = ""
var CCID: String = ""
var Fix: String = ""
var Request: String = ""
var LedDatas: String = ""
var TimeUpdated: String = ""
var lost: String = ""
var isLost: String = ""
let forecastAPIKeys = "9d0e1ff721b54cc7831ed43660a1cc65"
let key = "fz5Uz8s" // Test Key
let container = CKContainer.default()
var publicDatabase = container.publicCloudDatabase
var currentRecord: CKRecord?

class Api: NSObject {
    var titles = [String]()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    // TODO: Enter your API key here
    private let forecastAPIKey = "9d0e1ff721b54cc7831ed43660a1cc65"
    
        // Do any additional setup after loading the view, typically from a nib.
    func beginApi() {
        retrieveWeatherForecast()
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(Api.retrieveWeatherForecast), userInfo: nil, repeats: true)

    }
    func updateLocationLost() -> Bool {
        for dogs in MyLostDogs {
            let Latitude: CLLocationDegrees = latitude
            let Longitude: CLLocationDegrees = longitude
            let LocationPredicate = NSPredicate(format: "Location = %@", CLLocation(latitude: Latitude, longitude: Longitude))
            let NamePredicate = NSPredicate(format: "Name = %@", dogs.name)
            let PhotoPredicate = NSPredicate(format: "Photo = %@", dogs.photo!)
            let predicate: NSPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [LocationPredicate, NamePredicate, PhotoPredicate])
            let query = CKQuery(recordType: "Lost", predicate: predicate)
            let operation = CKQueryOperation(query: query)
            operation.resultsLimit = 1
            operation.queuePriority = .veryHigh
            let returns  = retrieveWeatherForecast()
            operation.recordFetchedBlock = { (record: CKRecord) -> Void in
                record.setObject(CLLocation(latitude: Latitude, longitude:  Longitude), forKey: "Location")
                publicDatabase.save(record, completionHandler:
                    ({returnRecord, error in
                        if let err = error {
                            DispatchQueue.main.async {
                                //self.notifyUser("Save Error", message: err.localizedDescription)
                                print(err.localizedDescription)
                            }
                        } else {
                            DispatchQueue.main.async {
                                //self.notifyUser("Success!", message: "Record saved successfully.")
                                print("Record Saved")
                            }
                            print("suceess")
                        }
                    }))
                }
            publicDatabase.add(operation)
            return returns
        }
        return retrieveWeatherForecast()
    }
    
    func retrieveWeatherForecast() ->  Bool {
        
        let blogsURL: URL = URL(string: "https://io.adafruit.com/api/groups/fona/receive.json?x-aio-key=\(forecastAPIKey)")!
        let NSdata = try? Data(contentsOf: blogsURL)
        var Return = false
        var names = [String]()
        var values = [String]()
        if lost == "Yes" {
            
        }
        // dispatch_async(dispatch_get_main_queue()) {
        if let data = NSdata {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
                if let blogs = json["feeds"] as? [[String: AnyObject]] {
                    var x = 0
                    for blog in blogs {
                        if let name = blog["key"] as? String {
                            names.append(name)
                            if let stream = blog["stream"] {
                                if let value = stream["value"] as? String {
                                    values.append(name)
                                    values.append(value)
                                    if name == "ccid" {
                                        CCID = value
                                    }
                                    if name == "batpercent" {
                                        BatPercent = value
                                    }
                                    if name == "rssi" {
                                        Rssi = value
                                    }
                                    if name == "request" {
                                        Request = value
                                        if value == "No" {
                                            Return = true
                                        }
                                    }
                                    if name == "lost" {
                                        isLost = value
                                    }
                                    if name == "fix" {
                                        Fix = value
                                        if let time = stream["updated_at"] {
                                            if String(describing: time) != TimeUpdated {
                                                Return = true
                                            }
                                            TimeUpdated = String(describing: time)
                                        }

                                    }
                                    
                                }
                                if name == "location" {
                                    values.append("in")
                                    if let lat: AnyObject = stream["lat"] {
                                        x = 1
                                        if lat.doubleValue != latitude {
                                            Return = true
                                        }
                                        latlon = String(describing: lat)
                                        latitude = lat.doubleValue
                                        values.append("loction latitude")
                                        values.append("\(lat)")
                                    }
                                    if let lon: AnyObject = stream["lon"] {
                                        if lon.doubleValue != longitude {
                                            Return = true
                                        }
                                        if x == 1 {
                                            x = 0
                                            latlon += String(describing: lon)
                                        }
                                        longitude = lon.doubleValue
                                        values.append("loction longitude")
                                        values.append("\(lon)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("error serializing JSON: \(error)")
            }
        }
        // }
            return Return
        
    }
    func lostReload() -> Bool{
        let Return = retrieveWeatherForecast()
        let Lost = LostViewController()
        if Return == true {
            Lost.RefreshStop()
        }
        return Return
    }
    func mapReload() -> Bool{
        let Return = retrieveWeatherForecast()
        let Map = MapViewController()
        if Return == true {
            Map.RefreshStop()
        }
        return Return
    }
    func requestDatafromDog(_ Requesting: Bool) -> Bool {
        let url: URL
        LedDatas = LedDatas.trimmingCharacters(in: CharacterSet(charactersIn: "[\"\\]"))
        let LedData: [String] = LedDatas.components(separatedBy: "")
        if LedDatas != "" && Requesting == true {
            LedDatas = String(describing: LedData)
            //let baseUrl = "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&Request=Yes&LedData=\(String(LedData))"
            LedDatas = LedDatas.trimmingCharacters(in: CharacterSet(charactersIn: "[\"\\]"))
            let urlName : NSString = "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&Request=Yes&LedData=\(LedDatas)" as NSString
            let urlStr = urlName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            url = URL(string: urlStr! as String)!
        }
        else if LedDatas != "" {
            LedDatas = String(describing: LedData)
            //let baseUrl = "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&LedData=\(LedDatas)
            LedDatas = LedDatas.trimmingCharacters(in: CharacterSet(charactersIn: "[\"\\]"))
            let urlName : NSString = "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&LedData=\(LedDatas)" as NSString
            let urlStr = urlName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed
            )
            url = URL(string: urlStr! as String)!
        }
        else {
            url = URL(string: "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&Request=Yes")!
        }
        if Requesting {
        let data = try? Data(contentsOf: url)
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                if let blogs = json["feeds"] as? [[String: AnyObject]] {
                    for blog in blogs {
                        if let name = blog["key"] as? String {
                            if let stream = blog["stream"] {
                                if let value = stream["value"] as? String {
                                    if name == "request" {
                                        Request = value
                                        if value == "Yes" {
                                            return true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("error serializing JSON: \(error)")
            }
        }
        }
        if LedDatas != "" {
            let data = try? Data(contentsOf: url)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    if let blogs = json["feeds"] as? [[String: AnyObject]] {
                        for blog in blogs {
                            if let name = blog["key"] as? String {
                                if let stream = blog["stream"] {
                                    if let value = stream["value"] as? String {
                                        if name == "leddata" {
                                            LedDatas = value
                                            if value == LedDatas {
                                                return true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch {
                    print("error serializing JSON: \(error)")
                }
            }
   
        }
        return false
    }
    func LostMode() -> Bool{
        let url: URL
        url = URL(string: "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&Lost=Yes")!
        let data = try? Data(contentsOf: url)
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                if let blogs = json["feeds"] as? [[String: AnyObject]] {
                    for blog in blogs {
                        if let name = blog["key"] as? String {
                            if let stream = blog["stream"] {
                                if let value = stream["value"] as? String {
                                    if name == "lost" {
                                        isLost = value
                                        if value == "Yes" {
                                            return true
                                        }
                                        else {
                                            return false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("error serializing JSON: \(error)")
            }
        }
        return false
    }
    func Found() -> Bool{
        let url: URL
        url = URL(string: "https://io.adafruit.com/api/groups/fona/send.json?x-aio-key=\(forecastAPIKey)&Lost=No")!
        let data = try? Data(contentsOf: url)
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                if let blogs = json["feeds"] as? [[String: AnyObject]] {
                    for blog in blogs {
                        if let name = blog["key"] as? String {
                            if let stream = blog["stream"] {
                                if let value = stream["value"] as? String {
                                    if name == "lost" {
                                        isLost = value
                                        if value == "No" {
                                            return true
                                        }
                                        else {
                                            return false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("error serializing JSON: \(error)")
            }
        }
        return false
    }

}


