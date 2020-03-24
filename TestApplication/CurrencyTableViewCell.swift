//
//  CurrencyTableViewCell.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? .gray : .white
    }

}
