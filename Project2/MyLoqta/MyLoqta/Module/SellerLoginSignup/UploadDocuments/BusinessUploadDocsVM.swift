//
//  BusinessUploadDocsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol BusinessUploadDocsVModeling {
    func getDataSource() -> [[String: Any?]]
}

class BusinessUploadDocsVM: BaseModeling, BusinessUploadDocsVModeling {
    
    func getDataSource() -> [[String: Any?]] {
        let docDescOne = "Сommercial License".localize()
        let docDescTwo = "Owner Civil ID Front".localize()
        let docDescThree = "Owner Civil ID Back".localize()
        let docImageOne = #imageLiteral(resourceName: "license")
        let docImageTwo = #imageLiteral(resourceName: "civil_id_front")
        let docImageThree = #imageLiteral(resourceName: "civil_id_back")
        let dictOne: [String: Any?] = ["documentImage": nil, "placeholderImage": docImageOne, "description": docDescOne, "imageUrl": "",Constant.keys.kImageStatus: ImageStatus.empty]
        let dictTwo: [String: Any?] = ["documentImage": nil, "placeholderImage": docImageTwo, "description": docDescTwo, "imageUrl": "",Constant.keys.kImageStatus: ImageStatus.empty]
        let dictThree: [String: Any?] = ["documentImage": nil, "placeholderImage": docImageThree, "description": docDescThree, "imageUrl": "",Constant.keys.kImageStatus: ImageStatus.empty]
        let dataSource = [dictOne, dictTwo, dictThree]
        return dataSource
    }
}
