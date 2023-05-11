//
//  AlertListCell.swift
//  Alarm
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import UserNotifications

class AlertListCell: UITableViewCell {

    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configAlertCell(item: Alert) {
        meridiemLabel.text = item.meridiem
        timeLabel.text = item.time
        alertSwitch.isOn = item.isOn
    }
    
    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        alerts[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
}
