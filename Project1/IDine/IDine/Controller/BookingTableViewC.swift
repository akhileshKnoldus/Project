//
//  BookingTableViewC.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class BookingTableViewC: UIViewController {
    //MARK:- Properties
    var dataArr = [[String : AnyObject]]()
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblResturantOpenTime: UILabel!
    @IBOutlet weak var lblResturantAddress: UILabel!
    @IBOutlet weak var lblResturantName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        
    }
    
    //MARK:- Private Method
    func registerNib()
    {
        let nib = UINib(nibName: "OfferCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "OfferCell")
        
        let tblNib = UINib(nibName: "BookingTableCell", bundle: nil)
        self.tblView.register(tblNib, forCellReuseIdentifier: "BookingTableCell")
        loadData()
    }
    
    func loadData()
    {
        let tblDict = ["resturant": "Coral" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage1") as AnyObject]
        let tblDict2 = ["resturant": "Mykonos" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage2") as AnyObject]
        let tblDict3 = ["resturant": "Tea Lounge" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage3") as AnyObject]
        dataArr.append(contentsOf: [tblDict, tblDict2, tblDict3])
        self.tblView.reloadData()
        self.collectionView.reloadData()
        
    }
    
    func moveToBooking()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let bookingViewc = sb.instantiateViewController(withIdentifier: "TableBookDetailsViewC") as? TableBookDetailsViewC
        {
            self.navigationController?.pushViewController(bookingViewc, animated: true)
        }
    }
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tapBookNow(_ sender: Any) {
        moveToBooking()
    }
    
    @IBAction func tapDownload(_ sender: Any) {
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension
extension BookingTableViewC: UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource
{
    //MARK:- Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblView.dequeueReusableCell(withIdentifier: "BookingTableCell", for: indexPath) as? BookingTableCell
        {
            return cell
        }
        return UITableViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCell", for: indexPath) as? OfferCell
        {
            
            let dict = dataArr[indexPath.row]
            if let name = dict["resturant"] as? String
            {
                cell.lblResturant.text = name
            }
            if let offer = dict["offer"] as? String
            {
                cell.lblOfferDescription.text = offer
            }
            if let image = dict["image"] as? UIImage
            {
                cell.imgView.image = image
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 518.0
    }
    
    //MARK:- Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 356, height: 152)
    }
}
