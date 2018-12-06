//
//  StartNowViewC.swift
//  IDine
//
//  Created by App on 03/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class StartNowViewC: UIViewController {
    
    //MARK:- Properties
    var dataArr = [[String : AnyObject]]()
    
    //MARK:- IBoulet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNib()
        
    }
    
    //MARK:- Private Method
    func loadNib()
    {
        let nib = UINib(nibName: "PageControllCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "PageControllCell")
        loadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func loadData()
    {
        let firstDict = ["heading": "IDine is a premier Dining Rewards membership program " as AnyObject, "subheading": "offering exclusive promotions across InterContinental Doha’s award-winning restaurants " as AnyObject, "image": #imageLiteral(resourceName: "HomeImage1") as AnyObject]
        let Dict2 = ["heading": "Benefits include priority booking!" as AnyObject, "subheading": "first to receive exclusive updates on new offers, and more " as AnyObject, "image": #imageLiteral(resourceName: "HomeImage2") as AnyObject]
        let Dict3 = ["heading": "Enjoy discounts!" as AnyObject, "subheading": "at the luxurious Spa InterContinental or at The Bay Club" as AnyObject, "image": #imageLiteral(resourceName: "HomeImage3") as AnyObject]
        dataArr.append(contentsOf: [firstDict, Dict2, Dict3])
    }
    
    //MARK:- Public Method
    
    //MARK:-IBAction
    @IBAction func tapstartnNow(_ sender: Any) {
        let sb = UIStoryboard(name: "Main" , bundle: nil)
        if let verifyView = sb.instantiateViewController(withIdentifier: "VerifyUserViewC") as? VerifyUserViewC
        {
            self.navigationController?.pushViewController(verifyView, animated: false)
        }
    }
    
    
    @IBAction func tapGuestUser(_ sender: Any) {
        let sb = UIStoryboard(name: "Main" , bundle: nil)
        if let createNewViewc = sb.instantiateViewController(withIdentifier: "CreateNewGuestViewC") as? CreateNewGuestViewC
        {
            self.navigationController?.pushViewController(createNewViewc, animated: false)
        }
    }
    
}

//MARK:- Extension
extension StartNowViewC : UICollectionViewDataSource,UICollectionViewDelegate
{
    //MARK:- Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PageControllCell", for: indexPath) as? PageControllCell
        {
            let dict = dataArr[indexPath.row]
            if let heading = dict["heading"] as? String
            {
                cell.lblMainHeading.text = heading
            }
            if let subheading = dict["subheading"] as? String
            {
                cell.lblSubHeading.text = subheading
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
        
        return CGSize(width: 356, height: 442)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
