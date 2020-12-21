import Foundation
import FirebaseFirestore

class Message {

    let name: String
    let message: String
    let createdAt: Timestamp
        
    init(dic: [String: Any]) {
        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
