//
//  UsageHistroyViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class UsageHistroyViewC: UIViewController {
    
    //MARK:- Properties
    
    //MARK:-  IBOutlet
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        regNib()
    }
    
    //MARK:- Private Method
    func regNib(){
        let nib = UINib(nibName: "UsageHistoryCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "UsageHistoryCell")
        
    }
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension
extension UsageHistroyViewC : UITableViewDelegate , UITableViewDataSource {
    
    //MARK:- Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "UsageHistoryCell", for: indexPath) as? UsageHistoryCell
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
