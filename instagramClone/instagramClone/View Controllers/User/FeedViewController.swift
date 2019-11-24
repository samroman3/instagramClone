//
//  FeedViewController.swift
//  instagramClone
//
//  Created by Sam Roman on 11/22/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
     //MARK: - Properties
        var posts = [Post]() {
            didSet {
                self.feedCollectionView.reloadData()
            }
        }
        
        //MARK: - UI Object
        var myFeedLabel: UILabel = {
            let label = UILabel()
            let attributedTitle = NSMutableAttributedString(string: "My Feed", attributes: [NSAttributedString.Key.font: UIFont(name: "Billabong", size: 40)!, NSAttributedString.Key.foregroundColor: UIColor.white])
            label.attributedText = attributedTitle
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = .clear
            return label
        }()
        var feedCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collection.backgroundColor = .init(white: 0.1, alpha: 1)
            collection.register(FeedCell.self, forCellWithReuseIdentifier: "feedCell")
            return collection
        }()
        
        //MARK: - Constraints
        private func setUpConstraints() {
            setFeedLabelConstraints()
            setCollectionViewConstraints()
            feedCollectionView.delegate = self
            feedCollectionView.dataSource = self
            
        }
        private func setFeedLabelConstraints() {
            view.addSubview(myFeedLabel)
            myFeedLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myFeedLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                myFeedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                myFeedLabel.heightAnchor.constraint(equalToConstant: 50),
                myFeedLabel.widthAnchor.constraint(equalTo: view.widthAnchor)])
        }
        private func setCollectionViewConstraints() {
            view.addSubview(feedCollectionView)
            feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                feedCollectionView.topAnchor.constraint(equalTo: myFeedLabel.bottomAnchor, constant: 40),
                feedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                feedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                feedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        }
        //MARK: - Private Functions
        private func getAllPosts() {
            FirestoreService.manager.getAllPosts(sortingCriteria: nil) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let postsFromFirebase):
                    DispatchQueue.main.async {
                        self.posts = postsFromFirebase
                    }
                }
            }
        }

        //MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .init(white: 0.1, alpha: 0.8)
            setUpConstraints()
            getAllPosts()

        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getAllPosts()
        }
    }

    //MARK: CollectionViewDelegates
    extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            posts.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
                return UICollectionViewCell()
            }
            let post = posts[indexPath.row]
            DispatchQueue.main.async {
                if let photoUrl = post.photoUrl {
                    FirebaseStorageService.uploadManager.getImage(url: photoUrl) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let firebaseImage):
                            cell.feedImage.image = firebaseImage
                        }
                    }
                    FirestoreService.manager.getUserNameFromPost(creatorID: post.creatorID) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let displayName):
                            cell.nameLabel.text = displayName
                        }
                    }
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width - 10, height: 500)
               
           }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let selectedPost = posts[indexPath.row]
//            let detailVC = ImageDetailVC()
//            detailVC.post = selectedPost
//            present(detailVC, animated: true, completion: nil)
        }
        
    }

