import UIKit

enum Decidor {
    case job
    case department
}
class SignUpScreen: UIViewController, Storyboarded {
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFirtName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userDepartment: UITextField!
    @IBOutlet weak var userJobTitle: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var userDOB: UITextField!
    var navCoordinator: MainScreenCoordinator?
    let manualDatePicker = UIDatePicker()
    let dateFormetter = DateFormatter()
    let picker = UIPickerView()
    let jobTitle = ["Select", "Trainee", "Employee"]
    let department = ["Select", "Mobile", "Java"]
    var decided: Decidor = .job
    var isVerified: Bool = false
    var checkGender = "FEMALE"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.layer.borderWidth = 0.5
        scroller.showsVerticalScrollIndicator = false
        scroller.layer.shadowColor = UIColor.black.cgColor
        scroller.layer.shadowOffset = CGSize(width: 0, height: 0)
        scroller.layer.shadowOpacity = 0.15
        scroller.layer.shadowRadius = 10.0
        dateFormetter.dateFormat = "YYYY/MM/dd"
        picker.dataSource = self
        picker.delegate = self
        let keyboardEvent = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(keyboardEvent)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onMaleClicked(_ sender: UIButton) {
        checkGender = "MALE"
        femaleButton.isSelected = false
        maleButton.isSelected = true
    }
    
    @IBAction func onFemaleCliked(_ sender: UIButton) {
        checkGender = "FEMALE"
        femaleButton.isSelected = true
        maleButton.isSelected = false
    }

    @IBAction func onClickedDob(_ sender: Any) {
        let size = view.frame.size
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.05))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.onClickCancelButton))
        let okButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onClickOkButton))
        toolbar.setItems([cancelButton, okButton], animated: true)
        manualDatePicker.datePickerMode = .date
        manualDatePicker.preferredDatePickerStyle = .wheels
        userDOB.inputView = manualDatePicker
        userDOB.inputAccessoryView = toolbar
    }
    
    // MARK: objec Functions
    @objc func onClickCancelButton() {
        userDOB.resignFirstResponder()
    }
    
    @objc func onClickOkButton() {
        userDOB.resignFirstResponder()
        guard let manualDatePicker = userDOB.inputView as? UIDatePicker else {
            return
        }
        userDOB.text = dateFormetter.string(from: manualDatePicker.date)
    }
    
    @IBAction func onJobTitleClicked(_ sender: Any) {
        decided = .job
        let size = view.frame.size
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.05))
        let okButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onJobOk))
        toolbar.setItems([okButton], animated: true)
        userJobTitle.inputView = picker
        userJobTitle.inputAccessoryView = toolbar
    }
    
    @IBAction func onLeaveVerifyEmail(_ sender: UITextField) {
        guard let email: String = self.userEmail.text else {
            self.showAlertBox(message: "Email id is not converted.")
            return
        }
        let data = ["email": email]
        WebServices.checkEmail(data: data, complition: {code in
            self.showAlertBox(message: "\(code) Error.")
        }, error: { errorMessage, code in
            switch(code) {
            case 200:
                self.showAlertBox(message: "Response Code 200: Email id Already Exist. ")
            default:
                self.isVerified = true
                break
            }
        })
    }
    
    private func showAlertBox(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onJobOk() {
        userJobTitle.resignFirstResponder()
    }
    
    @IBAction func onDepartmentClicked(_ sender: Any) {
        decided = .department
        let size = view.frame.size
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.05))
        let okButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDepOk))
        toolbar.setItems([okButton], animated: true)
        userDepartment.inputView = picker
        userDepartment.inputAccessoryView = toolbar
    }
    
    @objc func onDepOk() {
        userDepartment.resignFirstResponder()
    }
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        if (isVerified) {
            if(!(userPassword.text == userConfirmPassword.text) || (userPassword.text?.isEmpty ?? false)) {
                showAlertBox(message: "Password is not Equal or Less than 8 Character.")
            }
            if(userFirtName.text?.isEmpty ?? false || userLastName.text?.isEmpty ?? false) {
                showAlertBox(message: "Enter Proper Name")
            }
            if (userDepartment.text?.isEmpty ?? false || userDepartment.text == "Select") {
                showAlertBox(message: "Enter Department Name")
            }
            if (userJobTitle.text?.isEmpty ?? false || userJobTitle.text == "Select") {
                showAlertBox(message: "Enter Department Name")
            } else {
                let data  = ["department": "\(userJobTitle.text)",
                             "dob": "\(userDOB.text)",
                             "email": "\(userEmail.text)",
                             "fname": "\(userFirtName.text)",
                             "gender": "\(checkGender)",
                             "image_url": "no-image",
                             "job": "\(userJobTitle.text)",
                             "lname": "\(userLastName.text)",
                             "otp": "true",
                             "password": "\(userPassword.text)"]
                
                WebServices.setSignUp(data: data, result: { result in
                    self.showAlertBox(message: result)
                })
            }
        } else {
            showAlertBox(message: "Email is not Varified.")
        }
    }
    
}

// MARK: extension UIPickerViewDataSource
extension SignUpScreen: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch decided {
        case .job:
            return jobTitle.count
        case .department:
            return department.count
        }
    }
    
}

// MARK: extension UIPickerViewDelegate
extension SignUpScreen: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch decided {
        case .job:
            userJobTitle.text = jobTitle[row]
            break
        case .department:
            userDepartment.text = department[row]
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch decided {
        case .job:
            return jobTitle[row]
        case .department:
            return department[row]
        }
    }
    
}
