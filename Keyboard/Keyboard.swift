//
//  Keyboard.swift
//  Keyboard
//
//  Created by Konrad on 27/08/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import Foundation
import UIKit

public protocol KeyboardDelegate : class {
    func keyboardChanged(keyboard: Keyboard, state: Keyboard.State)
}

public class Keyboard {
    public enum State {
        case visible(size: CGSize)
        case hidden
    }
    private weak var delegate: KeyboardDelegate?
    public var keyboardChanged: ((_ state: Keyboard.State) -> Void)?
    
    public func register(target: KeyboardDelegate? = nil, keyboardChanged: ((_ state: Keyboard.State) -> Void)? = nil) {
        self.delegate = target
        self.keyboardChanged = keyboardChanged
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func unregister() {
        self.delegate = nil
        self.keyboardChanged = nil
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc public func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let state: Keyboard.State = Keyboard.State.visible(size: keyboardFrame.size)
        
        // delegate
        self.delegate?.keyboardChanged(keyboard: self, state: state)
        
        // closure notification
        self.keyboardChanged?(state)
    }
    
    @objc public func keyboardWillHide(_ notification: NSNotification) {
        let state: Keyboard.State = Keyboard.State.hidden
        
        // delegate
        self.delegate?.keyboardChanged(keyboard: self, state: Keyboard.State.hidden)
        
        // closure notification
        self.keyboardChanged?(state)
    }
}
