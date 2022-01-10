//
//  ViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/10/31.
//

//メイン画面
import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import FirebaseStorage

//各ボタンの機能実装
class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var idToSend: String!
    
    //情報追加ボタンを配置
    @IBOutlet weak var addInformationButton: UIButton!
    //ログアウトボタンを配置
    @IBOutlet weak var LogOutButton: UIButton!
    
    //ログアウト機能の実装
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
        
        setUpElements()
        
        //現在地表示
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
    
    //Firebaseからユーザが追加した情報を取得
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
    
    //Firebaseからの情報取得機能を実装
    private func fetchUserInfoFromFirestore() {
        
        //取得先を指定
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
                    
                    //取得する情報を指定
                    self.informations.forEach { (information) in
                        
                        //投稿ID
                        let postID = information.postID
                        //Double型で緯度を取得
                        let doubleLatitude = Double(information.PlaceLatitude)
                        //Double型で経度を取得
                        let doubleLongitude = Double(information.PlaceLongitude)
                        //緯度経度を持つ構造体を生成
                        let position = CLLocationCoordinate2D(latitude: doubleLatitude ?? 0, longitude: doubleLongitude ?? 0)
                        
                        //positionを用いてマーカーを生成
                        let marker = GMSMarker(position: position)
                        //UserIDを取得
                        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
                        
                        //マーカーを表示
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
    
    //マーカーをタップした際
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //投稿IDを保持し、情報確認画面へ遷移
        idToSend = marker.title
        
        self.performSegue(withIdentifier: "MarkerTaped", sender: nil)
        
        return true
        
    }
    
    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MarkerTaped" {
            let vc = segue.destination as? InformationViewController
            // 遷移先のクラスのプロパティに値を代入する
            vc?.markerID = idToSend
        }
    }
    
    //現在位置を表示
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        
        self.mapView.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    //UIの規格を整理
    func setUpElements() {
        
        Utilities.styleAddInformationButton(addInformationButton)
        Utilities.styleLogOutButton(LogOutButton)
        
    }
}

