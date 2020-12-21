import UIKit

class SixthViewController: UIViewController {

    @IBOutlet weak var topButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topButton.layer.cornerRadius = 10
    }
    @IBAction func topBtnTapped(_ sender: Any) {
        transitionTopView()
    }
    
    private func transitionTopView() {
        let sixthStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = sixthStoryboard.instantiateViewController(withIdentifier: "FirstViewController")
        firstViewController.modalPresentationStyle = .fullScreen
        self.present(firstViewController, animated: true, completion: nil)
    }
}
