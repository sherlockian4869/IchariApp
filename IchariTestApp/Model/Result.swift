import Foundation

class Result {
    
    let fotune: String
    let comment: String
    let talk: String
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.fotune = dic["fotune"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
        self.talk = dic["talk"] as? String ?? ""
    }
    
}

