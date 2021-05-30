//
//  FloatingActionButton.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 25.05.2021.
//

import Foundation
import UIKit

class FloatingActionButton: UIControl {
    
    private var containerView: UIView!
    private var shadowLayer: CAShapeLayer?
    
    private var titleLabel: UILabel!
    public var imageView: UIImageView!
    
    private var expandedConstraints: [NSLayoutConstraint]!
    private var shrunkConstraints: [NSLayoutConstraint]!
    
    private var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    public func setTitle(_ title: String?) {
        self.title = title
    }
    
    private var shouldDrawShadow: Bool = true
    
    override var isHidden: Bool {
        didSet {
            if !isHidden && titleLabel != nil {
                self.expand()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.shrink()
                }
            }
            super.isHidden = isHidden
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Container View
        containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        containerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14).isActive = true
        
        expandedConstraints = [imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                    titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12)]
        
        shrunkConstraints = [imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
                     imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14)]
        
        NSLayoutConstraint.activate(expandedConstraints)
        
        
        layoutIfNeeded()
    }
    
    // MARK: -Shadow
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = self.bounds.height / 2

        drawShadowPath()
        if let layer = shadowLayer {
            layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.bounds.height / 2).cgPath
            layer.shadowPath = layer.path
        }
    }
    
    private func removeShadow() {
        if shadowLayer != nil {
            shadowLayer?.removeFromSuperlayer()
            shadowLayer = nil
        }
    }
    
    private func drawShadowPath() {
        if self.shadowLayer == nil, shouldDrawShadow {
            shadowLayer = CAShapeLayer()
            shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.bounds.height / 2).cgPath
            shadowLayer?.fillColor = UIColor.clear.cgColor

            shadowLayer?.shadowColor = UIColor.black.cgColor
            shadowLayer?.shadowPath = shadowLayer?.path
            shadowLayer?.shadowOffset = CGSize(width: 10, height: 10)
            shadowLayer?.shadowOpacity = 0.2
            shadowLayer?.shadowRadius = 10

            layer.insertSublayer(shadowLayer!, at: 0)
        }
    }
    
    // MARK: - Animations
    public func shrink() {
        self.removeShadow()
        shouldDrawShadow = false
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.titleLabel.text = nil
            NSLayoutConstraint.deactivate(self?.expandedConstraints ?? [])
            NSLayoutConstraint.activate(self?.shrunkConstraints ?? [])
            self?.superview?.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.shouldDrawShadow = true
            self?.drawShadowPath()
        }
    }
    
    public func expand(with titleStr: String? = nil, animated: Bool = false) {
        self.removeShadow()
        shouldDrawShadow = false
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.titleLabel.text = titleStr ?? self?.title
                NSLayoutConstraint.deactivate(self?.shrunkConstraints ?? [])
                NSLayoutConstraint.activate(self?.expandedConstraints ?? [])
                self?.superview?.layoutIfNeeded()
            }) { [weak self] (_) in
                self?.shouldDrawShadow = true
                self?.drawShadowPath()
            }
        } else {
            titleLabel.text = titleStr ?? title
            NSLayoutConstraint.deactivate(shrunkConstraints ?? [])
            NSLayoutConstraint.activate(expandedConstraints ?? [])
            superview?.layoutIfNeeded()
            shouldDrawShadow = true
            drawShadowPath()
        }
    }
    
    // MARK: - Action
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.sendActions(for: .touchUpInside)
    }
}
