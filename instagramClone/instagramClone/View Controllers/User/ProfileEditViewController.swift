
import UIKit
import Photos

class ProfileEditViewController: UIViewController {

    var settingFromLogin = false

    //MARK: TODO - set up views using autolayout, not frames
    //MARK: TODO - edit other fields in this VC
    var image = UIImage() {
        didSet {
            self.imageView.image = image
        }
    }

    var imageURL: URL? = nil

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()

    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .magenta
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()

    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User Name"
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        return textField
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 14)
        button.backgroundColor = .magenta
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        //MARK: TODO - load in user image and fields when coming from profile page
    }

    @objc private func savePressed(){
        guard let userName = userNameTextField.text, let imageURL = imageURL else {
            //MARK: TODO - alert
            return
        }

        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL.absoluteString) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success():
                        self?.handleNavigationAwayFromVC()
                    case .failure(let error):
                        //MARK: TODO - handle

                        //Discussion - if can't update on user object in collection, our firestore object will not match what is in auth. should we:
                        // 1. Re-try the save?
                        // 2. Revert the changes on the auth user?
                        // This reconciliation should all be handled on the server side, but having to handle here, we could run into an infinite loop when re-saving.
                        print(error)
                    }
                }
            case .failure(let error):
                //MARK: TODO - handle
                print(error)
            }
        }
    }

    @objc private func addImagePressed() {
        //MARK: TODO - action sheet with multiple media options
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("Denied photo library permissions")
                default:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }

    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }

    private func handleNavigationAwayFromVC() {
        if settingFromLogin {
            //MARK: TODO - refactor this logic into scene delegate
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {
                    //MARK: TODO - handle could not swap root view controller
                    return
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = MainTabBarViewController()
            }, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func setupViews() {
        setupImageView()
        setupUserNameTextField()
        setupAddImageButton()
        setupSaveButton()
    }

    private func setupImageView() {
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupUserNameTextField() {
        view.addSubview(userNameTextField)

        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.heightAnchor.constraint(equalToConstant: 30),
            userNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
    }

    private func setupAddImageButton() {
        view.addSubview(addImageButton)

        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            addImageButton.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func setupSaveButton() {
        view.addSubview(saveButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
        ])
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            //MARK: TODO - handle couldn't get image :(
            return
        }
        self.image = image

        guard let imageData = image.jpegData(compressionQuality: 1) else {
            //MARK: TODO - gracefully fail out without interrupting UX
            return
        }

        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                self?.imageURL = url
            case .failure(let error):
                //MARK: TODO - defer image not save alert, try again later. maybe make VC "dirty" to allow user to move on in nav stack
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
