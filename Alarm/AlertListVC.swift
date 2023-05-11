//
//  AlertListVC.swift
//  Alarm
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import UserNotifications

class AlertListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var alerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        configure()
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alerts = alertList()
    }
    
    private func configure() {
        navigationItem.title = "물마시기"
        let addAlertButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addAlertButtonAction))
        navigationItem.rightBarButtonItem = addAlertButton
    }
    
    @objc func addAlertButtonAction() {
        guard let addAlertVC = storyboard?.instantiateViewController(identifier: "AddAlertVC") as? AddAlertVC else { return }
        
        addAlertVC.pickedDate = { [weak self] date in
            guard let self = self else { return }
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            
            alertList.append(newAlert)
            alertList.sort { $0.date < $1.date }
            self.alerts = alertList

            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        self.present(addAlertVC, animated: true)
    }
    
    private func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alertList = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        return alertList
    }
}

extension AlertListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell") as? AlertListCell else { return UITableViewCell() }
        cell.configAlertCell(item: alerts[indexPath.row])
        cell.alertSwitch.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("index: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🚰 물 마실 시간"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            self.alerts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            tableView.reloadData()
            
        default:
            break
        }
    }
}
