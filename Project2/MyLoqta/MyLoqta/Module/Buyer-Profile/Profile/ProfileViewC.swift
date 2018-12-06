//
//  ProfileViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProfileViewC: BaseViewC {

    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var tblViewProfile: UITableView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var userImageBgView: UIView!
    
    
    var viewModel: ProfileVModeling?
    var arrayDataSource = [BuyerProfileType]()
    var user: User?
    var recentOrders = [Product]()
    var cellHeights: [IndexPath : CGFloat] = [:]
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.getMyProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.userImageBgView.roundCorners(self.userImageBgView.frame.size.width / 2)
        self.imgViewUser.roundCorners(self.imgViewUser.frame.size.width / 2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.navigationController?.presentTransparentNavigationBar()
        self.setupTableView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        var frame = self.viewHeader.frame
        frame.size.width = Constant.screenWidth
        frame.size.height = 185 * Constant.htRation
        self.viewHeader.frame = frame
        self.tblViewProfile.tableHeaderView = self.viewHeader
        self.initializeRefresh()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ProfileVM()
        }
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewProfile.refreshControl = refresh
    }
    
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.getMyProfile(isShowLoader: false)
    }
    
    private func setupTableView() {
        self.registerCell()
        self.tblViewProfile.allowsSelection = true
        self.tblViewProfile.separatorStyle = .none
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: 40.0))
        self.tblViewProfile.tableFooterView = view
    }
    
    private func registerCell () {
        self.tblViewProfile.register(ProfileDetailCell.self)
        self.tblViewProfile.register(MyOrderCell.self)
        self.tblViewProfile.register(UserProfileCell.self)
    }
    
    private func getMyProfile(isShowLoader: Bool = true) {
        self.viewModel?.requestGetMyProfile(isShowLoader: isShowLoader, completion: { [weak self] (user, orders) in
            guard let strongSelf = self else { return }
            strongSelf.user = user
            strongSelf.recentOrders = orders
            strongSelf.setProfileData()
            if let arrDataSourc = strongSelf.viewModel?.getDatasourceForProfile(orders: orders) {
                strongSelf.arrayDataSource = arrDataSourc
                strongSelf.tblViewProfile.reloadData()
            }
        })
    }
    
    private func setProfileData() {
        if let profileUrl = user?.profilePic, !profileUrl.isEmpty {
            self.imgViewUser.contentMode = .scaleAspectFill
            self.imgViewUser.setImage(urlStr: profileUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        } else {
            self.imgViewUser.contentMode = .scaleToFill
            self.imgViewUser.image = #imageLiteral(resourceName: "user_placeholder_circle")
        }
        if let coverUrl = user?.coverPic {
            self.imgViewBackground.setImage(urlStr: coverUrl, placeHolderImage: nil)
        }
    }
    
    func moveToMyLikesViewC() {
        if let myLikesViewC = DIConfigurator.sharedInst().getMyLikesVC() {
            self.navigationController?.pushViewController(myLikesViewC, animated: true)
        }
    }
    
    func moveToReviewsViewC() {
        if let reviewsViewC = DIConfigurator.sharedInst().getReviewsAboutBuyerViewC() {
            self.navigationController?.pushViewController(reviewsViewC, animated: true)
        }
    }
    
    func moveToMyCartViewC() {
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        if let myCartViewC = DIConfigurator.sharedInst().getMyCartVC() {
            let navC = UINavigationController(rootViewController: myCartViewC)
            myCartViewC.hidesBottomBarWhenPushed = true
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }

    // MARK: - IBAction functions
    @IBAction func tapCart(_ sender: Any) {
        self.moveToMyCartViewC()
    }
    
    @IBAction func tapSetting(_ sender: Any) {
        if let settingVC = DIConfigurator.sharedInst().getSettingsVC() {
            settingVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
    }
    
    @objc func tapMyOrder(_ sender: Any) {
        if let orderVC = DIConfigurator.sharedInst().getBuyerOrderListViewC() {
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
    }
}

extension ProfileViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 205.0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = self.arrayDataSource[indexPath.row].cellType
        switch cellType {
        case BuyerProfileCell.profileDetailCell.rawValue:
            return BuyerProfileCell.profileDetailCell.height
        case BuyerProfileCell.orderCell.rawValue:
            return BuyerProfileCell.orderCell.height
        default:
            return BuyerProfileCell.myLikeCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.arrayDataSource[indexPath.row].cellType
        switch cellType {
        case BuyerProfileCell.profileDetailCell.rawValue:
            return confiugureCellForProfile(tableView:tableView, indexPath:indexPath)
        case BuyerProfileCell.orderCell.rawValue:
            return configureCellForOrders(tableView:tableView, indexPath:indexPath)
        default:
            return configureCellForLikes(tableView:tableView, indexPath:indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ProfileViewC {
    func confiugureCellForProfile(tableView: UITableView, indexPath: IndexPath) -> ProfileDetailCell {
        let cell: ProfileDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(user: self.user)
        return cell
    }
    
    func configureCellForOrders(tableView: UITableView, indexPath: IndexPath) -> MyOrderCell {
        let cell: MyOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureView(self.recentOrders)
        cell.btnSeeAll.addTarget(self, action: #selector(tapMyOrder(_:)), for: .touchUpInside)
        return cell
    }
    
    func configureCellForLikes(tableView: UITableView, indexPath: IndexPath) -> UserProfileCell {
        let cell: UserProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let cellType = self.arrayDataSource[indexPath.row].cellType
        cell.configureCell(cellType: cellType)
        return cell
    }
}

//MARK:- OpenLikeReview Delegates
extension ProfileViewC: OpenLikeReviewViewDelegates {
    func didPerformActionOnLike() {
        self.moveToMyLikesViewC()
    }
    
    func didPerformActionOnReviews() {
        self.moveToReviewsViewC()
    }
}

extension ProfileViewC: MyOrderCellDelegate {
    func didTapOnTheOrder(product: Product) {
        if let itemId = product.orderDetailId, let itemStateVC = DIConfigurator.sharedInst().getOrderDetailVC() {
            itemStateVC.orderId = itemId
            self.navigationController?.pushViewController(itemStateVC, animated: true)
        }
    }
}


