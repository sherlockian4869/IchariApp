import UIKit
import FirebaseFirestore

class FifthViewController: UIViewController {

    var fifthUser: String?
    var fifthNumber: Int?
    
    @IBOutlet weak var ChatTableView: UITableView!
    private let cellId = "cellId"
    private let tableViewContentInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    private let tableViewIndicatorInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    private let accessoryHeight: CGFloat = 100
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    }
    private var messages = [Message]()
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: accessoryHeight)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupChatTableView()
        fetchMessages()

    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupChatTableView() {
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        ChatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        ChatTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180 )
        ChatTableView.contentInset = tableViewContentInset
        ChatTableView.scrollIndicatorInsets = tableViewIndicatorInset
        ChatTableView.keyboardDismissMode = .interactive
        ChatTableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        guard let userInfo = notification.userInfo else { return }
        
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            if keyboardFrame.height <= accessoryHeight { return }
            print("keyboardFrame:", keyboardFrame)
            
            let top = keyboardFrame.height - safeAreaBottom
            var moveY = -(top - ChatTableView.contentOffset.y)
            if ChatTableView.contentOffset.y == -60 { moveY += 60 }
            print("chatRoomTableView.contentOffset.y:", ChatTableView.contentOffset.y)
            let contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
            
            ChatTableView.contentInset = contentInset
            ChatTableView.scrollIndicatorInsets = contentInset
            ChatTableView.contentOffset = CGPoint(x: 0, y: moveY)
        }
    }
    
    @objc func keyboardWillHide() {
        print("keyboardWillHide")
        ChatTableView.contentInset = tableViewContentInset
        ChatTableView.scrollIndicatorInsets = tableViewIndicatorInset
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchMessages() {
        Firestore.firestore().collection("MessageRoom").addSnapshotListener { (snapshots, err) in
            
            if err != nil {
                print("メッセージ情報の取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let message = Message.init(dic: dic)
                    
                    self.messages.append(message)
                    self.messages.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    
                    self.ChatTableView.reloadData()
                    
                case .modified, .removed:
                    print("Nothing To Do")
                }
            })
        }
    }

}

extension FifthViewController: ChatInputAccessoryViewDelegate {
    
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)
    }
    
    private func addMessageToFirestore(text: String) {
        chatInputAccessoryView.removeText()
        let docData = [
            "name": fifthUser!,
            "createdAt": Timestamp(),
            "message": text
            ] as [String : Any]
        
        Firestore.firestore().collection("MessageRoom").addDocument(data: docData) { (err) in
            
            if err != nil {
                print("メッセージ情報の保存に失敗しました")
                return
            }
            
            let dialog = UIAlertController(title: "Have a nice day!!", message: "占い画面に戻りますか？", preferredStyle: .actionSheet)
            
            dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let fifthStroyboard = UIStoryboard(name: "SixthView", bundle: nil)
                let sixthViewController = fifthStroyboard.instantiateViewController(withIdentifier: "SixthViewController")
                sixthViewController.modalPresentationStyle = .fullScreen
                self.present(sixthViewController, animated: true, completion: nil)
            }))
            
        }
    }
}

extension FifthViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ChatTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatTableViewCell
        cell.user = messages[indexPath.row]
        cell.message = messages[indexPath.row]
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        return cell
    }    
}
