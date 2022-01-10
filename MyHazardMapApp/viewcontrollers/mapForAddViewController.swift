//
//  mapForAddViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/11/28.
//

//位置情報登録画面
import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import FirebaseStorage

class mapForAddViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var img_url :String!
    var pickedImage :UIImage!
    var placeName: String!
    var information: String!
    var latitude: String!
    var longitude: String!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //戻るボタンの設定
    @IBAction func tappedBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //登録ボタンが押されたらsavetofirestoreを呼び出す
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        saveToFireStore()
        
        self.performSegue(withIdentifier: "TransitionToMap", sender: self)
        
    }
    
    private var informations = [Information]()
    
    var locationManager = CLLocationManager()
    
    lazy var mapView = GMSMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
        
        //マップと現在位置の表示
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.isMyLocationEnabled = true
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(mapView)
        self.view.addSubview(registerButton)
        self.view.sendSubviewToBack(mapView)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //長押しするとマーカーが表示され、緯度経度の情報を取得する
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        latitude = String(coordinate.latitude)
        longitude = String(coordinate.longitude)
        marker.appearAnimation = .pop
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        
        self.mapView.animate(to: camera)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    //UI設定
    func setUpElements() {
        
        Utilities.styleFilledButton(registerButton)
        Utilities.styleLogOutButton(backButton)
        
    }
    
    //Firebase上へ画像を保存
    fileprivate func upload(completed: @escaping(_ url: String?) -> Void) {
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let storageRef = Storage.storage().reference().child("images").child("\(currentTimeStampInSecond).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.pickedImage?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    completed(nil)
                    print("error: \(String(describing: error?.localizedDescription))")
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        completed(nil)
                        print("error: \(String(describing: error?.localizedDescription))")
                    }
                    completed(url?.absoluteString)
                })
            }
        }
    }
    
    //登録する項目を指定や保存先を指定
    fileprivate func saveToFireStore(){
        var Image_URL = img_url
        let detailInformation = information
        let PlaceName = placeName
        let markerLatitude = latitude
        let markerLongitude = longitude
        
        //UserIDと照合してから、各項目をDB上に登録
        guard let userID = Auth.auth().currentUser?.uid else { return }
        upload(){ url in
            guard let url = url else { return }
            Image_URL = url
            let saveDocument = Firestore.firestore().collection("informations").document()
            saveDocument.setData([
                "imageURL": Image_URL as Any,
                "detailInformation": detailInformation as Any,
                "PlaceName": PlaceName as Any,
                "PlaceLatitude": markerLatitude as Any,
                "PlaceLongitude": markerLongitude as Any,
                "postID": saveDocument.documentID,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp(),
                "UserID": userID as Any
            ]){ error in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                }
                print("image saved!")
            }
        }
    }
    
    //画面遷移の方法設定
    func transitionToMap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapVC") as? MapViewController
        
        view.window?.rootViewController = mapViewController
        view.window?.makeKeyAndVisible()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
