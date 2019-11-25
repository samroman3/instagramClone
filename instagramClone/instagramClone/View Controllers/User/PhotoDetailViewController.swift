//
//  ViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/20/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .init(white: 0.1, alpha: 0.8)
        setUpViews()
        setDateLabel()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    
    //MARK: Properties
    
    var post: Post! {
        didSet {
            view.layoutSubviews()
            DispatchQueue.main.async {
                if let photoUrl = self.post?.photoUrl {
                    self.getSelectedImage(photoUrl: photoUrl)
                }
            }
        }
    }
    
    
    //MARK: Private Methods
    private func getSelectedImage(photoUrl: String){
        FirebaseStorageService.uploadManager.getImage(url: photoUrl) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let firebaseImage):
                self.detailImage.image = firebaseImage
                self.setUserName()
            }
        }
    }
    
    private func setUserName(){
        FirestoreService.manager.getUserFromPost(creatorID: self.post.creatorID) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                self.nameLabel.text = user.userName
                self.setProfileImage(user: user)
            }
        }
    }
    
    private func setProfileImage(user: AppUser) {
        FirebaseStorageService.profileManager.getUserImage(photoUrl: URL(string: user.photoURL!)!) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let image):
                self.profileImage.image = image
            }
        }
    }
    
    private func setDateLabel(){
        if let date = post.dateCreated {
         let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium

            self.dateLabel.text = formatter.string(from: date as Date)
        }
    }
    
    
    
    
    //MARK: UI Elements
    
    lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 0
        return image
    }()
    
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.2, alpha: 0.9)
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = "Posted: mm/dd/yyyy"
        label.textAlignment = .left
        return label
    }()
    
    
    //MARK: Constraint Methods
    func setUpViews(){
        setImageConstraints()
        setInfoViewConstraints()
        setProfileImageConstraints()
        setNameConstraints()
        setDateConstraints()
    }
    
    
    func setImageConstraints() {
        view.addSubview(detailImage)
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailImage.widthAnchor.constraint(equalToConstant: detailImage.frame.width),
            detailImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2)])
    }
    
    func setProfileImageConstraints() {
        infoView.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
            profileImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)])
    }
    
    func setNameConstraints() {
        infoView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    func setDateConstraints() {
        infoView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
    }
    
    
    func setInfoViewConstraints(){
        view.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: detailImage.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: detailImage.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: detailImage.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 100)])
    }
    
}

