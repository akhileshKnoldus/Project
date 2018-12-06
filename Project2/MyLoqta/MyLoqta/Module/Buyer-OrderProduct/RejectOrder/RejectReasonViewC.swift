//
//  RejectReasonViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol RejectReasonDelegate: class {
    func didRejectOrder()
}

class RejectReasonViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewReject: UITableView!
    
    //MARK: - Variables
    weak var delegate: RejectReasonDelegate?
    var viewModel: RejectReasonVModeling?
    var arrReasons = [[String: Any]]()
    var strReason = ""
    var strDescription = ""
    var reasonId = 0
    var isShowDescription = false
    var orderDetailId = 0


    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        self.getRejectReasons()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = RejectReasonVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewReject.separatorStyle = .none
        self.tblViewReject.dataSource = self
        self.tblViewReject.delegate = self
    }
    
    private func registerCell() {
        self.tblViewReject.register(RejectReasonCell.self)
        self.tblViewReject.register(ProfileDescriptionCell.self)
    }
    
    private func setupDescription(reasonId: Int) {
        if reasonId == 0 {
            self.isShowDescription = true
        } else {
            self.isShowDescription = false
        }
    }
    
    private func validateReasonData() -> Bool {
        var isValid = true
        if self.reasonId == 0 {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select the reason for rejection.".localize())
            isValid = false
        } else if self.reasonId == self.arrReasons.count && self.strDescription.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter few words about rejection.".localize())
            isValid = false
        }
        return isValid
    }
    
    //MARK:- API Methods
    private func getRejectReasons() {
        self.viewModel?.requestGetRejectReasons(completion: {[weak self] (arrayReasons) in
            guard let strongSelf = self else { return }
            strongSelf.arrReasons.append(contentsOf: arrayReasons)
        })
    }
    
    private func postRejectReason() {
        if self.validateReasonData() {
            self.viewModel?.requestToRejectOrder(orderDetailId: self.orderDetailId, rejectId: self.reasonId, rejectReason: self.strDescription, completion:{[weak self] (success) in
                guard let strongSelf = self else { return }
                if success, let delegate = strongSelf.delegate {
                    delegate.didRejectOrder()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    //MARK: - Public Methods
    func showReasonPopup() {
        if self.arrReasons.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select the reason".localize(), arrayList: self.arrReasons as [[String : AnyObject]], keyValue: "rejectReason") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let reason = result["rejectReason"] as? String, let reasonId = result["reasonId"] as? Int {
                    strongSelf.strReason = reason
                    strongSelf.reasonId = reasonId
                    strongSelf.setupDescription(reasonId: reasonId)
                    strongSelf.tblViewReject.reloadData()
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendRejectReason(_ sender: UIButton) {
        self.postRejectReason()
    }
}

extension RejectReasonViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 55.0
        default:
            return 90.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        default:
            return 90.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isShowDescription ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getReasonCell(tableView, indexPath: indexPath)
        default:
            return getDescriptionCell(tableView, indexPath: indexPath)
        }
    }
    
    func getReasonCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: RejectReasonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let placeholder = "Select the reason of rejection".localize()
        cell.configureView(placeholder:placeholder, reason: self.strReason)
        return cell
    }
    
    private func getDescriptionCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.lblTitle.text = "Tell a few words about item".localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.showReasonPopup()
        }
    }
}

extension RejectReasonViewC: ProfileDescriptionCellDelegate {
    func textDidChange(_ text: String) {
        self.strDescription = text
    }
}
