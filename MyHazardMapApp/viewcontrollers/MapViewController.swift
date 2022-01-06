//
//  ViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/10/31.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var idToSend: String!
    
    @IBOutlet weak var addInformationButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let firstNavigationController = storyboard.instantiateViewController(withIdentifier: "FirstNavigationController")
            firstNavigationController.modalPresentationStyle = .fullScreen
            self.present(firstNavigationController, animated: true, completion: nil)
        } catch {
            print("ログアウト失敗\(error)")
        }
        
    }
    
    private var informations = [Information]()
    
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(mapView)
        self.view.addSubview(addInformationButton)
        self.view.sendSubviewToBack(mapView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchUserInfoFromFirestore()
        super.viewWillAppear(animated)
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("informations").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("informations情報の取得に失敗しました\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (documentCange) in
                
                switch documentCange.type {
                case .added:
                    let data = documentCange.document.data()
                    let information = Information.init(dic: data)
                    
                    self.informations.append(information)
                    
                    self.informations.forEach { (information) in
                        
                        let postID = information.postID
                        let doubleLatitude = Double(information.PlaceLatitude)
                        let doubleLongitude = Double(information.PlaceLongitude)
                        let position = CLLocationCoordinate2D(latitude: doubleLatitude ?? 0, longitude: doubleLongitude ?? 0)
                        let marker = GMSMarker(position: position)
                        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
                        
                        if information.userId == currentUserId {
                            
                            marker.title = postID
                            marker.appearAnimation = .pop
                            marker.map = self.mapView
                            
                        } else {
                            
                            return
                            
                        }
                        
                    }
                case .modified, .removed:
                    print("nothing to do")
                }
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        idToSend = marker.title
        
        self.performSegue(withIdentifier: "MarkerTaped", sender: nil)
        
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MarkerTaped" {
            let vc = segue.destination as? InformationViewController
            // 遷移先のクラスのプロパティに値を代入する
            vc?.markerID = idToSend
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        
        self.mapView.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func setUpElements() {
        
        Utilities.styleAddInformationButton(addInformationButton)
        Utilities.styleLogOutButton(LogOutButton)
        
    }
}

