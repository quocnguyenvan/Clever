//
//  RegisterLock.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/27/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class RegisterLock: UIViewController {

    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Setup Adminstrator"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow_back"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let back = UIBarButtonItem(customView: button)
        navigationItem.setLeftBarButton(back, animated: true)
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        navigationItem.rightBarButtonItem = done
        
        btnCheckBox.setBackgroundImage(UIImage(named: "unchecked"), for: .normal)
        btnCheckBox.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func tapDone() {
        print("done!")
    }
    
    func tapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(fade), userInfo: nil, repeats: true)
    }
    
    func fade() {
        lblRequired.isHidden = !lblRequired.isHidden
    }
    
    @IBAction func tapCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if (sender.isSelected == true) {
            lblRequired.isHidden = true
            timer.invalidate()
        } else {
            lblRequired.isHidden = false
            startTimer()
        }
    }
}
