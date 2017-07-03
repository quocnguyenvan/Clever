//
//  UsersController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import CoreData
import SwiftMessages

class UserScreenController: UIViewController {

    var menu: [String] = ["Rename", "Change Passcode", "Fingerprints"]
//    var userManager: [String] = []
    var userManager: [NSManagedObject] = []
    var imageAvatar: UIImage?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationDelegate()
    
    @IBOutlet weak var tblUser: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let customCell = UINib(nibName: "CustomCellUser", bundle: nil)
//        tblUser.register(customCell, forCellReuseIdentifier: "Cell")
        tblUser.dataSource = self
        tblUser.delegate = self
        self.tblUser.layer.cornerRadius = 5.0
        self.tblUser.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    func getUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        do {
            userManager = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension UserScreenController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            
            case 1:
                return menu.count
            
            case 2:
                return userManager.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 95
        } else if (indexPath.section == 1) {
            return 44
        } else {
            return 58
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0 || section == 1) {
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            headerCell?.backgroundColor = UIColor.clear
            
            return headerCell
        } else {
            let header = Bundle.main.loadNibNamed("HeaderUser", owner: self, options: nil)?.first as! HeaderUser
            header.userManager.text = "User Manager"
            
            if header.addButtonDelegate == nil {
                header.addButtonDelegate = self
            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 || section == 1) {
            return 25
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
            if (tableView == self.tblUser) {
                let cornerRadius: CGFloat = 10
                cell.backgroundColor = UIColor.clear
                let layer: CAShapeLayer  = CAShapeLayer()
                let pathRef: CGMutablePath  = CGMutablePath()
                let bounds: CGRect  = cell.bounds.insetBy(dx: 0, dy: 0) //dx: 25
                var addLine: Bool = false
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
                //CFRelease(pathRef)
                //set the border color
                //layer.strokeColor = UIColor.green.cgColor;
                //set the border width
                //layer.lineWidth = 5
                if (indexPath.section == 0) {
                    layer.fillColor = UIColor.clear.cgColor
                } else {
                    layer.fillColor = UIColor(white: 1, alpha: 1).cgColor
                }
            
                if (addLine == true) {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat  = (1.0 / UIScreen.main.scale)
                    lineLayer.frame = CGRect(x:bounds.minX + 30, y:bounds.size.height-lineHeight, width:bounds.size.width - 30, height:lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor!.cgColor
                    layer.addSublayer(lineLayer)
                }
                
                let testView: UIView = UIView(frame:bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = UIColor.clear
                testView.clipsToBounds = true
                
//                if (indexPath.section == 0) {
//                    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
//                }
                cell.backgroundView = testView
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            case 0:
                let cellUser = Bundle.main.loadNibNamed("CustomCellUser", owner: self, options: nil)?.first as! CustomCellUser
                cellUser.lbCurrentUser.text = "Current User"
                cellUser.lbUserName.text = "Admin01"
                cellUser.lbPermission.text = "Admin"
//                cellUser.separatorInset = UIEdgeInsetsMake(0.0, 1000.0, 0.0, 0.0)
                cellUser.separatorInset = UIEdgeInsets.zero

                if cellUser.avatarImageDelegate == nil {
                    cellUser.avatarImageDelegate = self
                }
                
                if (imageAvatar != nil) {
                    cellUser.imgAvatar.image = imageAvatar
                }
                
                return cellUser
            
            case 1:
                let cell = Bundle.main.loadNibNamed("CustomCellUser2", owner: self, options: nil)?.first as! CustomCellUser2
                cell.accessoryType = .disclosureIndicator
                
                cell.userMenu.text = menu[indexPath.row]
//                cell.contentView.layer.cornerRadius = 10.0
//                cell.contentView.layer.borderColor = UIColor.black.cgColor
//                cell.contentView.layer.borderWidth = 3.0
            return cell
            
            case 2:
                let cell = Bundle.main.loadNibNamed("CustomCellUserManager", owner: self, options: nil)?.first as! CustomCellUserManager
                cell.accessoryType = .disclosureIndicator
                
                let user = userManager[indexPath.row]
                let name = user.value(forKeyPath: "name") as? String
                
                let firstText = name?.characters.first // lay ky tu dau tien
                
                cell.imgUser.text = String(describing: firstText!)
                
                cell.lbName.text = name
                cell.lbPermission.text = "Permissions: User"
            
            return cell
            
            default:
                let cell = Bundle.main.loadNibNamed("CustomCellUser2", owner: self, options: nil)?.first as! CustomCellUser2
                cell.userMenu.text = "other"
                return cell
        }
    }
}

// add user
extension UserScreenController: UITableViewDelegate, AddDelegate, AddNewUserDelegate {

    func addPress() {

        let controller = storyboard?.instantiateViewController(withIdentifier: "Modal") as! AddNewUserController
//        let controller = ModalViewController(nibName: "ModalViewController", bundle: nil)
        
        slideInTransitioningDelegate.direction = .top
        slideInTransitioningDelegate.disableCompactHeight = true
        controller.transitioningDelegate = slideInTransitioningDelegate
        controller.addNewUserDelegate = self
        controller.modalPresentationStyle = .custom
        present(controller, animated: true, completion: nil)
    }
    
    func addNewUser(user: String, pass: String, rePass: String) {
        if (user.isEmpty || pass.isEmpty || rePass.isEmpty) {
            showMessage(content: "Vui lòng nhập đầy đủ thông tin!", theme: .error, duration: 0.8)
        } else if (pass.caseInsensitiveCompare(rePass) == .orderedSame) {
            
            saveUser(name: user)
            tblUser.reloadData()
            dismiss(animated: true, completion: nil)
            showMessage(content: "Tạo tài khoản thành công!", theme: .success, duration: 1.0)
        } else {
            showMessage(content: "Mật khẩu không trùng khớp!", theme: .error, duration: 0.8)
        }
    }
    
    func saveUser(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
//        user.setValue(id, forKeyPath: "id")
        user.setValue(name, forKeyPath: "name")
            
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                userManager.append(user)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func showMessage(content: String, theme: Theme, duration: TimeInterval) {
        let message = MessageView.viewFromNib(layout: .MessageView)
        message.configureTheme(theme, iconStyle: .subtle)
        message.configureDropShadow()
        message.configureContent(body: content)
        message.button?.isHidden = true
        message.titleLabel?.isHidden = true
        var messageConfig = SwiftMessages.defaultConfig
        messageConfig.presentationStyle = .top
        messageConfig.duration = .seconds(seconds: duration)
        messageConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        SwiftMessages.show(config: messageConfig, view: message)
    }
}

extension UserScreenController: AvatarImageDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tapAvatar() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alertChooseAvatar = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertChooseAvatar.addAction(photo)
        alertChooseAvatar.addAction(camera)
        alertChooseAvatar.addAction(cancel)
        self.present(alertChooseAvatar, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("😞: \(info)")
        }
        
        imageAvatar = selectedImage
        tblUser.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCamera() {
        let alert = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present( alert, animated: true, completion: nil)
    }
}
