//
//  CFPageController.swift
//  CFPgaeControllerExample
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CFPageController: UIViewController {
    
    //lazy vars
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.delegate = self
        return scroll
    }()
    
    fileprivate lazy var menuView: CFMenuView = {
        let menuView = CFMenuView(titles: self.titles)
        menuView.delegate = self
        return menuView
    }()
    
    //private vars
    fileprivate var titles: [String] = []
    fileprivate var viewControllers: [UIViewController] = []
    fileprivate var childVcViewFrames: [CGRect] = []
    fileprivate let menuViewHeight: CGFloat = 44
    fileprivate var currentViewController: UIViewController?
    fileprivate var selectedIndex: Int = 0
    fileprivate var hasInit: Bool = false
    
    //life cycle
    public convenience init(viewControllers: [UIViewController], titles: [String]) {
        self.init()
        self.viewControllers = viewControllers
        self.titles = titles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard viewControllers.count == titles.count && viewControllers.count > 0 else {
            fatalError("viewControllers.count != titles.count or viewControllers.count !> 0")
        }
        view.backgroundColor = UIColor.white
        addScrollView()
        addMenuView()
        calculateFrames()
        addViewControllerAtIndex(0)
        currentViewController = viewControllers[selectedIndex]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard viewControllers.count == titles.count && viewControllers.count > 0 else {
            fatalError("viewControllers.count != titles.count or viewControllers.count !> 0")
        }
        guard !hasInit else {
            return
        }
        calculateFrames()
        currentViewController?.view.frame = childVcViewFrames[selectedIndex]
        hasInit = true
        print("did layout subviews")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //private funcs
    fileprivate func addScrollView() {
        view.addSubview(scrollView)
    }
    
    fileprivate func addMenuView() {
        view.addSubview(menuView)
    }
    
    fileprivate func calculateFrames() {
        let width = view.bounds.width
        let height = view.bounds.height - menuViewHeight - 20
        menuView.frame = CGRect(x: 0, y: 20, width: width, height: menuViewHeight)
        scrollView.frame = CGRect(x: 0, y: menuViewHeight + 20, width: width, height: height)
        scrollView.contentSize = CGSize(width: width * CGFloat(viewControllers.count), height: height)
        childVcViewFrames.removeAll()
        for index in 0 ..< viewControllers.count {
            var vcFrame = scrollView.bounds
            vcFrame.origin.x = CGFloat(index) * width
            childVcViewFrames.append(vcFrame)
        }
    }
    
    fileprivate func addViewControllerAtIndex(_ index: Int) {
        currentViewController = viewControllers[index]
        if viewControllers[index].isViewLoaded {
            return
        }
        let vc = viewControllers[index]
        addChildViewController(vc)
        vc.view.frame = childVcViewFrames[index]
        scrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}

extension CFPageController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuView.sliderMenu(by: scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        addViewControllerAtIndex(selectedIndex)
    }
    
}

extension CFPageController: CFMenuViewDelegate {
    
    func didSelectedItemAtIndex(index: Int) {
        selectedIndex = index
        addViewControllerAtIndex(selectedIndex)
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.frame.width, y: 0), animated: false)
    }
}
