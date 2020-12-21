import Foundation

class Result {
    
    let fortune: String
    let comment: String
    let talk: String
    
    var uid: String?
    
    init(dic: [String: Any]) {
        self.fortune = dic["fortune"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
        self.talk = dic["talk"] as? String ?? ""
    }
    
}

