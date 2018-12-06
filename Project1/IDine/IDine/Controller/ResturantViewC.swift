//
//  ResturantViewC.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class ResturantViewC: UIViewController {
    
    //MARK:-Properties
    var dataArr = [[String : AnyObject]]()
    var myArray = [[String : AnyObject]]()
    
    //MARK:-IBOutlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:-Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        registerNib()
        myArray = dataArr
        
    }
    
    //MARK:- Private Method
    func registerNib()
    {
        let tblnib = UINib(nibName: "ResturantSearchCell", bundle: nil)
        self.tblView.register(tblnib, forCellReuseIdentifier: "ResturantSearchCell")
        loadData()
    }
    func loadData()
    {
        let tblDict = ["resturant": "Coral" as AnyObject, "address": "IHG DOHA" as AnyObject, "image": #imageLiteral(resourceName: "restra_two") as AnyObject]
        let tblDict2 = ["resturant": "Mykonos" as AnyObject, "address": "IHG DOHA" as AnyObject, "image": #imageLiteral(resourceName: "restra_one") as AnyObject]
        let tblDict3 = ["resturant": "Tea Lounge" as AnyObject, "address": "New Delhi" as AnyObject, "image": #imageLiteral(resourceName: "images-4") as AnyObject]
        dataArr.append(contentsOf: [tblDict, tblDict2, tblDict3])
        self.tblView.reloadData()
        
    }
    
    //MARK:-Public Method
    
    //MARK:- IBAction
    
    
}

//MARK:- Extension
extension ResturantViewC:  UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ResturantSearchDeligate
{
    //MARK:- Protocal Method
    
    func btnItalianClicked(cell: UITableViewCell) {
        
    }
    
    func btnChineseClicked(cell: UITableViewCell) {
        
    }
    
    //MARK:- Table View  Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tblView.dequeueReusableCell(withIdentifier: "ResturantSearchCell", for: indexPath) as? ResturantSearchCell
        {
            cell.resturantSearchDeligate = self
            let dict = myArray[indexPath.row]
            if let name = dict["resturant"] as? String
            {
                cell.lblResturantName.text = name
            }
            if let address = dict["address"] as? String
            {
                cell.lblResturantAddress.text = address
            }
            if let image = dict["image"] as? UIImage
            {
                cell.imgView.image = image
            }
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewC = sb.instantiateViewController(withIdentifier: "BookingTableViewC") as? BookingTableViewC
        {
            self.navigationController?.pushViewController(viewC, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 318.0
    }
    
    
    //MARK:- Search Delegate Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myArray.removeAll()
        tblView.reloadData()
        let searchStr = searchText.lowercased()
        
        if searchStr.isEmpty {
            myArray.append(contentsOf: dataArr)
            tblView.reloadData()
            return
        }
        
        let resturant = dataArr.filter { (myDict) -> Bool in
            if let resturant = myDict["resturant"]?.lowercased, let address = myDict["address"]?.lowercased {
                if resturant.contains(searchStr) || address.contains(searchStr)  {
                    
                    return true
                }
            }
            return false
        }
        myArray.append(contentsOf: resturant)
        tblView.reloadData()
        
    }
}
