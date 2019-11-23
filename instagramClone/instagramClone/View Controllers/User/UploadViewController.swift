//
//  UploadViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController {
    //MARK: - Properties
    var image = UIImage() {
        didSet {
            self.uploadImageView.image = image
        }
    }
    var imageURL: String? = nil
    
    //MARK: - UI Objects
    var uploadLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedTitle = NSMutableAttributedString(string: "new post", attributes: [NSAttributedString.Key.font: UIFont(name: "Billabong", size: 60)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        label.attributedText = attributedTitle
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    var uploadImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noImage")
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .init(white: 0.2, alpha: 0.9)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .init(white: 0.2, alpha: 0.9)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    
    
    //MARK: - Constraints
    private func setUpConstraints() {
        setUploadLabelConstraints()
        setUploadImageConstraints()
        setUploadButtonConstraints()
        setAddButtonConstraints()
    }
    private func setUploadLabelConstraints() {
        view.addSubview(uploadLabel)
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            uploadLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            uploadLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)])
    }
    private func setUploadImageConstraints() {
        view.addSubview(uploadImageView)
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 100),
            uploadImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 300),
            uploadImageView.heightAnchor.constraint(equalToConstant: 300)])
    }
    private func setUploadButtonConstraints() {
        view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            uploadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 70)])
    }
    private func setAddButtonConstraints() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: uploadImageView.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: uploadImageView.trailingAnchor,constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 40)])
    }
    
    //MARK: - Private Methods
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
    
     func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Objc Func
    @objc func addButtonTapped() {
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
    
    @objc func uploadButtonTapped() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        guard let photoUrl = imageURL else {return}
        FirestoreService.manager.createPost(post: Post(photoUrl: photoUrl, creatorID: user.uid)) { (result) in
            switch result {
            case .failure(let error):
                self.makeAlert(with: "Could not make post", and: "Error: \(error)")
            case .success:
                self.makeAlert(with: "Success", and: "Post created")
            }
        }
    }
    
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
        setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
           addButton.layer.cornerRadius = (addButton.frame.size.width) / 2
           addButton.clipsToBounds = true
           addButton.layer.borderWidth = 2.0
           addButton.layer.borderColor = UIColor.white.cgColor
    }

}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            //MARK: TODO - handle couldn't get image :(
//            makeAlert(with: "Error", and: "Couldn't get image")
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            //MARK: TODO - gracefully fail out without interrupting UX
//            makeAlert(with: "Error", and: "could not compress image")
            return
        }
        
        FirebaseStorageService.uploadManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                self?.imageURL = url
                
            case .failure(let error):
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}

