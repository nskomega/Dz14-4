
import UIKit

struct Lists: Codable{
    let list: [List]
}

struct List: Codable{
    var temp: Temp
    
    struct Temp: Codable {
        var day: Double
    }
}
