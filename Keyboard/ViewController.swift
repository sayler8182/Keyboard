//
//  ViewController.swift
//  Keyboard
//
//  Created by Konrad on 27/08/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate lazy var textField: UITextField = {
        let frame: CGRect = CGRect(
            x: (UIScreen.main.bounds.width - 200) / 2,
            y: (UIScreen.main.bounds.height - 100),
            width: 200,
            height: 44)
        let textField: UITextField = UITextField(frame: frame)
        textField.placeholder = "Fill me"
        textField.backgroundColor = UIColor.groupTableViewBackground
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.delegate = self
        return textField
    }()

    fileprivate let keyboard: Keyboard = Keyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.textField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // register keyboard
        self.keyboard.register { [weak self] (state) in
            guard let `self` = self else { return }
            switch state {
            case .visible(let size):
                self.textField.frame.origin.y = UIScreen.main.bounds.height - 60 - size.height
            case .hidden:
                self.textField.frame.origin.y = UIScreen.main.bounds.height - 100
            }
        }
        
        // or can register delegate
        // self.keyboard.register(target: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // unregister keyboard
        self.keyboard.unregister()
    }
}

// MARK: KeyboardDelegate
extension ViewController: KeyboardDelegate {
    func keyboardChanged(keyboard: Keyboard, state: Keyboard.State) {
        switch state {
        case .visible(let size):
            self.textField.frame.origin.y = UIScreen.main.bounds.height - 60 - size.height
        case .hidden:
            self.textField.frame.origin.y = UIScreen.main.bounds.height - 100
        }
    }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
