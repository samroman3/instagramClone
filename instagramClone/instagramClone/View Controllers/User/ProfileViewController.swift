//
//  ProfileViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: AppUser!
    var isCurrentUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        setUpView()
      
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
  
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
//        image.image = UIImage(contentsOfFile: (user?.photoURL!)!) ?? UIImage(systemName: "person")
        
        return image
    }()
    lazy var userName: UILabel = {
        let label = UILabel()
//        label.text = user.userName ?? "User not found"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    lazy var totalPost: UILabel = {
        let label = UILabel()
        label.text = "0 \n Posts"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \n Followers"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \n Following"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()
  
    lazy var postCollectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .vertical
          let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
          cv.register(PostCell.self, forCellWithReuseIdentifier: "posts")
          cv.backgroundColor = UIColor.systemGray4
          return cv
      }()
    
    @objc private func editAction(){
        let editVC = ProfileEditViewController()
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: true, completion: nil)
    }
    private func setUpView(){
        constrainProfileImage()
        constrainStats()
        constrainUserName()
        constrainEditButton()
        constrainCollectionView()
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
            postCollectionView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 60),
            postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
      ])
    }
    

}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as? PostCell
        cell?.backgroundColor = .white
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 138)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
   
    
}
