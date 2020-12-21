import UIKit
import FirebaseFirestore

class ForthViewController: UIViewController {

    var forthUser: String?
    var forthNumber: Int?
    
    @IBOutlet weak var FortuneLabel: UILabel!
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var LuckyTalkLabel: UILabel!
    @IBOutlet weak var PostButton: UIButton!
    
    private var result: Result? {
        didSet {
            FortuneLabel.text = result?.fortune
            MessageLabel.text = result?.comment
            LuckyTalkLabel.text = result?.talk
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PostButton.layer.cornerRadius = 10
        print("randomNumber:", forthNumber!)
        fetchFotunes()
    }
    
    private func fetchFotunes() {
        guard let fortuneId = forthNumber else { return }
        Firestore.firestore().collection("result").document("\(fortuneId)").getDocument { (snapshots, err) in
            if err != nil {
                print("運勢の情報取得に失敗しました")
                let dialog = UIAlertController(title: "運勢の情報取得に失敗しました", message: "前の画面に戻りますか？", preferredStyle: .actionSheet)
                
                dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(dialog, animated: true, completion: nil)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    let storyboard = UIStoryboard(name: "ThirdView", bundle: nil)
                    let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ThirdViewController")
                    thirdViewController.modalPresentationStyle = .fullScreen
                    self.present(thirdViewController, animated: true, completion: nil)
                }))

                return
            }
            guard let snapshot = snapshots, let dic = snapshot.data() else { return }
            let result = Result(dic: dic)
            self.result = result
        }
    }
    
    @IBAction func PostBtnTapped(_ sender: Any) {
        transitionFifthView()
    }
    
    private func transitionFifthView() {
        let forthStoryboard = UIStoryboard(name: "FifthView", bundle: nil)
        let fifthViewController = forthStoryboard.instantiateViewController(withIdentifier: "FifthViewController") as? FifthViewController
        fifthViewController!.modalPresentationStyle = .fullScreen
        fifthViewController!.fifthNumber = forthNumber
        fifthViewController!.fifthUser = forthUser
        self.present(fifthViewController!, animated: true, completion: nil)
    }
}
