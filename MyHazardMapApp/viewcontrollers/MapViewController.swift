//
//  ViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/10/31.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
        
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
    
    private var users = [User]()
    
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(mapView)
        self.view.addSubview(addInformationButton)
        self.view.sendSubviewToBack(mapView)
  }
    
    override func viewWillAppear(_ animated: Bool) {
            
            fetchUserInfoFromFirestore()
            
        }
        
        private func fetchUserInfoFromFirestore() {
            
            Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
                if let err = err {
                    print("user情報の取得に失敗しました\(err)")
                    return
                }
                snapshots?.documents.forEach({ (snapshot) in
                    let data = snapshot.data()
                    let user = User.init(dic: data)
                    
                    self.users.append(user)
                    
                    self.users.forEach { (user) in
                        print("firstname: ",user.firstname)
                    }
                    
                })
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
        
    }
}

