//
//  InformationTableViewCell.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation
import UIKit
import SnapKit

class InformationTableViewCell: UITableViewCell {
    
    static let identifier = "InformationTableViewCell"
    
    //MARK: - UI
    let TotalCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel, positionLabel, expertiseLabel
        ])
        stackView.spacing = 2
        stackView.backgroundColor = .black
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageStackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatarImageView:UIImageView = {
        let avatarImageView = UIImageView()
//        avatarImageView.frame.size.width = 130
//        avatarImageView.frame.size.height = 130
        avatarImageView.backgroundColor = .black
        avatarImageView.image = UIImage(systemName: "")
        avatarImageView.translatesAutoresizingMaskIntoConstraints   = false
        avatarImageView.contentMode = .scaleAspectFit

        print("image")
        return avatarImageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = "_"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let positionLabel:UILabel = {
        let label = UILabel()
        label.text = "_"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let expertiseLabel:UILabel = {
        let label = UILabel()
        label.text = "_"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TypeEmployeeSutupUI(){
        
        self.backgroundColor = .black
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.top)
            make.left.equalTo(labelStackView.snp.left).offset(10)
            make.right.equalTo(labelStackView.snp.right)
            make.height.equalTo(50)
        }

        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(labelStackView.snp.left).offset(10)
            make.right.equalTo(labelStackView.snp.right)
            make.height.equalTo(50)
        }

        expertiseLabel.snp.makeConstraints { make in
            make.top.equalTo(positionLabel.snp.bottom)
            make.left.equalTo(labelStackView.snp.left).offset(10)
            make.right.equalTo(labelStackView.snp.right)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(TotalCellView)
        TotalCellView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(10)
            make.bottom.right.equalTo(contentView).offset(-10)
        }
        
        
        TotalCellView.addSubview(labelStackView)
        TotalCellView.addSubview(imageStackView)
        
        imageStackView.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(TotalCellView)
            make.width.equalTo(TotalCellView.snp.height)
        }

        labelStackView.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(TotalCellView)
            make.left.equalTo(imageStackView.snp.right).offset(10)
        }
        
        imageStackView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalTo(imageStackView)
        }
        
    }
    
}
