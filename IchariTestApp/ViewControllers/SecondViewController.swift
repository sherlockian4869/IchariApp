import UIKit
import FirebaseFirestore

class SecondViewController: UIViewController {
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var NameRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameRegisterButton.layer.cornerRadius = 10
        NameTextField.delegate = self
        NameRegisterButton.isEnabled = false
        NameRegisterButton.backgroundColor = .rgb(red: 224, green: 224, blue: 224)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func NameRegisterBtnTapped(_ sender: Any) {
        let userName = NameTextField.text
        UserDefaults.standard.set(userName, forKey: "userName")
        transitionThirdView()
        registerUserFromFireStore()
    }
    
    private func transitionThirdView() {
        let secondStoryboard = UIStoryboard(name: "ThirdView", bundle: nil)
        let thirdViewController = secondStoryboard.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController
        thirdViewController!.modalPresentationStyle = .fullScreen
        thirdViewController!.thirdUser = NameTextField.text!
        self.present(thirdViewController!, animated: true, completion: nil)
    }
    
    private func registerUserFromFireStore() {
        guard let username = NameTextField.text else { return }
        Firestore.firestore().collection("User").addDocument(data: ["User":username])
    }
}

extension SecondViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let NameIsEmpty = NameTextField.text?.isEmpty ?? false
        
        if NameIsEmpty {
            NameRegisterButton.isEnabled = false
            NameRegisterButton.backgroundColor = .rgb(red: 224, green: 224, blue: 224)
        } else {
            NameRegisterButton.isEnabled = true
            NameRegisterButton.backgroundColor = .white
        }
    }
}
