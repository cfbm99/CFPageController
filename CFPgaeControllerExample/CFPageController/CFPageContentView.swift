//
//  CFPageContentView.swift
//  CFPgaeControllerExample
//
//  Created by 曹飞 on 2018/4/10.
//  Copyright © 2018年 cf. All rights reserved.
//

import UIKit

class CFPageContentView: UIView {
    //public vars

    //private vars
    fileprivate let loadingViewTag = 1000
    fileprivate var childViewControllers = [UIViewController]()
    fileprivate weak var parentViewController: UIViewController!
    fileprivate var loadingViews: [UIView] = []
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll: UIScrollView = UIScrollView()
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.alwaysBounceHorizontal = false
        scroll.delegate = self
        return scroll
    }()
    
    //override
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public funcs
    public func reloadViewControllers(parentViewController: UIViewController, childViewControllers: [UIViewController]) {
        self.parentViewController = parentViewController
        self.childViewControllers = childViewControllers
        
        addLoadingViews()
    }
    
    public func scroll(at index: Int) {
        let offsetX = CGFloat(index) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    //private funcs
    fileprivate func initSubviews() {
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
    }
    
    fileprivate func addLoadingViews() {
        loadingViews.removeAll()
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        for idx in 0 ..< childViewControllers.count {
            var rect = self.bounds
            rect.origin.x = CGFloat(idx) * rect.width
            
            let view = UIView(frame: rect)
            
            let label = UILabel()
            label.text = "第\(idx)页loadingView"
            label.sizeToFit()
            label.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            view.addSubview(label)
            
            scrollView.addSubview(view)
            loadingViews.append(view)
        }
        scrollView.contentSize = CGSize(width: CGFloat(childViewControllers.count) * frame.width, height: frame.height)
        addChildViewController(by: 0)
    }
    
    fileprivate func addChildViewController(by index: Int) {
        let vc = childViewControllers[index]
        if vc.isViewLoaded { return }
        parentViewController.addChildViewController(vc)
        let loadingView = loadingViews[index]
        vc.view.frame = loadingView.bounds
        loadingView.addSubview(vc.view)
        vc.didMove(toParentViewController: parentViewController)
    }
}

extension CFPageContentView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        addChildViewController(by: index)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        addChildViewController(by: index)
    }
}
