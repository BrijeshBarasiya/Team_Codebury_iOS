import UIKit
import Firebase
import FirebaseStorage
class LoginScreen: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.layer.borderWidth = 0.5
        scroller.showsVerticalScrollIndicator = false
        scroller.layer.shadowColor = UIColor.black.cgColor
        scroller.layer.shadowOffset = CGSize(width: 0, height: 0)
        scroller.layer.shadowOpacity = 0.15
        scroller.layer.shadowRadius = 10.0
        let keyboardEvent = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(keyboardEvent)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        UploadImage(image: imageView.image!)
        if(username.text?.isEmpty ?? false || password.text?.isEmpty ?? false) {
            showAlertBox(message: "Please Enter Username and Password")
        } else {
            let data = ["email": "\(username.text)", "Password": "\(password.text)"]
            WebServices.getLogin(data: data, result: { result in
                self.showAlertBox(message: result)
            })
        }
    }
    
    private func showAlertBox(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension LoginScreen  {
    func UploadImage(image: UIImage)
    {
        let storageref = Storage.storage().reference()
        let imagenode = storageref.child("\(UUID().uuidString)")
        // let data = imageView.image!.compress(to: 300)
        imagenode.putData(image.pngData()!)
    }
}
