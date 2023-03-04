//
//  CitySearchTableViewCell.swift
//  CitySearch
//
//  Created by Willy on 28/02/2023.
//

import UIKit
import SnapKit

struct CitySearchTableViewCellConstants {
    static let inset = 16
    static let offset = 8
    static let titleFontSize: CGFloat = 17
    static let subTitleFontSize: CGFloat = 14
}

class CitySearchTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add title label to cell content view
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(CitySearchTableViewCellConstants.inset)
        }
        
        // Add subtitle label to cell content view
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CitySearchTableViewCellConstants.offset)
            make.left.right.bottom.equalToSuperview().inset(CitySearchTableViewCellConstants.inset)
        }
        
        // Configure title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: CitySearchTableViewCellConstants.titleFontSize)
        titleLabel.textColor = .black
        
        // Configure subtitle label
        subtitleLabel.font = UIFont.systemFont(ofSize: CitySearchTableViewCellConstants.subTitleFontSize)
        subtitleLabel.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CitySearchItemViewModel) {
        titleLabel.text = viewModel.cityAndCountry
        subtitleLabel.text = viewModel.latAndlong
    }

}
