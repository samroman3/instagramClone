//
//  ProfileViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        setUpView()
        getUserPosts()
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        getPostCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPostCount()
        setUserName()
    }
    
    
    //MARK: Properties
    
    var posts = [Post]() {
        didSet {
            self.postCollectionView.reloadData()
        }
    }
    
    
    
    var user: AppUser!
    var isCurrentUser = false
    
    
    
    var image = UIImage() {
        didSet {
            self.profileImage.image = image
        }
    }
    var imageURL: String? = nil
    var postCount = 0 {
        didSet {
            totalPost.text = "\(postCount) \n Posts"
        }
    }
    
    //MARK: Private Methods
    private func setUserName() {
        if let displayName = FirebaseAuthService.manager.currentUser?.displayName {
            userName.text = displayName
        }
    }
    private func setProfileImage() {
        if let pictureUrl = FirebaseAuthService.manager.currentUser?.photoURL {
            FirebaseStorageService.profileManager.getUserImage(photoUrl: pictureUrl) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.profileImage.image = image
                }
            }
        }
    }
    
    private func getPostCount() {
        if let userUID = FirebaseAuthService.manager.currentUser?.uid {
            DispatchQueue.global(qos: .default).async {
                FirestoreService.manager.getPosts(forUserID: userUID) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let posts):
                        if posts.count > self.postCount {
                            self.getUserPosts()
                        }
                        self.postCount = posts.count
                        
                    }
                }
            }
        }
    }
    
    private func getUserPosts() {
        if let userUID =  FirebaseAuthService.manager.currentUser?.uid {
            FirestoreService.manager.getPosts(forUserID: userUID, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let postsFromFirebase):
                DispatchQueue.main.async {
                    self.posts = postsFromFirebase
                }
            }
        }
        )}
    }
    
    //MARK: UI Elements
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    lazy var totalPost: UILabel = {
        let label = UILabel()
        label.text = "0 \n Posts"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \n Followers"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \n Following"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .init(white: 0.4, alpha: 0.8)
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()
    
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PostCell.self, forCellWithReuseIdentifier: "posts")
        cv.backgroundColor = .init(white: 0.2, alpha: 0.9)
        return cv
    }()
    
    @objc private func editAction(){
        let editVC = ProfileEditViewController()
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: Constraint Methods
    
    private func setUpView(){
        constrainProfileImage()
        constrainStats()
        constrainUserName()
        constrainEditButton()
        constrainCollectionView()
        setUserName()
        setProfileImage()
    }
    
    
    private func constrainProfileImage(){
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    
    private func constrainStats(){
        let stackView = UIStackView(arrangedSubviews: [totalPost, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 3),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalToConstant: 245)
        ])
        
    }
    
    
    
    
    
    
    private func constrainUserName(){
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 0),
            userName.heightAnchor.constraint(equalToConstant: 30),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            userName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    private func constrainEditButton(){
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 0),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    private func constrainCollectionView(){
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postCollectionView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    
}

//MARK: CollectionView Extension

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as! PostCell
        cell.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
        let post = posts[indexPath.row]
               DispatchQueue.main.async {
                   if let photoUrl = post.photoUrl {
                       FirebaseStorageService.uploadManager.getImage(url: photoUrl) { (result) in
                           switch result {
                           case .failure(let error):
                               print(error)
                           case .success(let firebaseImage):
                            cell.postImage.image = firebaseImage
                           }
                       }
    }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 138)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
}
