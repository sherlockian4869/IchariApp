import UIKit

class ThirdViewController: UIViewController {

    var thirdUser: String?
    var thirdNumber: Int?
    
    @IBOutlet weak var FortuneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdNumber = Int.random(in: 1 ... 6)
        FortuneButton.layer.cornerRadius = 10
        print("randomNumber:", thirdNumber!)
    }
    
    @IBAction func FortuneBtnTapped(_ sender: Any) {
        transitionForthView()
    }
    
    private func transitionForthView() {
        let thirdStoryboard = UIStoryboard(name: "ForthView", bundle: nil)
        let forthViewController = thirdStoryboard.instantiateViewController(withIdentifier: "ForthViewController") as? ForthViewController
        forthViewController!.modalPresentationStyle = .fullScreen
        forthViewController!.forthNumber = thirdNumber
        forthViewController!.forthUser = thirdUser
        self.present(forthViewController!, animated: true, completion: nil)
    }
}
