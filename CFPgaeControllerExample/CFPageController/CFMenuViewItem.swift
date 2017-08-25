//
//  CFMenuViewItem.swift
//  CFPgaeControllerExample
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

protocol CFMenuViewItemDelegate: NSObjectProtocol {
    
    func didSelectedMenuItem(menuItem: CFMenuViewItem)
}

class CFMenuViewItem: UILabel {

    //private vars
    fileprivate let normalFont: CGFloat = 15.0
    fileprivate let selectedFont: CGFloat = 18.0
    
    //public vars
    weak var delegate: CFMenuViewItemDelegate?
    public var selected: Bool = false {
        didSet {
           rate = selected ? 1 : 0
        }
    }
    
    public var rate: CGFloat = 0 {
        didSet {
            let scale = selectedFont / normalFont
            let rateScale = rate * (scale - 1) + 1
            transform = CGAffineTransform.init(scaleX: rateScale, y: rateScale)
        }
    }
    
    //public funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //private funcs
    fileprivate func setup() {
        font = UIFont.systemFont(ofSize: normalFont)
        textAlignment = .center
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didSelectedMenuItem(menuItem: self)
    }
    
    //public funcs
    public func selectWithAnimation(select: Bool) {
        UIView.animate(withDuration: 0.3) { 
            self.selected = select
        }
    }
    
}
