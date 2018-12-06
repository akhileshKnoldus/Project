//
//  HomeViewC.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class HomeViewC: UIViewController {
    
    //MARK:-Propeties
    var tblData = [[String : AnyObject]]()
    var dataArr = [[String : AnyObject]]()
    
    //MARK:-IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNotification: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        
    }
    
    //MARK:-Private Method
    func registerNib()
    {
        let tblnib = UINib(nibName: "ResturantCell", bundle: nil)
        self.tableView.register(tblnib, forCellReuseIdentifier: "ResturantCell")
        let colNib = UINib(nibName: "BookingCell", bundle: nil)
        self.collectionView.register(colNib, forCellWithReuseIdentifier: "BookingCell")
        loadData()
        
    }
    func loadData()
    {
        let firstDict = ["title": "LOREIM TITLE SCG " as AnyObject, "subtitle": "LOREIM TITLE SCG" as AnyObject, "image": #imageLiteral(resourceName: "images-4") as AnyObject]
        let Dict2 = ["title": "Radinous Blue" as AnyObject, "subtitle": "Five star resturant" as AnyObject, "image": #imageLiteral(resourceName: "images-2") as AnyObject]
        let Dict3 = ["title": "Country In" as AnyObject, "subtitle": "Five star resturant" as AnyObject, "image": #imageLiteral(resourceName: "restra_two") as AnyObject]
        dataArr.append(contentsOf: [firstDict, Dict2, Dict3])
        let tblDict = ["resturant": "Paloma" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "restra_two") as AnyObject]
        let tblDict2 = ["resturant": "Lava" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "restra_one") as AnyObject]
        let tblDict3 = ["resturant": "Tea Lounge" as AnyObject, "offer": "20% off on Fodd Bill Valid only on Inhouse dining" as AnyObject, "image": #imageLiteral(resourceName: "images-2") as AnyObject]
        tblData.append(contentsOf: [tblDict, tblDict2, tblDict3])
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    
    func moveToOffer()
    {
        let offerSb = UIStoryboard(name: "Main", bundle: nil)
        if let offerView = offerSb.instantiateViewController(withIdentifier: "OfferViewC") as? OfferViewC
        {
            self.navigationController?.pushViewController(offerView, animated: true)
        }
    }
    func moveToBooking()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let bookingViewc = sb.instantiateViewController(withIdentifier: "TableBookDetailsViewC") as? TableBookDetailsViewC
        {
            self.navigationController?.pushViewController(bookingViewc, animated: true)
        }
    }
    
    //MARK:-IBAction
    @IBAction func tapSeeAll(_ sender: Any) {
        moveToOffer()
    }
    
    @IBAction func tapFavourate(_ sender: Any) {
        
    }
}

//MARK:- Extension
extension HomeViewC:UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,NextPageDeligate,BookNowDeligate
{
    //MARK:Protocal Method
    func btnNextClicked(cell: UITableViewCell) {
        
    }
    
    func btnBookNowClicked(cell: UICollectionViewCell) {
        moveToBooking()
    }
    
    
    //MARK:- Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ResturantCell", for: indexPath) as? ResturantCell
        {
            cell.nextPageDeligate = self
            let dict = tblData[indexPath.row]
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 146.0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCell" , for: indexPath) as? BookingCell
        {
            cell.bookNowDeligate = self
            let dict = dataArr[indexPath.row]
            if let title = dict["title"] as? String
            {
                cell.lblTitle.text = title
            }
            if let subtitle = dict["subtitle"] as? String
            {
                cell.lblSubTitle.text = subtitle
            }
            if let image = dict["image"] as? UIImage
            {
                cell.imgView.image = image
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 356, height: 294)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let bookingtTableViewC = sb.instantiateViewController(withIdentifier: "BookingTableViewC") as? BookingTableViewC
        {
            self.navigationController?.pushViewController(bookingtTableViewC, animated: true)
        }
    }
    
    
    
}
