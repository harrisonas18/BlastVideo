//
//  CustomNavigationBar.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/14/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CustomNavigationBar: ASDisplayNode {
    
    var selected = false {
        didSet {
            transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
        }
    }
    
    let tabDot: ASDisplayNode = {
        let node = ASDisplayNode()
        node.isUserInteractionEnabled = false
        node.style.width = ASDimensionMake("5pt")
        node.style.height = ASDimensionMake("5pt")
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 1.0
        node.cornerRadius = 2.5
        node.backgroundColor = .black
        return node
    }()
    
    let followingDot: ASDisplayNode = {
        let node = ASDisplayNode()
        node.isUserInteractionEnabled = false
        node.style.width = ASDimensionMake("5pt")
        node.style.height = ASDimensionMake("5pt")
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 1.0
        node.cornerRadius = 2.5
        node.backgroundColor = .black
        return node
    }()
    
    let discoverLabel: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.setAttributedTitle(NSAttributedString(string: "Discover", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 1.0
        node.style.flexGrow = 1.0
        node.style.height = ASDimensionMake("35pt")
        return node
    }()
    
    let followingLabel: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
        node.setAttributedTitle(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
//        node.layer.borderColor = UIColor.black.cgColor
//        node.layer.borderWidth = 1.0
        node.style.flexGrow = 1.0
        node.style.height = ASDimensionMake("35pt")
        return node
    }()
    
    let searchButton: ASButtonNode = {
        let node = ASButtonNode()
        node.isUserInteractionEnabled = true
//        node.borderWidth = 1.0
//        node.borderColor = UIColor.black.cgColor
        node.style.width = ASDimensionMake("24pt")
        node.style.height = ASDimensionMake("24pt")
        node.setImage(#imageLiteral(resourceName: "SearchGlass"), for: .normal)
        return node
    }()
        
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(tabAnimation), name: Notification.Name("tabAnimation"), object: nil)
        
    }
    
    override func didLoad() {
        super.didLoad()
        discoverLabel.isSelected = true
        tabDot.isHidden = false
        followingDot.isHidden = true
    }
    
    @objc func tabAnimation(){
        selected = !selected
        discoverLabel.isSelected = !discoverLabel.isSelected
        //toggleAnimation()
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        if discoverLabel.isSelected {
            
            self.tabDot.isHidden = true
            self.followingDot.isHidden = false
            
        UIView.animate(withDuration: 0.0, animations: {
            
            self.discoverLabel.setAttributedTitle(NSAttributedString(string: "Discover", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
            self.followingLabel.setAttributedTitle(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
            self.tabDot.isHidden = false
            self.followingDot.isHidden = true
            
        }, completion: { finished in
            context.completeTransition(finished)
        })
            
      } else {
        
            self.tabDot.isHidden = false
            self.followingDot.isHidden = true
            
        UIView.animate(withDuration: 0.2, animations: {
            self.discoverLabel.setAttributedTitle(NSAttributedString(string: "Discover", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
            self.followingLabel.setAttributedTitle(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
            self.tabDot.isHidden = true
            self.followingDot.isHidden = false
        }, completion: { finished in
            context.completeTransition(finished)
        })
            
      }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let tabDotInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30), child: tabDot)
        
        let followingDotInset = ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 30, left: 32.5, bottom: 0, right: 32.5), child: followingDot)
        
        let followingDotInsetOverlay = ASOverlayLayoutSpec.init(child: followingLabel, overlay: followingDotInset)
        followingDotInsetOverlay.style.flexGrow = 1.0
        
        let tabDotInsetOverlay = ASOverlayLayoutSpec.init(child: discoverLabel, overlay: tabDotInset)
        tabDotInsetOverlay.style.flexGrow = 1.0
        
        let labelStack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 15, justifyContent: .center, alignItems: .center, children: [tabDotInsetOverlay, followingDotInsetOverlay])
        
        let navStack = ASStackLayoutSpec.init(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [labelStack, searchButton])
        navStack.style.flexGrow = 1.0
        navStack.style.width = ASDimensionMake("100%")
        
        let finalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [navStack])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15), child: finalStack)
    }
    
    
}
