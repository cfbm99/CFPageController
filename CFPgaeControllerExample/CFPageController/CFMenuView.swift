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
    
    //private vars
    fileprivate let titleMargin: CGFloat = 10
    fileprivate var titles: [String] = []
    fileprivate var titleFrames: [CGRect] = []
    fileprivate var menuItems: [CFMenuViewItem] = []
    fileprivate var selectedItem: CFMenuViewItem!
    
    //public vars
    weak var delegate: CFMenuViewDelegate?
    
    //public funcs
    public convenience init(titles: [String]) {
        self.init(frame: CGRect.zero)
        self.titles = titles
        addContentView()
        addMenuItems()
    }
    
    public func sliderMenu(by progress: CGFloat) {
        
    }
    
    //private funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        print("menuView layoutSubviews")
        calculateFrames()
    }
    
    fileprivate func addContentView() {
        addSubview(contentView)
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
                selectedItem.selected = true
            }
        }
    }
    
    fileprivate func calculateFrames() {
        let label = UILabel()
        titleFrames.removeAll()
        for (idx, title) in titles.enumerated() {
            label.text = title
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            let width = size.width + titleMargin * 2
            let height = size.height
            let titleFrame = CGRect(x: width * CGFloat(idx), y: (frame.height - height) / 2, width: width, height: height)
            titleFrames.append(titleFrame)
            menuItems[idx].frame = titleFrame
        }
        contentView.frame = self.bounds
        contentView.contentSize = CGSize(width: titleFrames.last!.maxX, height: frame.height)
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
        selectedItem.selectWithAnimation(select: false)
        menuItem.selectWithAnimation(select: true)
        selectedItem = menuItem
        resetContentOffset()
    }

}
