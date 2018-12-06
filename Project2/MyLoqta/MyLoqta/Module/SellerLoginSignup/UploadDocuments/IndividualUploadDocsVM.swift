//
//  IndividualUploadDocsVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit


protocol IndividualUploadDocsVModeling {
    
    func getDataSource() -> [[String: Any?]]
}

class IndividualUploadDocsVM: BaseModeling, IndividualUploadDocsVModeling {
    
    func getDataSource() -> [[String: Any?]] {
        let docDescOne = "Owner Civil ID Front".localize()
        let docDescTwo = "Owner Civil ID Back".localize()
        let docImageOne = #imageLiteral(resourceName: "civil_id_front")
        let docImageTwo = #imageLiteral(resourceName: "civil_id_back")
        let dictOne: [String: Any?] = ["documentImage": nil, "placeholderImage": docImageOne, "description": docDescOne, "imageUrl": "", Constant.keys.kImageStatus: ImageStatus.empty]
        let dictTwo: [String: Any?] = ["documentImage": nil, "placeholderImage": docImageTwo, "description": docDescTwo, "imageUrl": "",Constant.keys.kImageStatus: ImageStatus.empty]
        let dataSource = [dictOne, dictTwo]
        return dataSource
    }
}
