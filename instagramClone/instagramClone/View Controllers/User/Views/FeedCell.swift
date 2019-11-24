//
//  FeedCell.swift
//  instagramClone
//
//  Created by Sam Roman on 11/23/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    var feedImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
       }()
    
    var infoView: UIView = {
    let view = UIView()
    view.backgroundColor = .init(white: 0.3, alpha: 0.8)
    return view
    }()
       var nameLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
        label.backgroundColor = .clear
        
           label.textAlignment = .left
           return label
       }()
       
       
       func setImageConstraints() {
           contentView.addSubview(feedImage)
           feedImage.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               feedImage.topAnchor.constraint(equalTo: contentView.topAnchor),
               feedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               feedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               feedImage.widthAnchor.constraint(equalToConstant: feedImage.frame.width),
               feedImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100)])
       }
       func setNameConstraints() {
           infoView.addSubview(nameLabel)
           nameLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
               nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
               nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
               nameLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor)])
       }
    
    func setInfoViewConstraints(){
        contentView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: feedImage.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: feedImage.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: feedImage.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 100)])
    }
       
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setImageConstraints()
        setInfoViewConstraints()
           setNameConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
}
