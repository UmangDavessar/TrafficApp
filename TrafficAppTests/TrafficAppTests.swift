//
//  TrafficAppTests.swift
//  TrafficAppTests
//
//  Created by Umang Davessar on 2/12/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import XCTest
import UIKit
import MapKit

@testable import TrafficApp

class TrafficAppTests: XCTestCase {

    //declaring the ViewController under test
    private var rootViewController: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //get the storyboard the ViewController under test is inside
        let classBundle = Bundle.init(for: ViewController.classForCoder())
        let storyboard = UIStoryboard(name: "Main", bundle: classBundle)
        let myViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        rootViewController = myViewController
        //load view hierarchy
               if(rootViewController != nil) {

                   rootViewController.loadView()
                   rootViewController.viewDidLoad()
               }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.


    }


    func testViewControllerIsComposedOfMapView() {

           XCTAssertNotNil(rootViewController.mapView, "ViewController under test is not composed of a MKMapView")
       }


       func testMapViewDelegateIsSet() {

           XCTAssertNotNil(self.rootViewController.mapView.delegate)
       }



       func testMapInitialization() {

        XCTAssert(rootViewController.mapView.mapType == MKMapType.standard);
       }



       // MARK: - Utility

       func hasTargetAnnotation(annotationClass: MKAnnotation.Type) -> Bool {

           let mapAnnotations = self.rootViewController.mapView.annotations

           var hasTargetAnnotation = false
           for anno in mapAnnotations {
            if (anno.isKind(of: annotationClass)) {
                   hasTargetAnnotation = true
               }
           }

           return hasTargetAnnotation
       }



    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


