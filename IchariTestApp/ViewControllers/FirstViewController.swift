import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var StartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButton.layer.cornerRadius = 10
    }
    
    @IBAction func StartBtnTapped(_ sender: Any) {
        let userName = UserDefaults.standard.string(forKey: "userName")
        if userName != nil {
            transitionThirdView()
        } else {
            transitionSecondView()
        }
    }
    
    private func transitionSecondView() {
        let firstStoryboard = UIStoryboard(name: "SecondView", bundle: nil)
        let secondViewController = firstStoryboard.instantiateViewController(withIdentifier: "SecondViewController")
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    private func transitionThirdView() {
        let userName = UserDefaults.standard.string(forKey: "userName")
        let firstStoryboard = UIStoryboard(name: "ThirdView", bundle: nil)
        let thirdViewController = firstStoryboard.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
        thirdViewController.modalPresentationStyle = .fullScreen
        thirdViewController.thirdUser = userName
        self.present(thirdViewController, animated: true, completion: nil)
    }

    
}
