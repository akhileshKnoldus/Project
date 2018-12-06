//
//  SingupViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class SignupViewC: BaseViewC {

    @IBOutlet weak var cnstBottomBtnNext: NSLayoutConstraint!
    @IBOutlet weak var tblSignup: TPKeyboardAvoidingTableView!
    @IBOutlet weak var btnNext: AVButton!
    var viewModel: SignupVModeling?
    var arrayData = [[String: String]]()
    let bottomHt = CGFloat(20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //self.removeKeyboardNotifications()
    }
    
    // MARK: - Private functions
    
    private func setup() {
        self.recheckVM()
        self.registerNib()
        if let array = self.viewModel?.getDataSource() {
            self.arrayData.append(contentsOf: array)
        }
        
        self.tblSignup.reloadData()
        self.btnNext.setTitle("Next".localize(), for: .normal)
        //self.registerKeyboardNotifications()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SignupVM()
        }
    }
    
    private func registerNib () {
        self.tblSignup.register(CreateProfileCell.self)
        self.tblSignup.register(NameCell.self)
        self.tblSignup.register(ProfileCell.self)
    }
    
    // MARK: - IBAction functions

    @IBAction func tapCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: Any) {
        self.view.endEditing(true)
        if let viewModel = viewModel, viewModel.validateData(self.arrayData) {
            self.viewModel?.requestToSignup(self.arrayData, socialMedium: 0, socialId: "", role: userRole.buyer.rawValue, completion: { (response) in
                print(response)
                if let termCondVC = DIConfigurator.sharedInst().getTermsAndCondVC() {
                    self.navigationController?.pushViewController(termCondVC, animated: true)
                }
            })
        }
    }
    
    
    /*
    // MARK: - Notifications
    private func registerKeyboardNotifications() {
        //Adding noti. on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardDidShow(notification: NSNotification) {
        Threads.performTaskInMainQueue {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            if let height = keyboardSize?.height {
                self.cnstBottomBtnNext.constant = height
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.cnstBottomBtnNext.constant = bottomHt
        self.view.updateConstraintsIfNeeded()
    }*/
}

extension SignupViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: CreateProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(data: self.arrayData[indexPath.row])
            return cell
        case 1:
            let cell: NameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(data: self.arrayData[indexPath.row])
            cell.weakDelegate = self
            return cell
        default:
            let cell: ProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(data: self.arrayData[indexPath.row], indexPath: indexPath)
            cell.weakDelegate = self
            return cell
        }
    }
}

extension SignupViewC: NameCellDelegate {
    
    func tapNexKeyboard(cell: UITableViewCell) {
        if var indexPath = self.tblSignup.indexPath(for: cell) {
            indexPath.row += 1
            if let cell = self.tblSignup.cellForRow(at: indexPath) as? ProfileCell {
                cell.txtFieldProfile.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        }
    }
    
    
    func updateProfileData(cell: UITableViewCell, text: String) {
        if let index = self.tblSignup.indexPath(for: cell) {
            self.arrayData[index.row][Constant.keys.kValue] = text
            self.tblSignup.beginUpdates()
            self.tblSignup.endUpdates()
        }
    }
    
    func updateName(text: String, isFirstName: Bool) {
        if isFirstName {
            self.arrayData[1][Constant.keys.kFirstNameV] = text
        } else {
            self.arrayData[1][Constant.keys.kLastNameV] = text
        }
    }
    
}
