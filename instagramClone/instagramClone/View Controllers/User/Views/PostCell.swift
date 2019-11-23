//
//  PostCellCollectionViewCell.swift
//  instagramClone
//
//  Created by Sam Roman on 11/23/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
     
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        lazy var postImage: UIImageView = {
            let image = UIImageView()
            return image
        }()
        private func constrainImageView(){
            contentView.addSubview(postImage)
            postImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                postImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                postImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                postImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
                postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
        }
    }
