//
//  InformationTableViewContoller.swift
//  my_ios_RedSo(new)
//
//  Created by 危末狂龍 on 2023/3/5.
//

import Foundation
import UIKit

class InformationTableViewContoller: UITableViewController {
    
    private var teamCategory: String
    private var cellDatas: [CellData] = []
    private var page: Int = 0
    private var isLoading = false
    private var dataDone = false
    
    //MARK: - UI
    lazy var refreshControlView: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
        ]
        refreshControl.tintColor = .white
        refreshControl.backgroundColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes:attributes)

        refreshControl.translatesAutoresizingMaskIntoConstraints = true
        refreshControl.addTarget(self, action: #selector(refreshdData), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - init
   init(teamCategory: String) {
       self.teamCategory = teamCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.addSubview(refreshControlView)
        
        tableView.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.identifier)
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: BannerTableViewCell.identifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        
        Task {
            await populateCellDatas()
            tableView.reloadData()
        }
    }
    
    private func populateCellDatas() async {
        do {
            cellDatas += try await  StoreHTTPClient.getData(team: teamCategory, page: page)
            print("Done")
        } catch {
            print("fail to get cellDatas!")
        }
    }
    
    @objc func refreshdData(){
        Task {
            do {
                //重置cellDatas為更新後狀態
                cellDatas = try await  StoreHTTPClient.getData(team: teamCategory, page: 0)
                //回歸tableView到初始參數
                DispatchQueue.main.async {
                    self.page = 0
                    self.dataDone = false
                    self.isLoading = false
                    self.refreshControlView.endRefreshing()
                    self.tableView.reloadData()
                }
            } catch {
                print("fail to reloadData!")
            }
        }
    }
    
    private func loadMoreData()  {
        if !self.isLoading {
            self.isLoading = true
            Task {
                do {
                    let nextPageCellData = try await  StoreHTTPClient.getData(team: teamCategory, page: page + 1)
                    if  nextPageCellData.isEmpty {
                        self.isLoading = false
                        self.dataDone = true
                        self.tableView.reloadData()
                        print("No more data!")
                    } else {
                        cellDatas += nextPageCellData
                        DispatchQueue.main.async {
                            self.page += 1
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Fail to loadMoreData!")
                }
            }
        }
    }
    
    //MARK: tableview設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return cellDatas.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if dataDone {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            

            let cellData = cellDatas[indexPath.row]
            guard let cellType = CellType(rawValue: cellData.type)   else { return UITableViewCell() }

            //依cellType來決定cell佈局
            switch cellType {
            case .employee:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(InformationTableViewCell.self)", for: indexPath) as? InformationTableViewCell else { return UITableViewCell() }
                cell.avatarImageView.image = nil
                setupCellTypeEmployee(cell: cell , cellData: cellData)
                return cell
            case .banner:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BannerTableViewCell.self)", for: indexPath) as? BannerTableViewCell else { return UITableViewCell() }
                cell.bannerImagerView.image = nil
                setupCellTypeBanner(cell: cell, cellData: cellData)
                return cell
            }
            
            
        } else {
            //設置LoadingTableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(LoadingTableViewCell.self)", for: indexPath) as? LoadingTableViewCell else { return UITableViewCell() }

            cell.activityIndicatorView.startAnimating()

            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {

            let cellData = cellDatas[indexPath.row]
            guard let cellType = CellType(rawValue: cellData.type )   else { return 150 }
            switch cellType {
            case .employee:
                return 150
            case .banner:
                return UITableView.automaticDimension
            }
        } else {
            return 55
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {

            let cellData = cellDatas[indexPath.row]
            guard let cellType = CellType(rawValue: cellData.type )   else { return 150 }
            switch cellType {
            case .employee:
                return 150
            case .banner:
                return UITableView.automaticDimension
            }
        } else {
            return 55
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)  {
        
        if indexPath.row == cellDatas.count - 1 , !isLoading , !dataDone {
            loadMoreData()
        }
        
    }
}

//MARK: tableviewCell 資料匯入
extension InformationTableViewContoller {
    
    enum CellType:String {
        case employee = "employee",banner = "banner"
    }
    
    func setupCellTypeEmployee (cell: InformationTableViewCell ,cellData: CellData ) {
        
        let expertiseLabelText = (cellData.expertise )!.joined(separator: ", ")
        
        cell.backgroundColor = UIColor.black

        cell.TypeEmployeeSutupUI()
        cell.nameLabel.text = cellData.name
        cell.nameLabel.textColor = UIColor.white
        cell.positionLabel.text = cellData.position
        cell.positionLabel.textColor = UIColor.white
        cell.expertiseLabel.text = expertiseLabelText
        cell.expertiseLabel.textColor = UIColor.white
        
        if let url = URL(string: cellData.avatar! ) {
            DispatchQueue.global().async {
                if let data = try?Data(contentsOf: url ) {
                    DispatchQueue.main.async {
                        
                        let image = UIImage(data: data)
                        cell.avatarImageView.image = image
                        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height/2
                        cell.avatarImageView.layer.masksToBounds = true
                        cell.avatarImageView.backgroundColor = UIColor.black
                        cell.avatarImageView.layer.borderWidth = 3.0
                        cell.avatarImageView.layer.borderColor = UIColor.red.cgColor
                    }
                }
            }
        }
    }
    
    func setupCellTypeBanner (cell: BannerTableViewCell ,cellData: CellData ) {
        
        cell.backgroundColor = UIColor.black
        cell.TypeBannerSutupUI()
        
        
        if let url = URL(string: cellData.url! ) {
            DispatchQueue.global().async {
                if let data = try?Data(contentsOf: url ) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.bannerImagerView.image = image
                        cell.bannerImagerView.backgroundColor = .black
                        cell.bannerImagerView.clipsToBounds = true

                    }
                }
                
            }
        }
    }
    
}
