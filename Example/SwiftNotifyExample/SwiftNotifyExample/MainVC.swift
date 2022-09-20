//
//  MainVC.swift
//  SwiftNotifyExample
//
//  Created by Johnny Tsoi on 25/11/2016.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuArray = ["#CyberView","#ClassicView","#ToastView","#Playground"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MainTableViewCell
        
        cell.titleLabel.text = menuArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            self.performSegue(withIdentifier: "ShowCyberViewSegue", sender: nil)
        }
        else if (indexPath.row == 1) {
            self.performSegue(withIdentifier: "ShowClassicSegue", sender: nil)
        }
        else if (indexPath.row == 2) {
            self.performSegue(withIdentifier: "ShowToastSegue", sender: nil)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "ShowPlaygroundSegue", sender: nil)
        }
    }
}
