//
//  BannerTableViewCell.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation
import UIKit
import SnapKit

class BannerTableViewCell: UITableViewCell {
    
    static let identifier = "BannerTableViewCell"
    
    //MARK: - UI
    let bannerImagerView:UIImageView = {
        let bannerImagerView = UIImageView()
        bannerImagerView.backgroundColor = .black
        bannerImagerView.image = UIImage(systemName: "")
        bannerImagerView.translatesAutoresizingMaskIntoConstraints = false
        return bannerImagerView
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TypeBannerSutupUI(){
        self.addSubview(bannerImagerView)
        
        bannerImagerView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
}
