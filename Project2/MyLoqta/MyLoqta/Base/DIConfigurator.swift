//
//  DIConfigurator.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit

class DIConfigurator {
    
    private static let sharedOjbect = DIConfigurator()
    
    class func sharedInst() -> DIConfigurator {
        return sharedOjbect
    }
    
    func getViewControler(storyBoard: StoryboardType, indentifire: String) -> UIViewController {
        let storyB = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return storyB.instantiateViewController(withIdentifier: indentifire)
    }
    
    func getTabBar() -> TabBarViewC? {
        if let tabbarVC = self.getViewControler(storyBoard: .Main, indentifire: TabBarViewC.className) as? TabBarViewC {
            return tabbarVC
        } else {
            fatalError("Not able to initialize TabBarViewC")
        }
    }
    
    func getTutotialVC() -> TutorialViewC? {
        if let tutorialVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: TutorialViewC.className) as? TutorialViewC {
            return tutorialVC
        } else {
            fatalError("Not able to initialize TabBarViewC")
        }
    }
    
    func getTermsAndCondVC() -> TermsAndConditionsViewC? {
        if let termCndVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: TermsAndConditionsViewC.className) as? TermsAndConditionsViewC {
            return termCndVC
        } else {
            fatalError("Not able to initialize TabBarViewC")
        }
    }
    
    func getLoginVC() -> LoginViewC? {
        if let loginVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: LoginViewC.className) as? LoginViewC {
            loginVC.viewModel = LoginVM()
            return loginVC
        } else {
            fatalError("Not able to initialize SignupViewC")
        }
    }
    
    func getSigup() -> SignupViewC? {
        if let singupVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: SignupViewC.className) as? SignupViewC {
            singupVC.viewModel = SignupVM()
            return singupVC
        } else {
            fatalError("Not able to initialize SignupViewC")
        }
    }
    
    func getVerifyPhone() -> VerifyPhoneViewC? {
        if let verifyPhVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: VerifyPhoneViewC.className) as? VerifyPhoneViewC {
            //verifyPhVC.viewModel = SignupVM()
            return verifyPhVC
        } else {
            fatalError("Not able to initialize VerifyPhoneViewC")
        }
    }
    
    func getOTPViewC() -> OTPViewC? {
        if let optVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: OTPViewC.className) as? OTPViewC {
            optVC.viewModel = VerifyPhoneVM()
            return optVC
        } else {
            fatalError("Not able to initialize OTPViewC")
        }
    }
    
    func getUpdatePasswordVC() -> UpdatePasswordViewC? {
        if let updatePVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: UpdatePasswordViewC.className) as? UpdatePasswordViewC {
            updatePVC.viewModel = UpdatePasswordVM()
            updatePVC.hidesBottomBarWhenPushed = true
            return updatePVC
        } else {
            fatalError("Not able to initialize OTPViewC")
        }
    }
    
    func getProfileNavC() -> UINavigationController? {
        if let profileNavC = self.getViewControler(storyBoard: .LoginSignup, indentifire: "ProfileNavC") as? UINavigationController {
            return profileNavC
        } else {
            fatalError("Not able to initialize UINavigationController")
        }
    }
    
    func getEmptyProfileVC() -> EmptyProfileViewC? {
        if let emptyProfileVC = self.getViewControler(storyBoard: .LoginSignup, indentifire: EmptyProfileViewC.className) as? EmptyProfileViewC {
            emptyProfileVC.viewModel = EmptyProfileVM()
            return emptyProfileVC
        } else {
            fatalError("Not able to initialize EmptyProfileViewC")
        }
    }
    
    func getSellerNavC() -> UINavigationController? {
        if let sellerNavC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: "SellerSignupNavC") as? UINavigationController {
            return sellerNavC
        } else {
            fatalError("Not able to initialize UINavigationController")
        }
    }
    
    func getSellerEmptyVC() -> SellerEmptyProfileViewC? {
        if let sellerEmptyVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: SellerEmptyProfileViewC.className) as? SellerEmptyProfileViewC {
            sellerEmptyVC.viewModel = SellerEmptyProfileVM()
            return sellerEmptyVC
        } else {
            fatalError("Not able to initialize SellerEmptyProfileViewC")
        }
    }
    
    func getSellerTypeVC() -> SellerTypeViewC? {
        if let sellerTypeVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: SellerTypeViewC.className) as? SellerTypeViewC {
            sellerTypeVC.viewModel = SellerTypeVM()
            return sellerTypeVC
        } else {
            fatalError("Not able to initialize SellerTypeViewC")
        }
    }
    
    func getIndividualSellerDocsVC() -> IndividualUploadDocsViewC? {
        if let individualSellerDocsVCVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: IndividualUploadDocsViewC.className) as? IndividualUploadDocsViewC {
            individualSellerDocsVCVC.viewModel = IndividualUploadDocsVM()
            return individualSellerDocsVCVC
        } else {
            fatalError("Not able to initialize IndividualUploadDocsViewC")
        }
    }
    
    func getBusinessSellerDocsVC() -> BusinessUploadDocsViewC? {
        if let businessSellerDocsVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: BusinessUploadDocsViewC.className) as? BusinessUploadDocsViewC {
            businessSellerDocsVC.viewModel = BusinessUploadDocsVM()
            return businessSellerDocsVC
        } else {
            fatalError("Not able to initialize BusinessUploadDocsViewC")
        }
    }
    
    func getBankInfoVC() -> BankInfoViewC? {
        if let bankInfoVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: BankInfoViewC.className) as? BankInfoViewC {
            bankInfoVC.viewModel = BankInfoVM()
            return bankInfoVC
        } else {
            fatalError("Not able to initialize BankInfoViewC")
        }
    }
    
    func getPrepareProfileVC(arrayDocuments: [[String: Any]]) -> PrepareProfileViewC? {
        if let prepareProfileVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: PrepareProfileViewC.className) as? PrepareProfileViewC {
            prepareProfileVC.viewModel = PrepareProfileVM()
            prepareProfileVC.arrayDocuments = arrayDocuments
            return prepareProfileVC
        } else {
            fatalError("Not able to initialize PrepareProfileViewC")
        }
    }
    
    func getSettingsVC() -> SettingsViewC? {
        if let setingsVC = self.getViewControler(storyBoard: .Profile, indentifire: SettingsViewC.className) as? SettingsViewC {
            setingsVC.viewModel = SettingsVM()
            return setingsVC
        } else {
            fatalError("Not able to initialize PrepareProfileViewC")
        }
    }
    
    func getEditProfile() -> EditProfileViewC? {
        if let editProfileVC = self.getViewControler(storyBoard: .Profile, indentifire: EditProfileViewC.className) as? EditProfileViewC {
            editProfileVC.viewModel = EditProfileVM()
            return editProfileVC
        } else {
            fatalError("Not able to initialize PrepareProfileViewC")
        }
    }
    
    func getExploreNavC() -> UINavigationController? {
        if let exploreNavC = self.getViewControler(storyBoard: .Home, indentifire: "ExploreMainNavC") as? UINavigationController {
            return exploreNavC
        } else {
            fatalError("Not able to initialize ExploreMainNavC")
        }
    }
    
    func getAddItemVC() -> AddItemViewC? {
        if let addItemVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: AddItemViewC.className) as? AddItemViewC {
            addItemVC.viewModel = AddItemVM()
            
            return addItemVC
        } else {
            fatalError("Not able to initialize AddItemViewC")
        }
    }
    
    func getExploreCategoryVC() -> ExploreCategoryViewC? {
        if let exploreCategoryVC = self.getViewControler(storyBoard: .Home, indentifire: ExploreCategoryViewC.className) as? ExploreCategoryViewC {
            exploreCategoryVC.viewModel = ExploreCategoryVM()
            return exploreCategoryVC
        } else {
            fatalError("Not able to initialize ExploreCategoryViewC")
        }
    }
    
    func getExploreSubCategoryVC() -> ExploreSubCategoryViewC? {
        if let exploreSubCategoryVC = self.getViewControler(storyBoard: .Home, indentifire: ExploreSubCategoryViewC.className) as? ExploreSubCategoryViewC {
            exploreSubCategoryVC.viewModel = ExploreSubCategoryVM()
            return exploreSubCategoryVC
        } else {
            fatalError("Not able to initialize ExploreSubCategoryViewC")
        }
    }
    
    func getShippingVC() -> ShippingViewC? {
        if let shippingVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: ShippingViewC.className) as? ShippingViewC {
            shippingVC.viewModel = ShippingVM()
            return shippingVC
        } else {
            fatalError("Not able to initialize ShippingViewC")
        }
    }
    
    func getActiveProductVC() -> ActiveProductViewC? {
        if let activeProductVC = self.getViewControler(storyBoard: .Product, indentifire: ActiveProductViewC.className) as? ActiveProductViewC {
            activeProductVC.viewModel = ActiveProductVM()
            return activeProductVC
        } else {
            fatalError("Not able to initialize ActiveProductViewC")
        }
    }
    
    func getSellerProductsNavC() -> UINavigationController? {
        if let sellerProductsNavC = self.getViewControler(storyBoard: .Product, indentifire: "SellerProductsNavC") as? UINavigationController {
            return sellerProductsNavC
        } else {
            fatalError("Not able to initialize SellerProductsNavC")
        }
    }
    
    
    func getCategoryVC() -> CategoryViewC? {
        if let categoryVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: CategoryViewC.className) as? CategoryViewC {
            categoryVC.viewModel = CategoryVM()
            return categoryVC
        } else {
            fatalError("Not able to initialize CategoryViewC")
        }
    }
    
    
    func getSubCategoryVC() -> SubCategoryViewC? {
        if let subCatVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: SubCategoryViewC.className) as? SubCategoryViewC {
            subCatVC.viewModel = CategoryVM()
            return subCatVC
        } else {
            fatalError("Not able to initialize SubCategoryViewC")
        }
    }
    
    func getAddressList() -> AddressListVewC? {
        if let addressVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: AddressListVewC.className) as? AddressListVewC {
            addressVC.viewModel = AddressListVM()
            addressVC.hidesBottomBarWhenPushed = true
            return addressVC
        } else {
            fatalError("Not able to initialize SubCategoryViewC")
        }
    }
    
    func getAddAddressVC() -> AddAddressViewC? {
        if let addNewAddress = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: AddAddressViewC.className) as? AddAddressViewC {
            addNewAddress.viewModel = AddressListVM()
            addNewAddress.hidesBottomBarWhenPushed = true
            return addNewAddress
        } else {
            fatalError("Not able to initialize SubCategoryViewC")
        }
    }
    
    func getProductListVC() -> ProductListViewC? {
        if let productListVC = self.getViewControler(storyBoard: .Home, indentifire: ProductListViewC.className) as? ProductListViewC {
            productListVC.viewModel = ProductListVM()
            return productListVC
        } else {
            fatalError("Not able to initialize ProductListViewC")
        }
    }
    
    func getSellerProfileVC() -> SellerProfileViewC? {
        if let sellerProfileVC = self.getViewControler(storyBoard: .Home, indentifire: SellerProfileViewC.className) as? SellerProfileViewC {
            sellerProfileVC.viewModel = SellerProfileVM()
            return sellerProfileVC
        } else {
            fatalError("Not able to initialize SellerProfileViewC")
        }
    }
    
    func getBuyerProducDetail() -> BuyerProductDetailViewC? {
        if let buyerPDVC = self.getViewControler(storyBoard: .SellerLoginSignup, indentifire: BuyerProductDetailViewC.className) as? BuyerProductDetailViewC {
            buyerPDVC.viewModel = BuyerProductDetailVM()
            buyerPDVC.hidesBottomBarWhenPushed = true
            return buyerPDVC
        } else {
            fatalError("Not able to initialize SubCategoryViewC")
        }
    }
    
    func getSellerEditProfileVC() -> SellerEditProfileViewC? {
        if let sellerEditProfileVC = self.getViewControler(storyBoard: .Home, indentifire: SellerEditProfileViewC.className) as? SellerEditProfileViewC {
            sellerEditProfileVC.viewModel = SellerEditProfileVM()
            return sellerEditProfileVC
        } else {
            fatalError("Not able to initialize SellerEditProfileViewC")
        }
    }
    
    func getDraftProductDetail() -> DraftProductViewC? {
        if let sellerEditProfileVC = self.getViewControler(storyBoard: .Product, indentifire: DraftProductViewC.className) as? DraftProductViewC {
            sellerEditProfileVC.viewModel = DraftProductVM()
            return sellerEditProfileVC
        } else {
            fatalError("Not able to initialize SellerEditProfileViewC")
        }
    }
    
    func getReviewProductDetail() -> ReviewProductViewC? {
        if let sellerEditProfileVC = self.getViewControler(storyBoard: .Product, indentifire: ReviewProductViewC.className) as? ReviewProductViewC {
            sellerEditProfileVC.viewModel = ReviewProductVM()
            return sellerEditProfileVC
        } else {
            fatalError("Not able to initialize SellerEditProfileViewC")
        }
    }
    
    func getConditionVC() -> SelectConditionViewC? {
        if let conditionVC = self.getViewControler(storyBoard: .Product, indentifire: SelectConditionViewC.className) as? SelectConditionViewC {
            return conditionVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getCheckoutVC() -> CheckoutViewC? {
        if let checkoutVC = self.getViewControler(storyBoard: .Home, indentifire: CheckoutViewC.className) as? CheckoutViewC {
            return checkoutVC
            checkoutVC.viewModel = CheckoutVM()
        } else {
            fatalError("Not able to initialize CheckoutViewC")
        }
    }
    
    func getMyCartVC() -> MyCartViewC? {
        if let myCartVC = self.getViewControler(storyBoard: .Profile, indentifire: MyCartViewC.className) as? MyCartViewC {
            myCartVC.viewModel = MyCartVM()
            return myCartVC
        } else {
            fatalError("Not able to initialize MyCartViewC")
        }
    }
    
    func getSearchVC() -> SearchViewC? {
        if let searchVC = self.getViewControler(storyBoard: .Product, indentifire: SearchViewC.className) as? SearchViewC {
            searchVC.viewModel = SearchVM()
            searchVC.hidesBottomBarWhenPushed = true
            return searchVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getOrderDetailVC() -> OrderDetailViewC? {
        if let orderVC = self.getViewControler(storyBoard: .Product, indentifire: OrderDetailViewC.className) as? OrderDetailViewC {
            orderVC.viewModel = OrderDetailVM()
            orderVC.hidesBottomBarWhenPushed = true
            return orderVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getItemStateVC() -> ItemStateViewC? {
        if let orderVC = self.getViewControler(storyBoard: .Product, indentifire: ItemStateViewC.className) as? ItemStateViewC {
            orderVC.viewModel = ItemStateVM()
            orderVC.hidesBottomBarWhenPushed = true
            return orderVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getFilterVC() -> FilterViewC? {
        if let filterVC = self.getViewControler(storyBoard: .Product, indentifire: FilterViewC.className) as? FilterViewC {
            //filterVC.viewModel = FilterVM()
            filterVC.hidesBottomBarWhenPushed = true
            return filterVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getSearchDetailVC() -> SearchDetailViewC? {
        if let searchDetailVC = self.getViewControler(storyBoard: .Product, indentifire: SearchDetailViewC.className) as? SearchDetailViewC {
            searchDetailVC.viewModel = SearchVM()
            return searchDetailVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getMyLikesVC() -> MyLikesViewC? {
        if let myLikesVC = self.getViewControler(storyBoard: .Home, indentifire: MyLikesViewC.className) as? MyLikesViewC {
            myLikesVC.viewModel = MyLikesVM()
            return myLikesVC
        } else {
            fatalError("Not able to initialize MyLikesViewC")
        }
    }

    func getPopupViewC() -> PricePopupViewC? {
        if let popupVC = self.getViewControler(storyBoard: .Product, indentifire: PricePopupViewC.className) as? PricePopupViewC {
            return popupVC
        } else {
            fatalError("Not able to initialize SelectConditionViewC")
        }
    }
    
    func getOrderCompletedViewC() -> OrderCompletedViewC? {
        if let orderCompletedVC = self.getViewControler(storyBoard: .Profile, indentifire: OrderCompletedViewC.className) as? OrderCompletedViewC {
            return orderCompletedVC
        } else {
            fatalError("Not able to initialize OrderCompletedViewC")
        }
    }
    
    func getBuyerOrderListViewC() -> BuyerOrderListViewC? {
        if let buyerOrderListVC = self.getViewControler(storyBoard: .Profile, indentifire: BuyerOrderListViewC.className) as? BuyerOrderListViewC {
            buyerOrderListVC.viewModel = BuyerOrderListVM()
            return buyerOrderListVC
        } else {
            fatalError("Not able to initialize BuyerOrderListViewC")
        }
    }
    
    func getSellerMoreOptionsViewC() -> SellerMoreOptionsViewC? {
        if let sellerMoreOptionsVC = self.getViewControler(storyBoard: .Profile, indentifire: SellerMoreOptionsViewC.className) as? SellerMoreOptionsViewC {
            sellerMoreOptionsVC.viewModel = SellerMoreOptionsVM()
            return sellerMoreOptionsVC
        } else {
            fatalError("Not able to initialize SellerMoreOptionsViewC")
        }
    }
    
    func getSellerSoldProductsViewC() -> SellerSoldProductsViewC? {
        if let sellerSoldProductsVC = self.getViewControler(storyBoard: .Profile, indentifire: SellerSoldProductsViewC.className) as? SellerSoldProductsViewC {
            sellerSoldProductsVC.viewModel = SellerSoldProductsVM()
            return sellerSoldProductsVC
        } else {
            fatalError("Not able to initialize SellerSoldProductsViewC")
        }
    }
    
    func getRejectReasonViewC() -> RejectReasonViewC? {
        if let rejectReasonVC = self.getViewControler(storyBoard: .Profile, indentifire: RejectReasonViewC.className) as? RejectReasonViewC {
            rejectReasonVC.viewModel = RejectReasonVM()
            return rejectReasonVC
        } else {
            fatalError("Not able to initialize RejectReasonViewC")
        }
    }
    
    func getBuyerReviewsViewC() -> BuyerReviewsViewC? {
        if let buyerReviewsVC = self.getViewControler(storyBoard: .Profile, indentifire: BuyerReviewsViewC.className) as? BuyerReviewsViewC {
            buyerReviewsVC.viewModel = BuyerReviewsVM()
            return buyerReviewsVC
        } else {
            fatalError("Not able to initialize BuyerReviewsViewC")
        }
    }
    
    func getReviewsAboutBuyerViewC() -> ReviewsAboutBuyerViewC? {
        if let buyerReviewsVC = self.getViewControler(storyBoard: .Profile, indentifire: ReviewsAboutBuyerViewC.className) as? ReviewsAboutBuyerViewC {
            buyerReviewsVC.viewModel = ReviewsAboutBuyerVM()
            return buyerReviewsVC
        } else {
            fatalError("Not able to initialize ReviewsAboutBuyerViewC")
        }
    }
    
    
    func getHelpViewC() -> HelpViewC? {
        if let helpVC = self.getViewControler(storyBoard: .Profile, indentifire: HelpViewC.className) as? HelpViewC {
            return helpVC
        } else {
            fatalError("Not able to initialize HelpViewC")
        }
    }
    
    func getMessageAdminViewC() -> MessageAdminViewC? {
        if let messageAdminVC = self.getViewControler(storyBoard: .Profile, indentifire: MessageAdminViewC.className) as? MessageAdminViewC {
            messageAdminVC.viewModel = MessageAdminVM()
            return messageAdminVC
        } else {
            fatalError("Not able to initialize MessageAdminViewC")
        }
    }
    
    func getBuyerFeedbackViewC() -> BuyerFeedbackViewC? {
        if let buyerFeedbackVC = self.getViewControler(storyBoard: .Profile, indentifire: BuyerFeedbackViewC.className) as? BuyerFeedbackViewC {
            buyerFeedbackVC.viewModel = BuyerFeedbackVM()
            return buyerFeedbackVC
        } else {
            fatalError("Not able to initialize BuyerFeedbackViewC")
        }
    }
    
    func getSellerFeedbackViewC() -> SellerFeedbackViewC? {
        if let sellerFeedbackVC = self.getViewControler(storyBoard: .Profile, indentifire: SellerFeedbackViewC.className) as? SellerFeedbackViewC {
            sellerFeedbackVC.viewModel = SellerFeedbackVM()
            return sellerFeedbackVC
        } else {
            fatalError("Not able to initialize SellerFeedbackViewC")
        }
    }
    
    func getNotificationSettingsViewC() -> NotificationSettingsViewC? {
        if let notificationSettingsVC = self.getViewControler(storyBoard: .Home, indentifire: NotificationSettingsViewC.className) as? NotificationSettingsViewC {
            notificationSettingsVC.viewModel = NotificationSettingsVM()
            return notificationSettingsVC
        } else {
            fatalError("Not able to initialize NotificationSettingsViewC")
        }
    }

    func getInsightViewC() -> InsightViewC? {
        if let insightVC = self.getViewControler(storyBoard: .Profile, indentifire: InsightViewC.className) as? InsightViewC {
            insightVC.viewModel = InsightVM()
            return insightVC
        } else {
            fatalError("Not able to initialize InsightViewC")
        }
    }
    
    func getSettingsWebViewC() -> SettingsWebViewC? {
        if let settingsWebVC = self.getViewControler(storyBoard: .Profile, indentifire: SettingsWebViewC.className) as? SettingsWebViewC {
            return settingsWebVC
        } else {
            fatalError("Not able to initialize SettingsWebViewC")
        }
    }
    
    func getProductStatsViewC() -> ProductStatsViewC? {
        if let productStatsViewC = self.getViewControler(storyBoard: .Profile, indentifire: ProductStatsViewC.className) as? ProductStatsViewC {
            productStatsViewC.viewModel = ProductStatsVM()
            return productStatsViewC
        } else {
            fatalError("Not able to initialize ProductStatsViewC")
        }
    }
    
    func getWithdrawMoneyViewC() -> WithdrawMoneyViewC? {
        if let withdrawMoneyVC = self.getViewControler(storyBoard: .Profile, indentifire: WithdrawMoneyViewC.className) as? WithdrawMoneyViewC {
            withdrawMoneyVC.viewModel = WithdrawMoneyVM()
            return withdrawMoneyVC
        } else {
            fatalError("Not able to initialize WithdrawMoneyViewC")
        }
    }
    
    func getWithdrawPopupViewC() -> WithdrawPopupViewC? {
        if let popupVC = self.getViewControler(storyBoard: .Profile, indentifire: WithdrawPopupViewC.className) as? WithdrawPopupViewC {
            popupVC.viewModel = WithdrawPopupVM()
            return popupVC
        } else {
            fatalError("Not able to initialize WithdrawPopupViewC")
        }
    }
    
    func getBankDetailViewC() -> BankDetailViewC? {
        if let bankDetailVC = self.getViewControler(storyBoard: .Profile, indentifire: BankDetailViewC.className) as? BankDetailViewC {
            return bankDetailVC
        } else {
            fatalError("Not able to initialize BankDetailViewC")
        }
    }
    
    func getBuyerAcceptOrderViewC() -> BuyerAcceptOrderViewC? {
        if let buyerAcceptOrderVC = self.getViewControler(storyBoard: .Profile, indentifire: BuyerAcceptOrderViewC.className) as? BuyerAcceptOrderViewC {
            buyerAcceptOrderVC.viewModel = BuyerAcceptOrderVM()
            return buyerAcceptOrderVC
        } else {
            fatalError("Not able to initialize BuyerAcceptOrderViewC")
        }
    }
    
    func getWithdrawSuccessViewC() -> WithdrawSuccessViewC? {
        if let withdrawSuccessVC = self.getViewControler(storyBoard: .Profile, indentifire: WithdrawSuccessViewC.className) as? WithdrawSuccessViewC {
            return withdrawSuccessVC
        } else {
            fatalError("Not able to initialize WithdrawSuccessViewC")
        }
    }
    
    func getReferralViewC() -> ReferralViewC? {
        if let referralVC = self.getViewControler(storyBoard: .Profile, indentifire: ReferralViewC.className) as? ReferralViewC {
            referralVC.viewModel = ReferralVM()
            return referralVC
        } else {
            fatalError("Not able to initialize ReferralViewC")
        }
    }
    
    func getTrackOrderViewC() -> TrackOrderViewC? {
        if let trackOrderVC = self.getViewControler(storyBoard: .Profile, indentifire: TrackOrderViewC.className) as? TrackOrderViewC {
            trackOrderVC.viewModel = TrackOrderVM()
            return trackOrderVC
        } else {
            fatalError("Not able to initialize TrackOrderViewC")
        }
    }
    
    func getActivityNavC() -> UINavigationController? {
        if let activityNavC = self.getViewControler(storyBoard: .Main, indentifire: "ActivityNavC") as? UINavigationController {
            return activityNavC
        } else {
            fatalError("Not able to initialize UINavigationController")
        }
    }
    
}
