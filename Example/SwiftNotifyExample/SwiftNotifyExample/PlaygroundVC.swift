//
//  PlaygroundVC.swift
//  SwiftNotifyExample
//
//  Created by Johnny Choi on 20/9/2022.
//  Copyright © 2022 Johnny@Co-fire. All rights reserved.
//

import UIKit
import SwiftNotify

class PlaygroundVC: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var themeButton: UIButton!
    @IBOutlet var levelButton: UIButton!
    @IBOutlet var durationButton: UIButton!
    @IBOutlet var customLabel: UILabel!
    @IBOutlet var customTextField: UITextField!
    @IBOutlet var fromButton: UIButton!

    var theme: Theme = .cyber
    var level: Level = .info
    var duration: Duration = .short
    var from: FromPosition = .top(.center)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
    }

    @IBAction func showNotice() {
        switch duration {
        case .custom:
            if let value = Int(customTextField.text ?? "") {
                duration = .custom(value)
            } else {
                duration = .forever
            }
        default:
            break
        }
        SN.show(title: titleTextField.text, message: bodyTextView.text, theme: theme, level: level, duration: duration)
    }

    @IBAction func dismissCurrent() {
        SN.dismissCurrent()
    }

    @IBAction func showStyleSheet() {
        let sheetController = UIAlertController(title: "Style", message: "Select A Style", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        Theme.allCases.forEach { (theme: Theme) in
            let action = UIAlertAction(title: theme.rawValue, style: .destructive) { [weak self] action in
                self?.theme = theme
                self?.themeButton.setTitle(theme.rawValue, for: .normal)
            }
            sheetController.addAction(action)
        }
        sheetController.addAction(cancelAction)

        present(sheetController, animated: true)
    }

    @IBAction func showLevelSheet() {
        let sheetController = UIAlertController(title: "Level", message: "Select A Level", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sheetController.addAction(cancelAction)
        Level.allCases.forEach { (level: Level) in
            let action = UIAlertAction(title: level.rawValue.capitalized, style: .destructive) { [weak self] action in
                self?.level = level
                self?.levelButton.setTitle(level.rawValue.capitalized, for: .normal)
            }
            sheetController.addAction(action)
        }

        present(sheetController, animated: true)
    }

    @IBAction func showDurationSheet() {
        let durationStringMap: [Duration: String] = [.short: "Short", .long: "Long", .forever: "Forever"]
        let sheetController = UIAlertController(
                title: "Duration",
                message: "Select A Duration",
                preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sheetController.addAction(cancelAction)
        Duration.allCases.forEach { (duration) in
            let action = UIAlertAction(title: durationStringMap[duration], style: .destructive) { [weak self] action in
                self?.duration = duration
                self?.durationButton.setTitle(durationStringMap[duration], for: .normal)
                self?.customLabel.isEnabled = false
                self?.customTextField.isEnabled = false
            }
            sheetController.addAction(action)
        }
        let customAction = UIAlertAction(title: "Custom", style: .default) { [weak self] action in
            self?.duration = .custom(0)
            self?.durationButton.setTitle("Custom", for: .normal)
            self?.customLabel.isEnabled = true
            self?.customTextField.isEnabled = true
        }
        sheetController.addAction(customAction)

        present(sheetController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Put this piece of code anywhere you like

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}