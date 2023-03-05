//
//  MainPageViewController.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation
import UIKit

class MainPageViewController: UIPageViewController {
    
    var selectedIndex: Int = 0
    var tableViewControllerArr: [UITableViewController] = []
    private var pageCategorys:[String] = ["rangers","elastic","dynamo"] //之後可以改為需填入的參數
 
    //MARK: - Init
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewControllerArr(){
        for category in pageCategorys {
            tableViewControllerArr.append(InformationTableViewContoller(teamCategory: category))
            tableViewControllerArr.last?.view.tag = tableViewControllerArr.count - 1
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViewControllerArr()
  
    }
    
    
}
