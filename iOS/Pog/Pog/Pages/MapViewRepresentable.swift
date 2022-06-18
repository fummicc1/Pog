//
//  MapViewRepresentable.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/27.
//

import Foundation
import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var region: MKCoordinateRegion
    @Binding var polyline: MKPolyline?


    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.setRegion(region, animated: true)
        if let polyline = polyline {
            view.addOverlay(polyline)
        }
        view.delegate = context.coordinator
        return view
    }


    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let polyline = polyline {
            uiView.removeOverlay(polyline)
            uiView.addOverlay(polyline)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

extension MapViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKPolylineRenderer()
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .tintColor
            renderer.lineWidth = 3
            return renderer
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            let view: MKMarkerAnnotationView
            if let _view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKMarkerAnnotationView {
                view = _view
                view.annotation = annotation
            } else {
                view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: "annotation"
                )
            }
            return view
        }
    }
}
