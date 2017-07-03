//
//  InfoController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class InfoScreenController: UIViewController {

    var infoUser: [String] = ["Authentication", "Clever Management"]
    var infoLock: [String] = ["Application", "Software Version", "Firmware Version", "Firmware Date Release", "Hardware Version"]
    var detailLock: [String] = ["Clever Beta", "SPL-CL-V1.0", "SPL-SF-V1.4", "May 09, 2017", "SPL-S-V1.4"]
    
    @IBOutlet weak var tblInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblInfo.dataSource = self
    }
}

extension InfoScreenController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = infoUser[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("CustomCellInfo", owner: self, options: nil)?.first as! CustomCellInfo
            cell.lbInfoLock.text = infoLock[indexPath.row]
            cell.lbDetailLock.text = detailLock[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return "" }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 10 }
}
