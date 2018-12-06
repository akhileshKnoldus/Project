//
//  TutorialViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 05/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

typealias TutorialDesc = (title: String, description: String, tutorialType: TutorialType, bgColor: UIColor)

class TutorialViewC: BaseViewC {

    @IBOutlet weak var collectionTutorial: UICollectionView!
    var arrayDataSource = [TutorialDesc]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private functions
    
    private func setup() {
        let exploreProduct = TutorialDesc(NSLocalizedString("Enjoy Shopping", comment: "") , NSLocalizedString("Explore a ton of products and find a suitable one", comment: ""), .explore, UIColor.colorWithRGBA(redC: 248.0, greenC: 176.0, blueC: 42.0, alfa: 1.0))
        let seller = TutorialDesc(NSLocalizedString("Sell Your Products", comment: ""), NSLocalizedString("Start selling and increase your revenue in an easiest way", comment: ""), .seller, UIColor.colorWithRGBA(redC: 68.0, greenC: 71.0, blueC: 147.0, alfa: 1.0))
        let delivery = TutorialDesc(NSLocalizedString("Fast Home Delivery", comment: ""), NSLocalizedString("Within our dedicated delivery you’ll get your items fastly", comment: ""), .delivery, UIColor.colorWithRGBA(redC: 229.0, greenC: 54.0, blueC: 56.0, alfa: 1.0))
        self.arrayDataSource.append(contentsOf: [exploreProduct, seller, delivery])
        self.collectionTutorial.register(TutorialCell.self)
        self.collectionTutorial.reloadData()
    }
    
    // MARK: - IBAction functions
    @objc func showHome() {
        AppDelegate.delegate.showHome()
    }
}

extension TutorialViewC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: TutorialCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: arrayDataSource[indexPath.item])
        cell.btnSkip.addTarget(self, action: #selector(showHome), for: .touchUpInside)
        cell.btnGetStarted.addTarget(self, action: #selector(showHome), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        if indexPath.item != 2 {
            self.collectionTutorial.scrollToItem(at: IndexPath(item: indexPath.item+1, section: 0), at: .centeredHorizontally, animated: false)
        }*/
    }    
}
