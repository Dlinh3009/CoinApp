//
//  OperationViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import UIKit
import Charts

class ChartViewController: UIViewController{
    let textField = UITextField()
    let fetchButton = UIButton(type: .system)
    let lineChartView = LineChartView()
    let tableView = UITableView()
    var filteredSuggestions = [String]()
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setupFetchButton()
        setupLineChartView()
        setupTableView()
        fetchSuggestion()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
    }
    
    func setUpTextField() {
        textField.placeholder = "Tên coin (VD: bitcoin, wrapped-bitcoin)"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupFetchButton() {
        fetchButton.setTitle("Hiển thị biểu đồ", for: .normal)
        fetchButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        fetchButton.tintColor = .customGreen
        view.addSubview(fetchButton)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fetchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupLineChartView() {
        view.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 5),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lineChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        lineChartView.xAxis.valueFormatter = DateValueFormatter()
        lineChartView.doubleTapToZoomEnabled = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    @objc func showButtonTapped() {
        guard let coinName = textField.text?.lowercased(), !coinName.isEmpty else {
            showAlert(title: "Lỗi", message: "Bạn chưa nhập tên coin.")
            return
        }
        
        fetchMarketChart(for: coinName)
    }
    
    @objc func currencyDidChange() {
        guard let coinName = textField.text?.lowercased(), !coinName.isEmpty else {
            return
        }
        
        fetchMarketChart(for: coinName)
    }
    
    func fetchMarketChart(for coinName: String) {
        APIService.shared.fetchMarketChart(for: coinName) { [weak self] marketChart, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let marketChart = marketChart {
                    self.updateChart(with: marketChart.prices, coinName: coinName)
                } else {
                    self.showAlert(title: "Lỗi", message: "Coin không tồn tại hoặc không có dữ liệu.")
                }
            }
        }
    }

    
    func fetchSuggestion() {
        APIService.shared.fetchCoins { [weak self] coins in
            guard let self = self, let coins = coins else { return }
            self.coins = coins
            self.filteredCoins = coins
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func updateChart(with prices: [[Double]], coinName: String) {
        var entries = [ChartDataEntry]()
        for price in prices {
            let timeInterval = price[0] / 1000
            let value = price[1]
            let entry = ChartDataEntry(x: timeInterval, y: value)
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Giá \(coinName.capitalized)")
        dataSet.colors = [NSUIColor.customGreen]
        dataSet.circleColors = [NSUIColor.customGreen]
        dataSet.circleRadius = 4.0
        dataSet.lineWidth = 2.0
    
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        
        lineChartView.chartDescription.text = "Biến động giá trong 7 ngày qua (\(CurrencyManager.shared.currency))"
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0, yAxisDuration: 0)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
    }

}

extension ChartViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            filterCoins(searchString: newText)
        }
        return true
    }
        
    func filterCoins(searchString: String) {
        if !searchString.isEmpty {
            filteredCoins = coins.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
        }
        tableView.isHidden = filteredCoins.isEmpty
        tableView.reloadData()
    }
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredCoins[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = filteredCoins[indexPath.row].id
        tableView.isHidden = true
    }
}
