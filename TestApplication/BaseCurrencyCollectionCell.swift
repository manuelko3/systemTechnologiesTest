//
//  BaseCurrencyCollectionCell.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import UIKit

class BaseCurrencyCollectionCell: UICollectionViewCell {

    @IBOutlet weak var baseCurrencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0;
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .lightGray : .clear
        }
    }

}
