//
//  HistoryController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class HistoryScreenController: UIViewController {

    var historyArr: [String] = ["History", "Filter History By Date"]
    var syncArr: [String] = ["Last Sync", "Sync With Cloud"]
//    var panelView: UIView! = UIView()
    
    @IBOutlet weak var lbSync: UILabel!
    @IBOutlet weak var tblHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblHistory.dataSource = self
        tblHistory.delegate = self
//        tblHistory.layer.cornerRadius = 20.0
        lbSync.text = "○ Please wait during synchronization. \n○ Synchronization will be interrupted if you switch to another interface."
    }
    
    lazy var historyController: HistoryTableController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let history = storyboard.instantiateViewController(withIdentifier: "TableHistory") as! HistoryTableController
        return history
    }()
}

extension HistoryScreenController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = historyArr[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            
        case 1:
            cell.accessoryType = .none
            if (syncArr[indexPath.row] == "Last Sync") {
                let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 25))
                timeLabel.text = "Jun 09, 2017 14:23:32"
                timeLabel.textColor = .red
                cell.accessoryView = timeLabel as UIView
            }
            
            if (syncArr[indexPath.row] == "Sync With Cloud") {
                let syncButton = UIButton(type: .custom) as UIButton
                syncButton.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
                syncButton.addTarget(self, action: #selector(HistoryScreenController.syncTap), for: .touchUpInside)
                syncButton.setImage(UIImage(named: "ic_sync"), for: .normal)
                cell.accessoryView = syncButton as UIView
            }
            cell.textLabel?.text = syncArr[indexPath.row]
        
        default:
            cell.textLabel?.text = "Other"
        }
        
        return cell
    }
    
    func syncTap() {
        print("sync")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // trong suot section header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
            let cornerRadius: CGFloat = 10
            cell.backgroundColor = UIColor.clear
            let layer: CAShapeLayer  = CAShapeLayer()
            let pathRef: CGMutablePath  = CGMutablePath()
            let bounds: CGRect  = cell.bounds.insetBy(dx: 0, dy: 0)
            var addLine: Bool  = false
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            } else if (indexPath.row == 0) {
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.maxY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.minY), tangent2End: CGPoint(x:bounds.midX,y:bounds.minY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.minY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.maxY))
                addLine = true;
            } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.minY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.midX,y:bounds.maxY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.minY))
                
            } else {
                pathRef.addRect(bounds)
                addLine = true
            }
            layer.path = pathRef
            //set the border color
            layer.strokeColor = UIColor.lightGray.cgColor;
            //set the border width
            layer.lineWidth = 1
            layer.fillColor = UIColor(white: 1, alpha: 1.0).cgColor
            
            if (addLine == true) {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat  = (1 / UIScreen.main.scale)
                lineLayer.frame = CGRect(x:bounds.minX, y:bounds.size.height-lineHeight, width:bounds.size.width, height:lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor!.cgColor
                layer.addSublayer(lineLayer)
            }
            
            let testView: UIView = UIView(frame:bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = UIColor.clear
            cell.backgroundView = testView
        }
    }
}

extension HistoryScreenController {
    
    public func addViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
    public func removeViewController(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
    public func removeAllController() {
        removeViewController(childViewController: historyController)
    }
}

extension HistoryScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (historyArr[indexPath.row] == "History") {
//                removeAllController()
//                addViewController(childViewController: historyController)
                
                let history = storyboard?.instantiateViewController(withIdentifier: "TableHistory")
                navigationController?.pushViewController(history!, animated: true)
            }
        }
    }
}
