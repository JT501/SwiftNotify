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
    @IBOutlet var toButton: UIButton!

    lazy var offsetLabel: UILabel = UILabel()
    lazy var offsetTextField: UITextField = UITextField()

    let width = UIScreen.main.bounds.width * 0.9
    let height = UIScreen.main.bounds.height / 5

    var theme: Theme = .cyber
    var level: Level = .info
    var duration: Duration = .short
    var from: FromPosition = .top(.center)
    var fromPositions = ["Top", "Bottom", "Left", "Right"]
    var to: ToPosition = .top()
    var toPositions = ["Top", "Center", "Bottom"]

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
        SN.show(
                title: titleTextField.text,
                message: bodyTextView.text,
                theme: theme,
                level: level,
                duration: duration,
                fromPosition: from,
                toPosition: to
        )
    }

    @IBAction func dismissCurrent() {
        SN.dismissCurrent()
    }

    @IBAction func showStyleSheet() {
        let sheetController = UIAlertController(title: "Style", message: "Select A Style", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        Theme.allCases.forEach { (theme: Theme) in
            let action = UIAlertAction(title: theme.rawValue, style: .default) { [weak self] action in
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
            let action = UIAlertAction(title: level.rawValue.capitalized, style: .default) { [weak self] action in
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
            let action = UIAlertAction(title: durationStringMap[duration], style: .default) { [weak self] action in
                self?.duration = duration
                self?.durationButton.setTitle(durationStringMap[duration], for: .normal)
                self?.customLabel.isEnabled = false
                self?.customTextField.isEnabled = false
            }
            sheetController.addAction(action)
        }
        let customAction = UIAlertAction(title: "Custom", style: .destructive) { [weak self] action in
            self?.duration = .custom(0)
            self?.durationButton.setTitle("Custom", for: .normal)
            self?.customLabel.isEnabled = true
            self?.customTextField.isEnabled = true
        }
        sheetController.addAction(customAction)

        present(sheetController, animated: true)
    }

    @IBAction func showFromPositionSheet() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: width, height: height)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pickerView.tag = 1
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.selectRow(0, inComponent: 0, animated: false)

        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true

        let sheetController = UIAlertController(
                title: "From Position",
                message: "Select From Position",
                preferredStyle: .actionSheet
        )

        sheetController.popoverPresentationController?.sourceView = fromButton
        sheetController.popoverPresentationController?.sourceRect = fromButton.bounds

        sheetController.setValue(vc, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sheetController.addAction(cancelAction)

        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] action in
            guard let self = self else { return }
            let selectedRow = pickerView.selectedRow(inComponent: 0)

            if selectedRow <= 1 {
                let selected2ndRow = pickerView.selectedRow(inComponent: 1)
                let horizontal = FromPosition.HorizontalPosition.allCases[selected2ndRow]

                self.from = FromPosition(index: selectedRow, horizontal: horizontal) ?? .top(.center)
                self.fromButton
                    .setTitle(
                            """
                            \(self.fromPositions[selectedRow]) - \(horizontal.rawValue.capitalized)
                            """,
                            for: .normal
                    )
            } else {
                self.from = FromPosition(index: selectedRow) ?? .top(.center)
                self.fromButton.setTitle(self.fromPositions[selectedRow], for: .normal)
            }
        }

        sheetController.addAction(selectAction)

        present(sheetController, animated: true)
    }

    @IBAction func showToPositionSheet() {
        let vc = UIViewController()
        vc.hideKeyboardWhenTappedAround()
        vc.preferredContentSize = CGSize(width: width, height: height + 50)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pickerView.tag = 2
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.selectRow(0, inComponent: 0, animated: false)

        vc.view.addSubview(pickerView)
        pickerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true

        offsetLabel.text = "Offset:"
        offsetLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true

        offsetTextField.text = "100"
        offsetTextField.textAlignment = .center
        offsetTextField.borderStyle = .line
        offsetTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        offsetTextField.keyboardType = .numberPad

        let stack = UIStackView(arrangedSubviews: [offsetLabel, offsetTextField])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true

        let sheetController = UIAlertController(
                title: "To Position",
                message: "Select To Position",
                preferredStyle: .actionSheet
        )

        sheetController.popoverPresentationController?.sourceView = toButton
        sheetController.popoverPresentationController?.sourceRect = toButton.bounds

        sheetController.setValue(vc, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sheetController.addAction(cancelAction)

        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] action in
            guard let self = self else { return }
            let selectedRow = pickerView.selectedRow(inComponent: 0)

            self.to = ToPosition.allCases[selectedRow]

            switch self.to {
            case .top:
                if let text = self.offsetTextField.text, let num = NumberFormatter().number(from: text) {
                    self.to = .top(offset: CGFloat(truncating: num))
                    self.toButton.setTitle("\(self.toPositions[selectedRow]) (\(num))", for: .normal)
                }
            case .bottom:
                if let text = self.offsetTextField.text, let num = NumberFormatter().number(from: text) {
                    self.to = .bottom(offset: CGFloat(truncating: num))
                    self.toButton.setTitle("\(self.toPositions[selectedRow]) (\(num))", for: .normal)
                }
            default:
                self.toButton.setTitle(self.toPositions[selectedRow], for: .normal)
            }
        }

        sheetController.addAction(selectAction)

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

extension PlaygroundVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 2
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            if component == 0 {
                return fromPositions.count
            } else if pickerView.selectedRow(inComponent: 0) <= 1 {
                return FromPosition.HorizontalPosition.allCases.count
            }
        } else {
            return ToPosition.allCases.count
        }
        return 0
    }

    public func pickerView(
            _ pickerView: UIPickerView,
            viewForRow row: Int,
            forComponent component: Int,
            reusing view: UIView?
    ) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        if pickerView.tag == 1 {
            if component == 0 {
                label.text = fromPositions[row]
            } else {
                label.text = FromPosition.HorizontalPosition.allCases[row].rawValue.capitalized
            }
        } else {
            label.text = toPositions[row]
        }
        label.sizeToFit()
        return label
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 && component == 0 {
            pickerView.reloadComponent(1)
        }
        if pickerView.tag == 2 {
            let selectedTo = ToPosition.allCases[pickerView.selectedRow(inComponent: 0)]

            switch selectedTo {
            case .top:
                offsetLabel.isEnabled = true
                offsetTextField.isEnabled = true
                offsetTextField.text = "100"
            case .bottom:
                offsetLabel.isEnabled = true
                offsetTextField.isEnabled = true
                offsetTextField.text = "50"
            default:
                offsetTextField.isEnabled = false
                offsetLabel.isEnabled = false
            }
            customTextField.endEditing(true)
        }
    }
}


extension Theme: CaseIterable {
    public static var allCases: [Theme] = [classic, classicDark, cyber, cyberDark, toast, toastDark]
}

extension Level: CaseIterable {
    public static var allCases: [Level] = [success, fail, info, warning]
}

extension Duration: CaseIterable {
    public static var allCases: [Duration] = [short, long, forever]
}

extension FromPosition {
    public init?(index: Int, horizontal: HorizontalPosition? = nil) {
        if index <= 1 && horizontal == nil {
            return nil
        }
        switch index {
        case 0:
            self = .top(horizontal!)
        case 1:
            self = .bottom(horizontal!)
        case 2:
            self = .left
        case 3:
            self = .right
        default:
            return nil
        }
    }
}

extension FromPosition.HorizontalPosition: CaseIterable {
    public static var allCases: [FromPosition.HorizontalPosition] = [left, right, center, random]
}

extension ToPosition: CaseIterable {
    public static var allCases: [ToPosition] = [top(), center, bottom()]
}
