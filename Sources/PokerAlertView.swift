//
//  PokerAlertView.swift
//  PokerCard
//
//  Created by Weslie Chen on 2019/9/11.
//  Copyright © 2019 Weslie. All rights reserved.
//

import UIKit

/// Base Poker Alert View
public class PokerAlertView: PokerView {
    
    public enum Style {
//        public typealias RawValue = <#type#>
        
        case `default`  // gray
        case primary    // blue
        case info       // teal
        case warn       // orange
        case danger     // red
        case success    // green
    }
    
    public var titleLabel: UILabel!
    public var detailLabel: UILabel?
    public var confirmButton: UIButton!
    internal var cancelButton: UIButton!
    
    internal var titleHorizontalInset: CGFloat = 24
    internal var titleVerticalInset: CGFloat = 18
    internal var detailHorizontalInset: CGFloat = 15
    internal var buttonHorizontalInset: CGFloat = 40
    
    private var titleLabelEstimatedHeight: CGFloat {
        get {
            let labelWidth = frame.width - 2 * titleHorizontalInset
            titleLabel.preferredMaxLayoutWidth = labelWidth
            return titleLabel.intrinsicContentSize.height
        }
    }
    
    private var detailLabelEstimatedHeight: CGFloat {
        get {
            let labelWidth = frame.width - 2 * detailHorizontalInset
            detailLabel?.preferredMaxLayoutWidth = labelWidth
            return detailLabel?.intrinsicContentSize.height ?? 0
        }
    }
    
//    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style)
    
    public convenience init(title: String, detail: String? = nil) {
        self.init(frame: CGRect(x: 0, y: 0, width: 265, height: 159))
        
        backgroundColor = PKColor.background
        
        setupLabel(with: title)
        setupConfirmCancelButton()
        
        setupDetail(with: detail)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = layoutViews
    }
    
    private lazy var layoutViews: Void = {
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        
        // resize title label
        // offset = estimated - original
        //
        // height = height - original + estimated
        // height -= original - estimated
        frame.size.height -= titleLabel.frame.height - titleLabelEstimatedHeight
        frame.size.height -= (detailLabel?.frame.height ?? 0) - detailLabelEstimatedHeight
        
        // align to center
        guard let superView = self.superview else { return }
        frame.origin.y = superView.frame.midY - frame.size.height / 2
    }()
    
    private func setupLabel(with title: String) {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = PKColor.label
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18).isActive = true
        titleLabel.constraint(withLeadingTrailing: titleHorizontalInset)
        
    }
    
    private func setupDetail(with detail: String?) {
        guard let detail = detail, !detail.isEmpty else { return }
        
        detailLabel = UILabel()
        detailLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        detailLabel?.text = detail
        detailLabel?.textAlignment = detailLabel?.numberOfLines == 1 ? .center : .natural
        detailLabel?.textColor = PKColor.label
        detailLabel?.numberOfLines = 0
        detailLabel?.translatesAutoresizingMaskIntoConstraints = false
//        detailLabel?.setContentCompressionResistancePriority(UILayoutPriority(752), for: .vertical)
        addSubview(detailLabel!)
        
        let detailAndConfirmConstraint = detailLabel?.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -12)
        detailAndConfirmConstraint?.priority = .defaultHigh
        detailAndConfirmConstraint?.isActive = true
        
        detailLabel?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        detailLabel?.constraint(withLeadingTrailing: detailHorizontalInset)
    }
    
    private func setupConfirmCancelButton() {
        confirmButton = UIButton()
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmButton.backgroundColor = PKColor.blue
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(confirmButton)
        
        let buttonAndTitleConstraint = confirmButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleVerticalInset)
        buttonAndTitleConstraint.priority = .defaultHigh
        buttonAndTitleConstraint.isActive = true
        confirmButton.constraint(withLeadingTrailing: buttonHorizontalInset)
        confirmButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        cancelButton = UIButton()
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(PKColor.cancel, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 88).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
}

extension UIView {
    /// set leading and trailing anchor
    internal func constraint(withLeadingTrailing inset: CGFloat) {
        guard let superView = self.superview else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: inset).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -inset).isActive = true
    }
}
