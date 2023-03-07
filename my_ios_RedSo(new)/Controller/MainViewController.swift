//
//  MainViewController.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var mainPageViewController = MainPageViewController()

    //MARK: - UI
    let titleLabelView:UILabel = {
        let labelView = UILabel()
        let attributedString = NSMutableAttributedString(string: "RedSo")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 3))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(3, 2))
        labelView.font = UIFont.systemFont(ofSize: 40)
        labelView.textAlignment = .center
        labelView.attributedText = attributedString
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        segmentedControl = UISegmentedControl()
        segmentedControl = UISegmentedControl(items: ["Rangers","Elastic","Dynamo"])
       
        segmentedControl.backgroundColor = UIColor.black
        segmentedControl.frame = CGRect.init(x: 0, y: 40, width: self.view.frame.width, height: 30)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupMainPageViewController()
        segmentedControl.addUnderlineForSelectedSegment()
        
    }
    
    //MARK: - setup UI
    private func setupUI() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(mainPageViewController.view)
        mainPageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }

        mainPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func setupMainPageViewController() {
        self.addChild(mainPageViewController)
        mainPageViewController.isEditing = true
        mainPageViewController.dataSource = self
        mainPageViewController.setViewControllers([mainPageViewController.tableViewControllerArr[0]], direction: .forward, animated: false)
        
    }

    private func setupNavigation(){
        navigationItem.titleView = titleLabelView
    }
    
    //處理UISegmentedControl翻頁控制
    @objc func segmentedChange(sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
        mainPageViewController.setViewControllers([mainPageViewController.tableViewControllerArr[sender.selectedSegmentIndex]], direction: .forward, animated: false)
    }
}

//MARK: - MainViewControllerDelegate
extension MainViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.mainPageViewController.tableViewControllerArr.firstIndex(of: viewControllers[0] as! UITableViewController) {
                self.segmentedControl.selectedSegmentIndex = viewControllerIndex
            }
        }
    }
    
}

//MARK: - MainViewControllerDataSource
extension MainViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        mainPageViewController.selectedIndex = viewController.view.tag
        segmentedControl.selectedSegmentIndex = mainPageViewController.selectedIndex
        let pageIndex = viewController.view.tag - 1
        if pageIndex < 0 { return nil }
        
        return mainPageViewController.tableViewControllerArr[pageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        mainPageViewController.selectedIndex = viewController.view.tag
        segmentedControl.selectedSegmentIndex = mainPageViewController.selectedIndex
        let pageIndex = viewController.view.tag + 1
        if pageIndex > 2 { return nil }
        
        return mainPageViewController.tableViewControllerArr[pageIndex]
    }
}

//MARK: - UISegmentedControl extension
extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.black.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.black.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }

    func addUnderlineForSelectedSegment() {
        removeBorder()
        
        let underlineWidth: CGFloat = (self.bounds.size.width / CGFloat(self.numberOfSegments))
        let underlineHeight: CGFloat = 5.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 5.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.red//(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
}
