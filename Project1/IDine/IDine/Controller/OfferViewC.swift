//
//  OfferViewC.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class OfferViewC: UIViewController {
    
    //MARK:- Properties
    var dataArr = [[String : AnyObject]]()
    
    //MARK:- IBAction
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblofferView: UITableView!
    
    //MARKL:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        
    }
    
    //MARK:- Private Method
    func registerNib()
    {
        let tblnib = UINib(nibName: "ResturantCell", bundle: nil)
        self.tblofferView.register(tblnib, forCellReuseIdentifier: "ResturantCell")
        
        loadData()
        
    }
    func loadData()
    {
        let tblDict = ["resturant": "Paloma" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage1") as AnyObject]
        let tblDict2 = ["resturant": "Lava" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage2") as AnyObject]
        let tblDict3 = ["resturant": "Tea Lounge" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage3") as AnyObject]
        dataArr.append(contentsOf: [tblDict, tblDict2, tblDict3])
        self.tblofferView.reloadData()
        
    }
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:- Extension
extension OfferViewC: UITableViewDataSource,UITableViewDelegate,NextPageDeligate
{
    //MARK:- Protocal Method
    func btnNextClicked(cell: UITableViewCell) {
        
    }
    
    //MARK:- Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 146.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblofferView.dequeueReusableCell(withIdentifier: "ResturantCell", for: indexPath) as? ResturantCell
        {
            cell.nextPageDeligate = self
            let dict = dataArr[indexPath.row]
            if let name = dict["resturant"] as? String
            {
                cell.lblResturantName.text = name
            }
            if let offer = dict["offer"] as? String
            {
                cell.lblOffer.text = offer
            }
            if let image = dict["image"] as? UIImage
            {
                cell.imgView.image = image
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
}
