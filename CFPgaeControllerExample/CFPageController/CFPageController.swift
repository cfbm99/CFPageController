//
//  CFPageController.swift
//  CFPgaeControllerExample
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CFPageController: UIViewController {
    
    //private vars
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    fileprivate lazy var topBar: CFPageTopBar = {
        let configuration = CateGoryButtonConfiguration()
        let topBar = CFPageTopBar(cateGoryButtonConfiguration: configuration, delegate: self)
        return topBar
    }()
    
    fileprivate lazy var pageContentView: CFPageContentView = {
        let content = CFPageContentView()
        return content
    }()
    
    fileprivate var childVcViewFrames: [CGRect] = []
    fileprivate let menuViewHeight: CGFloat = 44
    fileprivate var currentViewController: UIViewController?
    fileprivate var selectedIndex: Int = 0
    fileprivate var hasInit: Bool = false
    
    //public vars
    public var titles: [String] = []
    public var viewControllers: [UIViewController] = []
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initSubviews()
        setTitlesAndViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //public funcs
    public func setTitlesAndViewControllers() {
        let titles = ["推荐", "新品", "众筹", "福利社", "限时购", "居家", "配件", "服装", "电器", "洗护", "饮食", "餐厨"]
        let vcs = titles.map { (_) -> UIViewController in
            return ViewController()
        }
        
        self.titles = titles
        viewControllers = vcs
        
        reloadData()
    }
    
    public func reloadData() {
        topBar.titles = titles
        pageContentView.reloadViewControllers(parentViewController: self, childViewControllers: viewControllers)
    }
    
    //private funcs
    fileprivate func initSubviews() {
        view.addSubview(topBar)
        view.addSubview(contentView)
        contentView.addSubview(pageContentView)
        
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        let rect = UIScreen.main.bounds
        topBar.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.width, height: 100))
        contentView.frame = CGRect(x: 0, y: 100, width: rect.width, height: rect.height - 100)
        pageContentView.frame = contentView.bounds
    }
    
}

extension CFPageController : CFPageTopBarDelegate {
    
    func pageTopBar(_ pageTopBar: CFPageTopBar, didSelectAt index: Int) {
        pageContentView.scroll(at: index)
    }
    
    
}

//extension CFPageController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) == 0 || scrollView.contentOffset.x > (scrollView.contentSize.width - scrollView.frame.width) || scrollView.contentOffset.x < 0 {
//            return
//        }
//        let progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
//        let translationX = scrollView.panGestureRecognizer.translation(in: scrollView).x
//        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        menuView.sliderMenu(by: progress, index: index, translationX: translationX)
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        selectedIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
//        addViewControllerAtIndex(selectedIndex)
//        menuView.refreshContentOffsetByEndDecelerating(with: selectedIndex)
//    }
//
//}
//
//extension CFPageController: CFMenuViewDelegate {
//
//    func didSelectedItemAtIndex(index: Int) {
//        selectedIndex = index
//        addViewControllerAtIndex(selectedIndex)
//        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.frame.width, y: 0), animated: false)
//    }
//}
