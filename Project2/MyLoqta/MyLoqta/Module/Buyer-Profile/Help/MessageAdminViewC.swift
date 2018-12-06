//
//  MessageAdminViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class MessageAdminViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var tblViewMessage: UITableView!
    @IBOutlet weak var btnSend: AVButton!
    
    //MARK: - Variables
    var viewModel: MessageAdminVModeling?
    var arraySubject = [[String: Any]]()
    var strSubject = ""
    var strMessage = ""
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        self.checkSendButton()
        self.getSubjectList()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = MessageAdminVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewMessage.separatorStyle = .none
        self.tblViewMessage.dataSource = self
        self.tblViewMessage.delegate = self
    }
    
    private func registerCell() {
        self.tblViewMessage.register(RejectReasonCell.self)
        self.tblViewMessage.register(MessageTableCell.self)
    }
    
    private func checkSendButton() {
        if !self.strSubject.isEmpty && !self.strMessage.isEmpty {
            self.btnSend.isButtonActive = true
        } else {
            self.btnSend.isButtonActive = false
        }
    }
    
    private func validateData() -> Bool {
        var isValid = true
        if self.strSubject.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select subject".localize())
            isValid = false
        } else if self.strMessage.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter your message".localize())
            isValid = false
        }
        return isValid
    }
    
    //MARK: - API Methods
    private func getSubjectList() {
        self.viewModel?.requestGetSubjectList(completion: {[weak self] (arraySubject) in
            guard let strongSelf = self else { return }
            strongSelf.arraySubject = arraySubject
        })
    }
    
    private func sendEmail() {
        if self.validateData() {
            let param = ["subject": self.strSubject as AnyObject, "message": self.strMessage as AnyObject]
            self.viewModel?.requestSendEmail(param: param, completion: {[weak self] (success) in
                guard let strongSelf = self else { return }
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Email has been sent".localize(), completeion_: { (success) in
                    strongSelf.navigationController?.popViewController(animated: true)
                })
            })
        }
    }
    
    //MARK: - Public Methods
    func showSubjectPopup() {
        if self.arraySubject.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select subject".localize(), arrayList: self.arraySubject as [[String : AnyObject]], keyValue: "subject") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let subjectText = result["subject"] as? String {
                    strongSelf.strSubject = subjectText
                    strongSelf.checkSendButton()
                    strongSelf.tblViewMessage.reloadData()
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapSendMessage(_ sender: UIButton) {
        self.sendEmail()
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSourceAndDelegates
extension MessageAdminViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getMessageSubjectCell(tableView, indexPath:indexPath)
        case 1:
            return getMessageDescriptionCell(tableView, indexPath:indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func getMessageSubjectCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: RejectReasonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let placeholder = "Select subject".localize()
        cell.configureView(placeholder: placeholder, reason: self.strSubject)
        return cell
    }
    
    private func getMessageDescriptionCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let placeholder = "Your message".localize()
        cell.configureView(placeholder: placeholder, value: self.strMessage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.showSubjectPopup()
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 55.0
        default:
            return 90.0
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if self.strSubject.isEmpty {
                return 55.0
            }
            return UITableViewAutomaticDimension
        default:
            if self.strMessage.isEmpty {
                return 57
            }
            return UITableViewAutomaticDimension
        }
    }
}

extension MessageAdminViewC: MessageTableCellDelegate {
    func updateHeightOfRow(_ cell: MessageTableCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tblViewMessage.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tblViewMessage.beginUpdates()
            tblViewMessage.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        if let text = textView.text {
            self.strMessage = text
            self.checkSendButton()
        }
    }
}
