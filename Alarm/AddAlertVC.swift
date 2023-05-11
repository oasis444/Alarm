//
//  AddAlertVC.swift
//  Alarm
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class AddAlertVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    let navigationBar = UINavigationBar()
    
    var pickedDate: ((_ date: Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.addSubview(navigationBar)
        let safeArea = self.view.safeAreaLayoutGuide
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        let navigationItem = UINavigationItem()
        let leftButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissAction))
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.title = "알림 추가"
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        navigationBar.setItems([navigationItem], animated: true)
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
    
    @objc func saveAction() {
        pickedDate?(datePicker.date)
        self.dismiss(animated: true)
    }
}
