//
//  ChatInputAccessotyView.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/29.
//

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    
    func tappedSendButton(text: String)
    func tappedBackButton()
}

class ChatInputAccessoryView: UIView {

    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func tappedButton(_ sender: Any) {
        guard let text = chatText.text else { return }
        delegate?.tappedSendButton(text: text)
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        delegate?.tappedBackButton()
    }
    
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibInit()
        setupView()
        autoresizingMask = .flexibleHeight
    }
    
    private func setupView() {
        
        chatText.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        chatText.layer.borderWidth = 1
        
        sendButton.isEnabled = false
        
        chatText.text = ""
        chatText.delegate = self
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func removetext() {
        chatText.text = ""
        sendButton.isEnabled = false
    }
    
    private func nibInit() {
        
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
