//
//  CFPageTopBar.swift
//  CFPgaeControllerExample
//
//  Created by 曹飞 on 2018/4/4.
//  Copyright © 2018年 cf. All rights reserved.
//

import UIKit
import CoreGraphics

public class CateGoryButtonConfiguration {
    //public vars
    public var textFont: CGFloat = 15
    public var normalColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    public var selectedColor = #colorLiteral(red: 0.7450980392, green: 0.2117647059, blue: 0.1803921569, alpha: 1)
    public var scaleUp: CGFloat = 1.2
    
}

protocol CFPageTopBarDelegate : NSObjectProtocol {
    
    func pageTopBar(_ pageTopBar: CFPageTopBar, didSelectAt index: Int)
    
}

class CFPageTopBar: UIView {
    //private vars
    fileprivate lazy var themeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var barView: UIView = {
        let barView = UIView()
        return barView
    }()
    
    fileprivate lazy var naviBar: CFPageHomeNaviBar = {
        let navibar = CFPageHomeNaviBar()
        return navibar
    }()
    
    fileprivate lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        return separator
    }()
    
    fileprivate var categorySelectorView: CFPageCategorySelectorView
    
    public var titles: [String] {
        get {
            return []
        }
        set {
            categorySelectorView.titles = newValue
        }
    }
    
    public weak var delegate: CFPageTopBarDelegate?
    
    //override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 64)
        themeImageView.frame = barView.bounds
        naviBar.frame = CGRect(x: 0, y: 20, width: frame.width, height: 44)
        categorySelectorView.frame = CGRect(x: 0, y: 64, width: frame.width, height: 36)
        separator.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public funcs
    public init(cateGoryButtonConfiguration: CateGoryButtonConfiguration ,delegate: CFPageTopBarDelegate?) {
        categorySelectorView = CFPageCategorySelectorView(cateGoryButtonConfiguration: cateGoryButtonConfiguration)
        
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        categorySelectorView.pageTopBar = self
        initSubviews()
    }
    
    
    //private funcs
    fileprivate func initSubviews() {
        barView.addSubview(themeImageView)
        barView.addSubview(naviBar)
        self.addSubview(barView)
        self.addSubview(categorySelectorView)
        self.addSubview(separator)
    }
    
}

class CFPageHomeNaviButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let label = titleLabel, let imageView = imageView else { return }
        label.sizeToFit()
        let size = label.frame.size
        let img_w = frame.height - size.height - 2
        imageView.frame = CGRect(x: (frame.width - img_w) / 2, y: 0, width: img_w, height: img_w)
        label.center = CGPoint(x: frame.width / 2, y: frame.height - size.height / 2);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CFPageHomeNaviBar: UIView {
    //private vars
    fileprivate lazy var scanBtn: CFPageHomeNaviButton = {
        let scan = CFPageHomeNaviButton(type: UIButtonType.custom)
        scan.setImage(#imageLiteral(resourceName: "扫一扫"), for: UIControlState.normal)
        scan.setTitle("扫一扫", for: UIControlState.normal)
        return scan
    }()
    
    fileprivate lazy var messageBtn: CFPageHomeNaviButton = {
        let message = CFPageHomeNaviButton(type: UIButtonType.custom)
        message.setImage(#imageLiteral(resourceName: "消息"), for: UIControlState.normal)
        message.setTitle("消息", for: UIControlState.normal)
        return message
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        scanBtn.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        messageBtn.frame = CGRect(x: frame.width - 31 - 10, y: 7, width: 30, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubviews() {
        self.addSubview(scanBtn)
        self.addSubview(messageBtn)
    }
}

class CFPageCategorySelectorView: UIView {
    //private vars
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate var cateGoryButtonConfiguration: CateGoryButtonConfiguration
    fileprivate var categoryButtons: [CFPageCategorySelectorButton] = []
    fileprivate var lastButton: CFPageCategorySelectorButton?
    
    //public vars
    public var titles: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    public weak var pageTopBar: CFPageTopBar!
    
    //override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        var originX: CGFloat = 0
        for btn in categoryButtons {
            let origin = CGPoint(x: originX, y: 0)
            let size = CGSize(width: btn.textWidth + 20, height: frame.height)
            btn.frame = CGRect(origin: origin, size: size)
            originX += size.width
        }
        scrollView.contentSize = CGSize(width: originX, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //private funcs
    fileprivate func initSubviews() {
        for (idx, title) in titles.enumerated() {
            let btn = CFPageCategorySelectorButton(text: title, cateGoryButtonConfiguration: cateGoryButtonConfiguration)
            btn.addTarget(self, action: #selector(clickCategoryButton), for: .touchUpInside)
            btn.tag = idx + 1000
            
            if idx == 0 {
                btn.isSelected = true
                lastButton = btn
            }
            
            scrollView.addSubview(btn)
            categoryButtons.append(btn)
        }
        setNeedsLayout()
    }
    
    //public funcs
    public init(cateGoryButtonConfiguration: CateGoryButtonConfiguration) {
        self.cateGoryButtonConfiguration = cateGoryButtonConfiguration
        
        super.init(frame: CGRect.zero)
        
        self.addSubview(scrollView)
    }
    
    fileprivate func reloadData() {
        categoryButtons.removeAll()
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        initSubviews()
    }
    
    fileprivate func updateScrollViewContentOffset() {
        guard let button = lastButton else { return }
        let itemFrame = button.frame
        let itemX = itemFrame.minX
        let width = scrollView.frame.width
        let contentSizeWidth = scrollView.contentSize.width
        
        if itemX > width / 2 {
            var moveX = itemX - width / 2 + itemFrame.width / 2
            if contentSizeWidth - itemX < width / 2 {
                moveX = contentSizeWidth - width
            }
            scrollView.setContentOffset(CGPoint(x: moveX, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @objc fileprivate func clickCategoryButton(button: CFPageCategorySelectorButton) {
        if lastButton == button {
            return
        }
        button.isSelected = !button.isSelected
        if let lastbtn = lastButton {
            lastbtn.isSelected = false
        }
        lastButton = button
        updateScrollViewContentOffset()
        let index = button.tag - 1000
        pageTopBar.delegate?.pageTopBar(pageTopBar, didSelectAt: index)
    }
}

class CFPageCategorySelectorButton: UIControl {
    //public vars
    public var scaleUp: CGFloat
    public var textWidth: CGFloat {
        get {
            return titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        }
    }
    
    //private vars
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = self.text
        label.font = UIFont.systemFont(ofSize: self.textFont)
        label.textColor = self.normalTextColor
        return label
    }()
    
    fileprivate var text: String
    fileprivate var textFont: CGFloat
    fileprivate var normalTextColor: UIColor
    fileprivate var selectedTextColor: UIColor
    
    fileprivate var normalTextColorRGB: [CGFloat]? {
        get {
            return normalTextColor.cgColor.components
        }
    }
    
    fileprivate var selectedTextColorRGB: [CGFloat]? {
        get {
            return selectedTextColor.cgColor.components
        }
    }
    
    //override
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? selectedTextColor : normalTextColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public funcs
    init(text: String, cateGoryButtonConfiguration: CateGoryButtonConfiguration) {
        self.text = text
        textFont = cateGoryButtonConfiguration.textFont
        normalTextColor = cateGoryButtonConfiguration.normalColor
        selectedTextColor = cateGoryButtonConfiguration.selectedColor
        scaleUp = cateGoryButtonConfiguration.scaleUp
        
        super.init(frame: CGRect.zero)
        
        initSubviews()
    }
    
    //private funcs
    fileprivate func initSubviews() {
        self.addSubview(titleLabel)
    }
}


