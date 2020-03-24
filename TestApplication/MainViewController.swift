//
//  ViewController.swift
//  TestApplication
//
//  Created by Eugene on 19.03.2020.
//  Copyright © 2020 Eugene Polupanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var baseCurrencyCollectionView: UICollectionView!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currencies: Currencies?
    
    var baseCurrency = ["USD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
        baseCurrencyCollectionView.delegate = self
        baseCurrencyCollectionView.dataSource = self
        
        self.title = "Currency Rates"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let currencies = UserDefaults.standard.dictionary(forKey: Constants.selectedCurrenciesUDKey) as? [String : String] {
            baseCurrency = Array(currencies.keys)
        }
        
        baseCurrencyCollectionView.reloadData()
        getCurrencies(base: baseCurrency[0])
    }
    
    func getCurrencies(base: String) {
        Network.getCurrencyRates(baseCurrency: base, completion: { [weak self] in
            self?.currencies = $0
            DispatchQueue.main.async {
                self?.currencyTableView.reloadData()
                
                if let currencies = self?.currencies {
                    let date = Date(timeIntervalSince1970: Double(currencies.timestamp))
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") 
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let strDate = dateFormatter.string(from: date)
                    self?.timeLabel.text = strDate
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: " ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currencies = currencies else { return 0 }
        return currencies.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.currencyTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CurrencyTableViewCell
        let currenciesArray = Array(currencies!.rates)
        let object = currenciesArray[indexPath.row]
        cell.currencyLabel?.text = object.key
        cell.valueLabel?.text = "\(object.value)"
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseCurrency.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.baseCurrencyCollectionView.dequeueReusableCell(withReuseIdentifier: "BaseCurrencyCollectionCell", for: indexPath) as! BaseCurrencyCollectionCell
        
        cell.baseCurrencyLabel.text = baseCurrency[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.baseCurrencyCollectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .left
        )
        getCurrencies(base: baseCurrency[indexPath.row])
    }
}
