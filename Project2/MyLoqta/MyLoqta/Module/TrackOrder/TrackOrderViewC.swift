//
//  TrackOrderViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import MapKit

class TrackOrderViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewOrderDetail: UIView!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var lblProductDeliverTime: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    //MARK: - Variables
    var viewModel: TrackOrderVModeling?
    var currentLocation: CLLocation?
    var order: Product?
    var isFromOrderDetail = false
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AVSocketManager.shareInst.connectSocket()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AVSocketManager.shareInst.disconnectSocket()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.registerNotification()
        Threads.performTaskInMainQueue {
            self.viewOrderDetail.roundCorners([.topRight, .topLeft], radius: Constant.btnCornerRadius)
        }
        self.recheckVM()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.requestForCurrentLocation()
        self.setupOrderData()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = TrackOrderVM()
        }
    }
    
    private func registerNotification() {
        self.removeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDriverData(_:)), name: NSNotification.Name(rawValue: TrackNotification.driverData.rawValue), object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: TrackNotification.driverData.rawValue), object: nil)
    }
    
    private func requestForCurrentLocation() {
        DeviceSettings.checkLocationSettings(self){ (success) in
            if success {
                AVLocationManager.sharedInstance.determineCurrentLocation()
                AVLocationManager.sharedInstance.currentLocationProvider = {
                    location in
                    self.currentLocation = location
                    self.centerMapOnCurrentLocation()
//                    self.didUpdateLocationOfDriver(coordinate: location.coordinate)
                    
                }
            }
        }
    }
    
    private func centerMapOnCurrentLocation() {
        guard let curntLoc = self.currentLocation else { return }
        let center = CLLocationCoordinate2D(latitude: (curntLoc.coordinate.latitude), longitude: (curntLoc.coordinate.longitude))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    
    private func setupOrderData() {
        if let orderedProduct = self.order {
            if let productImage = orderedProduct.imageFirstUrl {
                self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
            }
            self.lblProductName.text = orderedProduct.itemName
            if let productPrice = orderedProduct.totalPrice {
                let intPrice = Int(productPrice)
                let usPrice = intPrice.withCommas()
                self.lblProductPrice.text = usPrice
            }
            if let productCondition = orderedProduct.condition {
                self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
            }
            if let productQuantity = orderedProduct.quantity {
                self.lblProductQuantity.text = "\(productQuantity)"
            }
            
            if let date = orderedProduct.orderDate {
                let orderDate = date.UTCToLocal(toFormat: "YYYY-MM-dd HH:mm")
                self.lblProductDeliverTime.text = orderDate
            }
        }
    }
    
    //MARK: - Selector Methods
    @objc func receiveDriverData(_ notificaion: NSNotification) {
        if let driverNotification = notificaion.userInfo as? [String: Any] {
            if let data = driverNotification["data"] as? [[String: Any]], data.count > 0 {
                if let orderId = data[0]["orderId"] as? Int /*, orderId == self.order?.orderId*/ {
                    if let lat = data[0]["lat"] as? Double, let long = data[0]["long"] as? Double {
                        let driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let annotations = self.mapView.annotations
                        self.mapView.removeAnnotations(annotations)
                        self.didUpdateLocationOfDriver(coordinate: driverLocation)
                    }
                }
            }
        }
    }
    
    //MARK: - Public Methods
    
    
    
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOrderDetails(_ sender: UIButton) {
        if isFromOrderDetail {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let itemId = order?.orderDetailId, let itemStateVC = DIConfigurator.sharedInst().getOrderDetailVC() {
                itemStateVC.orderId = itemId
                self.navigationController?.pushViewController(itemStateVC, animated: true)
            }
        }
    }
}


extension TrackOrderViewC: MKMapViewDelegate
{
//    func getRadius(centralLocation: CLLocation) -> Double {
//        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
//        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
//        let radius = centralLocation.distance(from: topCentralLocation)
//        return radius / 1000.0 // to convert radius to meters
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "MLAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MLMapAnnotationView
        
        if annotationView == nil {
            annotationView = MLMapAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let mapAnnotation = annotation as? MLMapAnnotation
        {
            annotationView?.image = UIImage(named: mapAnnotation.pinImgName)
        }
        return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
//        print("Radius - \(self.getRadius(centralLocation: centralLocation))")
//    }
}
