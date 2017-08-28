//
//  CFMenuView.swift
//  CFPgaeControllerExample
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

protocol CFMenuViewDelegate: NSObjectProtocol {
    
    func didSelectedItemAtIndex(index: Int)
}

class CFMenuView: UIView {

    //lazy vars
    fileprivate lazy var contentView: UIScrollView = {
        let contentView = UIScrollView()
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        return contentView
    }()
    
    fileprivate lazy var markView: UIView = {
        let mark = UIView()
        mark.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return mark
    }()
    
    fileprivate lazy var shadow: UIView = {
        let shadow = UIView()
        shadow.backgroundColor = UIColor.init(white: 0.85, alpha: 1)
        return shadow
    }()
    
    //private vars
    fileprivate let titleMargin: CGFloat = 10
    fileprivate var titles: [String] = []
    fileprivate var menuItems: [CFMenuViewItem] = []
    fileprivate var selectedItem: CFMenuViewItem!
    
    //public vars
    weak var delegate: CFMenuViewDelegate?
    
    //public funcs
    public convenience init(titles: [String]) {
        self.init(frame: CGRect.zero)
        self.titles = titles
        addSubview(contentView)
        addMenuItems()
        self.addSubview(shadow)
    }
    
    public func sliderMenu(by progress: CGFloat, index: Int, translationX: CGFloat) {
        let fromItem = menuItems[translationX < 0 ? index : index + 1]
        let toItem = menuItems[translationX < 0 ? index + 1: index]
        fromItem.rate = translationX < 0 ? 1 - progress : progress
        toItem.rate = translationX < 0 ? progress : 1 - progress
    }
    
    public func refreshContentOffsetByEndDecelerating(with index: Int) {
        selectedItem = menuItems[index]
        resetContentOffset()
    }
    
    //private funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        print("menuView layoutSubviews")
        calculateFrames()
    }
    
    fileprivate func addMenuItems() {
        for (idx, title) in titles.enumerated() {
            let item = CFMenuViewItem(frame: CGRect.zero)
            item.text = title
            item.delegate = self
            menuItems.append(item)
            contentView.addSubview(item)
            if idx == 0 {
                selectedItem = item
                selectedItem.setMenuItemSelectionState(isSelected: true, animated: false)
            }

        }
    }
    
    fileprivate func calculateFrames() {
        for (idx, item) in menuItems.enumerated() {
            let size = item.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            let width = size.width + titleMargin * 2
            let height = size.height
            let titleFrame = CGRect(x: width * CGFloat(idx), y: (frame.height - height) / 2, width: width, height: height)
            menuItems[idx].frame = titleFrame
        }
        shadow.frame = CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1)
        contentView.frame = self.bounds
        contentView.contentSize = CGSize(width: menuItems.last!.frame.maxX, height: frame.height)
    }
    
    fileprivate func resetContentOffset() {
        let itemFrame = selectedItem.frame
        let itemX = itemFrame.minX
        let width = contentView.frame.width
        let contentSizeWidth = contentView.contentSize.width
        if itemX > width / 2 {
            var moveX = itemX - width / 2 + itemFrame.width / 2
            if contentSizeWidth - itemX < width / 2 {
                moveX = contentSizeWidth - width
            }
            contentView.setContentOffset(CGPoint(x: moveX, y: 0), animated: true)
        } else {
            contentView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

extension CFMenuView: CFMenuViewItemDelegate {
    
    func didSelectedMenuItem(menuItem: CFMenuViewItem) {
        if selectedItem == menuItem {
            return
        }
        delegate?.didSelectedItemAtIndex(index: menuItems.index(of: menuItem)!)
        menuItem.setMenuItemSelectionState(isSelected: true, animated: true)
        selectedItem.setMenuItemSelectionState(isSelected: false, animated: true)
        selectedItem = menuItem
        resetContentOffset()
    }

}
