//
//  File.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 4/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import FirebaseAuth
//  MARK: Variables
//  Variable - NotificationsEnabled: Bool
//  Variable - CameraRollAccessEnabled: Bool
//  Variable - CameraAccessEnabled: Bool
//  Variable - MicrophoneAccessEnabled: Bool
//  MARK: Methods
class SettingsController: ASViewController<ASCollectionNode> {
      
    let layout = UICollectionViewFlowLayout()
    var firstFetch = true
    var isLoadingPost = false
    var newItems = 0
    let notification = StatusBarNotificationBanner(title: "Success")
        
    private var collectionNode: ASCollectionNode {
            return node
    }

    init() {
        layout.itemSize = CGSize(width: UIScreen.screenWidth(), height: 44.0)
        layout.minimumLineSpacing = 4.0
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        collectionNode.delegate = self
        collectionNode.dataSource = self
        self.collectionNode.alwaysBounceVertical = true
        self.collectionNode.view.isScrollEnabled = false
        self.collectionNode.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
    }
        
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }

}

// MARK: ASTableDataSource / ASTableDelegate
extension SettingsController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        switch indexPath.row {
        case 0:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.contentMode = .scaleAspectFit
            cell.contentNode.settingIcon.image = UIImage(named: "user-group")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "Invite Friends", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        case 1:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.image = UIImage(named: "NotificationBlack")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "Notifications", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        case 2:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.image = UIImage(named: "Security")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "Account Security", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        case 3:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.image = UIImage(named: "ProfileIcon")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "Edit Profile", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        case 4:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.image = UIImage(named: "Help")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "Help", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        default:
            let cell = SettingsDisplayNode()
            cell.contentNode.settingIcon.image = UIImage(named: "Info")
            cell.contentNode.settingTitle.attributedText = NSAttributedString(string: "About", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            return cell
        }

    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //Insert View controller for every setting page
            let vc = InviteController()
            navigationController?.pushViewController(vc, animated: true)
            return
        case 1:
            let vc = NotificationSettingController()
            navigationController?.pushViewController(vc, animated: true)
            return
        case 2:
            let vc = PrivacyController()
            navigationController?.pushViewController(vc, animated: true)
            return
        case 3:
            let vc = EditProfileScrollController()
            navigationController?.pushViewController(vc, animated: true)
            return
        case 4:
            let vc = HelpController()
            navigationController?.pushViewController(vc, animated: true)
            return
        default:
            let vc = AboutController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
}

extension SettingsController {
    
    func setupNavBar() {
        self.navigationItem.title = "Settings"
        //let yourBackImage = UIImage(named: "backButton")
        
        let rightButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func logoutUser(){
        
        let alert = UIAlertController(title: "Sign Out", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                let alert = UIAlertController(title: "Error", message: "There was an error logging out.", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
               
                fatalError("""
                    Domain: \(error.domain)
                    Code: \(error.code)
                    Description: \(error.localizedDescription)
                    Failure Reason: \(error.localizedFailureReason ?? "")
                    Suggestions: \(error.localizedRecoverySuggestion ?? "")
                    """)
                
            }
            
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeIndexFromProfile"), object: nil)
            
        }))
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
