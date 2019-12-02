//
//  ViewController.swift
//  TrafficApp
//
//  Created by Umang Davessar on 2/12/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import SDWebImage

class ViewController: UIViewController,MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var trafficDetails = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.delegate = self
        getTrafficDetails()
        // Do any additional setup after loading the view.
    }
    
     // MARK:- API CALL
    
    /*
    
    This method will return the traffic details which returns from API class and show the data on MapView
    
    */

    
    func getTrafficDetails(){
        let trafficData = TrafficDataProvider()
        trafficData.getTrafficDetails(success: { (arrTrafficDetails) in
            
             self.trafficDetails = arrTrafficDetails
             
             self.showDataOnMapView(self.trafficDetails)
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error?.errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
       
    }
    
     // MARK:- MAPPING OF DATA WITH UI
    /*
    
    This method will create Annotations and drop the pins on MAp view with title as camera_id and co-ordinate
    
    */
    
    func showDataOnMapView(_ details: [[String: AnyObject]])
    {
        for i in (0..<details.count) {
           
            let lattitude = details[i]["location"]?["latitude"] as! CLLocationDegrees
            let longtitude = details[i]["location"]?["longitude"] as! CLLocationDegrees
            
            let annotationPoint = TrafficAnnotationModal(coordinate: CLLocationCoordinate2D(latitude: lattitude , longitude: longtitude))
            annotationPoint.image = details[i]["image"] as? String
            annotationPoint.cameraID = details[i]["camera_id"] as? String
            annotationPoint.timeStamp = details[i]["timestamp"] as? String
            self.mapView.addAnnotation(annotationPoint)
        }
        
    }
    
     // MARK:- CHECK LOCATION AUTHORIZATION
    
    /*
       
       This method will chgeck the location services is on/off
       
       */
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        mapView.showsUserLocation = false
    
      // For these case, you need to show a pop-up telling users what's up and how to turn on permisneeded if needed
      case .denied:
        break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
      case .restricted:
        break
      case .authorizedAlways:
        break
      @unknown default:
        break
        }
    }
    
     // MARK:- MKMAPVIEW DELEGATES
    
    /*
       
       This method will Add the animations for drop pins on map view.
       Added some delay to drop pins one by one just to show fancy look
       
       */
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        
        var i = -1;
        for view in views {
            i += 1;
            if view.annotation is MKUserLocation {
                continue;
            }
            let point:MKMapPoint  =  MKMapPoint(view.annotation!.coordinate);
            if (!self.mapView.visibleMapRect.contains(point)) {
                continue;
            }
            let endFrame:CGRect = view.frame;
            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,y :view.frame.origin.y-self.view.frame.size.height), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
            let delay = 0.02 * Double(i)
            UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations:{() in
                view.frame = endFrame
            }, completion:{(Bool) in
                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)
                }, completion: {(Bool) in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                        view.transform = CGAffineTransform.identity
                    }, completion: nil)
                })
            })
        }
    }


    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier") as? MKMarkerAnnotationView
           if view == nil {
               view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
           }

           view?.annotation = annotation
           view?.displayPriority = .required
           return view
       }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        let trafficModalAnnotation = view.annotation as! TrafficAnnotationModal
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
            // UI needs to be updated on main_queue
             DispatchQueue.main.async {
                
                let imageUrl:URL = URL(string:trafficModalAnnotation.image)!
                let imageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
                imageView.center = self.view.center
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                let image = UIImage(data: imageData as Data)
                calloutView.trafficImage.image = image

                
            }
          
        
        

    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }


}

