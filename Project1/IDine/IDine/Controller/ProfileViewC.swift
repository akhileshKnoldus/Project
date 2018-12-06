//
//  ProfileViewC.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class ProfileViewC: UIViewController {
    var dataArr = [[String : AnyObject]]()
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
         loadData()
    }
    func registerNib()
    {
        let tblnib = UINib(nibName: "ProfileCell", bundle: nil)
        self.tblView.register(tblnib, forCellReuseIdentifier: "ProfileCell")
        
        
       
        
    }
    func loadData()
    {
        let tblDict = ["Heading": "My Bookings" as AnyObject, "image": #imageLiteral(resourceName: "Resturant")  as AnyObject]
        let tblDict2 = ["Heading": "E-Vouchers" as AnyObject,  "image": #imageLiteral(resourceName: "Voucher") as AnyObject]
        let tblDict3 = ["Heading": "Notifications" as AnyObject, "image": #imageLiteral(resourceName: "Notification") as AnyObject]
        let tblDict4 = ["Heading": "Usage history" as AnyObject, "image": #imageLiteral(resourceName: "mybooking") as AnyObject]
        let tblDict5 = ["Heading": "Customer Support" as AnyObject,  "image": #imageLiteral(resourceName: "support") as AnyObject]
        let tblDict6 = ["Heading": "FAQ" as AnyObject, "image": #imageLiteral(resourceName: "faq") as AnyObject]
        let tblDic7 = ["Heading": "Tems & Conditions" as AnyObject, "image": #imageLiteral(resourceName: "terms&condition") as AnyObject]
        
       
        dataArr.append(contentsOf: [tblDict, tblDict2, tblDict3, tblDict4, tblDict5, tblDict6, tblDic7])
        self.tblView.reloadData()
        
    }

    
}
extension ProfileViewC: UITableViewDataSource,UITableViewDelegate,NextButtonClickedDeligate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell
        {
            cell.nextButtonClickedDeligate = self
            
            let dict = dataArr[indexPath.row]
            if indexPath.row == 0
            {
                cell.lblNumberOfBooking.text = "05"
            }
            else
            {
               cell.lblNumberOfBooking.text = " "
            }
            
            if let Heading = dict["Heading"] as? String
            {
                cell.lblHeading.text = Heading
            }
           
            if let image1 = dict["image"] as? UIImage
            {
                cell.imgView.image = image1
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       switch indexPath.row
       {
       case 0:
       movetoMyBooking()
       case 1:
        moveToEvoucher()
       case 3:
        movetoUsageHistory()
       default:
        return
        }
       
        
    }
    
    func movetoUsageHistory()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewC = sb.instantiateViewController(withIdentifier: "UsageHistroyViewC") as? UsageHistroyViewC
        {
            self.navigationController?.pushViewController(viewC, animated: true)
        }
    }
    func movetoMyBooking()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewC = sb.instantiateViewController(withIdentifier: "MyBookingViewC") as? MyBookingViewC
        {
            self.navigationController?.pushViewController(viewC, animated: true)
        }

    }
    func moveToEvoucher()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewC = sb.instantiateViewController(withIdentifier: "EVoucherViewC") as? EVoucherViewC
        {
            self.navigationController?.pushViewController(viewC, animated: true)
        }
    }
    func nextButtonClicked(cell: UITableViewCell) {
        
    }

}



