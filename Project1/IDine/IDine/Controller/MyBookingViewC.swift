//
//  MyBookingViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class MyBookingViewC: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var segement: UISegmentedControl!
    @IBOutlet weak var btnBackArraow: UIButton!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Private Method
    func registerNib(){
        let nib = UINib(nibName: "BookingResturant", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "BookingResturant")
    }
    
    func moveToGeneratCode(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let generateCodeViewC = sb.instantiateViewController(withIdentifier: "GenerateCode") as? GenerateCode
        {
            self.navigationController?.pushViewController(generateCodeViewC, animated: true)
        }
    }
    
    func actionSheet(){
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Edit Details", style: .default)
        let saveAction = UIAlertAction(title: "Cancel Reservation", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tappedSegement(_ sender: Any) {
    }
    
    
    @IBAction func tapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension

extension MyBookingViewC : UITableViewDataSource , UITableViewDelegate , GenrateCodeDelegate{
   
    //MARK:- Protocal Method
    func getEditCode(cell: UITableViewCell) {
        actionSheet()
    }
    
    func getGenratedCode(cell: UITableViewCell) {
        moveToGeneratCode()
    }
    
    //MARK:- Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tblView.dequeueReusableCell(withIdentifier: "BookingResturant", for: indexPath) as? BookingResturant
        {
            cell.genrateCodeDelegate = self
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    
    
    
}
