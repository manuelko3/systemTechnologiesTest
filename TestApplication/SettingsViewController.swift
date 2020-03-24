//
//  SettingsViewController.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var selectedTitleLabel: UILabel!
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var allTitleLabel: UILabel!
    @IBOutlet weak var allTableView: UITableView!
    
    var allCurrency: [(String, String)] = []
    var filterCurrency: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTitleLabel.text = "Favorite currencies"
        allTitleLabel.text = "All currencies"
        
        selectedTableView.delegate = self
        selectedTableView.dataSource = self
        
        allTableView.delegate = self
        allTableView.dataSource = self
        
        self.title = "Settings"
        
        self.selectedTableView.register(UINib(nibName:"SettingsCell", bundle:nil),
                                        forCellReuseIdentifier: "SettingsCell")
        self.allTableView.register(UINib(nibName:"SettingsCell", bundle:nil),
                                   forCellReuseIdentifier: "SettingsCell")
        
        if let allCurrencies = UserDefaults.standard.dictionary(forKey: Constants.currenciesListUDKey) as? [String : String] {
            allCurrency = allCurrencies.sorted(by: <)
        }
        if let currencies = UserDefaults.standard.dictionary(forKey: Constants.selectedCurrenciesUDKey) as? [String : String] {
            filterCurrency = currencies.sorted(by: <)
        }
    }
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectedTableView {
            return filterCurrency.count
        } else {
            return allCurrency.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        if tableView == selectedTableView {
            let filteredArray = Array(filterCurrency)
            let object = filteredArray[indexPath.row]
            
            cell.currencyLabel?.text = object.0
            cell.descriptionLabel?.text = object.1
        } else {
            let currenciesArray = Array(allCurrency)
            let object = currenciesArray[indexPath.row]
            cell.currencyLabel?.text = object.0
            cell.descriptionLabel?.text = "\(object.1)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectedTableView {
            if filterCurrency.count > 1 {
                filterCurrency.remove(at: indexPath.row)
                UserDefaults.standard.set(Dictionary(uniqueKeysWithValues: filterCurrency), forKey: Constants.selectedCurrenciesUDKey)
                self.selectedTableView.reloadData()
            }
        } else {
            if filterCurrency.count < 5 {
                let newCurrency = allCurrency[indexPath.row]
                if filterCurrency.contains(where: { $0.0 == newCurrency.0 && $0.1 == newCurrency.1 }) {
                    return
                }
                filterCurrency.append(allCurrency[indexPath.row])
                
                UserDefaults.standard.set(Dictionary(uniqueKeysWithValues: filterCurrency), forKey: Constants.selectedCurrenciesUDKey)
                self.selectedTableView.reloadData()
            }
        }
    }
    
    @IBAction func sortDidTap(_ sender: Any) {
        filterCurrency = filterCurrency.sorted(by: <)
        selectedTableView.reloadData()
    }
    
}
