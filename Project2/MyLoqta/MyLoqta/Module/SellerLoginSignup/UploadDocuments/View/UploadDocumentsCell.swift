//
//  UploadDocumentsCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol UploadDocumentsCellDelegate: class {
    func didTapUploadDoc(_ cell: UploadDocumentsCell)
    func didTapCancel(_ cell: UploadDocumentsCell)
}

class UploadDocumentsCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgViewDocument: UIImageView!
    @IBOutlet weak var lblDocsDesc: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUploadDoc: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnRetry: UIButton!
    
    //MARK: - Variables
    
    weak var delegate: UploadDocumentsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    
    private func setup() {
        self.containerView.roundCorners(Constant.btnCornerRadius)
    }
    
    func configureView(image: UIImage?, placeholderImage: UIImage, description: String, data: [String: Any]? = nil) {
        if let documentImage = image {
            self.imgViewDocument.contentMode = .scaleToFill
            self.imgViewDocument.image = documentImage
        } else {
            self.imgViewDocument.contentMode = .center
            self.imgViewDocument.image = placeholderImage
        }
        self.lblDocsDesc.text = description
        
        if let imageData = data, let imageStatus = imageData[Constant.keys.kImageStatus] as? ImageStatus {
            switch imageStatus {
            case .empty: imgViewDocument.alpha = 1.0
                         self.btnRetry.isHidden = true
                         self.indicator.isHidden = true
                         self.btnCancel.isHidden = true
                
            case .uploading: imgViewDocument.alpha = 0.2
                             self.indicator.isHidden = false
                             self.indicator.startAnimating()
                             self.btnCancel.isHidden = true
                
            case .uploadFailed: self.btnRetry.isHidden = false
                
            case .uploaded: imgViewDocument.alpha = 1.0
                            self.btnRetry.isHidden = true
                            self.indicator.isHidden = true
                            self.btnCancel.isHidden = false
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func tapRetry(_ sender: UIButton) {
        
    }
    
    @IBAction func tapUploadDoc(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapUploadDoc(self)
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapCancel(self)
        }
    }
}
