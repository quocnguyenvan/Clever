//
//  ViewController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/5/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let refreshControl = UIRefreshControl()
    var nameArr: [String] = ["Clever-001", "Clever-002", "Clever-003", "Clever-004", "Clever-005", "Clever-006"]
    var iPArr: [String] = ["50:00:00:00:00:00", "50:00:00:00:00:06", "60:00:00:00:00:07", "50:00:00:00:00:09", "50:00:00:00:00:12", "60:00:00:00:00:12"]
    var tapInfo: Bool = false
    @IBOutlet weak var tblSelectLock: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSelectLock.dataSource = self
        // khoá row không cho chọn
        tblSelectLock.allowsSelection = false
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            tblSelectLock.refreshControl = refreshControl
        } else {
            tblSelectLock.addSubview(refreshControl)
        }
    }
    
    func refresh(sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            
            if (self.refreshControl.isRefreshing) {
                self.nameArr.append("Clever-007")
                self.iPArr.append("192.168.9.35")
                self.refreshControl.endRefreshing()
            }
            self.tblSelectLock.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_info"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(ViewController.infoTap), for: .touchUpInside)
        let stop = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(ViewController.stopTap))
        let info = UIBarButtonItem(customView: button)
        self.navigationItem.setLeftBarButtonItems([info], animated: true)
        self.navigationItem.setRightBarButtonItems([stop], animated: true)
        // show navigationBar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func infoTap() {
        tapInfo = !tapInfo
        tblSelectLock.reloadData()
        
//        let splash = Bundle.main.loadNibNamed("SplashScreen", owner: self, options: nil)?.first as! SplashScreenController
//        present(splash, animated: true, completion: nil)
    }
    
    func stopTap() {
        if (self.refreshControl.isRefreshing) {
            self.refreshControl.endRefreshing()
            self.tblSelectLock.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, CellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectLockCell
        
        cell.lblName.text = nameArr[indexPath.row]
        cell.lblIP.text = iPArr[indexPath.row]
        
        (tapInfo == true) ? (cell.lblIP.isHidden = false) : (cell.lblIP.isHidden = true)
        // bắt sự kiện nhấn nút connect trên mỗi row
        if cell.btnConnectDelegate == nil {
            cell.btnConnectDelegate = self
        }
        
        return cell
    }
    // kế thừa lại hàm của protocol
    func connectPressed(cell: SelectLockCell) {
        let row = tblSelectLock.indexPath(for: cell)!.row
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainView")
        
        navigationController?.pushViewController(mainView!, animated: true)
        print(nameArr[row])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return nil }
}

