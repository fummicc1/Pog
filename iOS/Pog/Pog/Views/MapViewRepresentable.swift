//
//  MapViewRepresentable.swift
//  Pog
//
//  Created by Fumiya Tanaka on 2022/05/27.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseCrashlytics

struct MapViewRepresentable: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var region: MKCoordinateRegion
    @Binding var polyline: MKPolyline?
    @Binding var pickedUpLogs: [PlaceLog]

    @Environment(\.store) var store: Store

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.setRegion(region, animated: true)
        if let polyline = polyline {
            view.addOverlay(polyline)
        }
        var annotations: [MKAnnotation] = []
        for featuredLog in pickedUpLogs {
            let annotaion = PickedUpLogAnnotation(pickedUpLog: featuredLog)
            if let date = featuredLog.date {
                annotaion.title = date.displayable
            }
            annotations.append(annotaion)
        }
        view.addAnnotations(annotations)
        view.delegate = context.coordinator
        return view
    }


    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let polyline = polyline {
            uiView.removeOverlay(polyline)
            uiView.addOverlay(polyline)
        }
        uiView.removeAnnotations(uiView.annotations)
        var annotations: [MKAnnotation] = []
        for pickedUpLog in pickedUpLogs {
            let annotaion = PickedUpLogAnnotation(pickedUpLog: pickedUpLog)
            if let date = pickedUpLog.date {
                annotaion.title = date.displayable
            }
            annotations.append(annotaion)
        }
        uiView.addAnnotations(annotations)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }

}

extension MapViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate, UITextFieldDelegate {

        var store: Store

        init(store: Store) {
            self.store = store
            super.init()
        }

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
            guard let annotation = annotation as? PickedUpLogAnnotation else {
                return nil
            }
            let view: MKMarkerAnnotationView
            if let _view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKMarkerAnnotationView {
                view = _view
                view.annotation = annotation
                view.glyphTintColor = UIColor.tintColor
                view.markerTintColor = UIColor.systemBackground
            } else {
                view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: "annotation"
                )
                view.glyphTintColor = UIColor.tintColor
                view.markerTintColor = UIColor.systemBackground
            }
//            var config = UIButton.Configuration.plain()
//            config.title = "メモを書く"
//            let button = UIButton(configuration: config)
//            button.addAction(UIAction(handler: { _ in
//                let alert = UIAlertController(
//                    title: "メモの入力",
//                    message: "当時いた場所付近にメモを入力できます",
//                    preferredStyle: .alert
//                )
//                var memoTextField: UITextField?
//                alert.addTextField { textField in
//                    textField.delegate = self
//                    textField.placeholder = "ここに入力"
//                    memoTextField = textField
//                }
//                alert.addAction(UIAlertAction(
//                    title: "閉じる",
//                    style: .default,
//                    handler: { _ in
//                        let log = annotation.featureLog
//                        log.memo = memoTextField?.text
//                        do {
//                            try self.store.context.save()
//                        } catch {
//                            print(error)
//                            Crashlytics.crashlytics().log("\(error)")
//                        }
//                    }
//                ))
//                guard let windowScene = UIApplication.shared.connectedScenes
//                    .filter({ $0.activationState == .foregroundActive })
//                    .compactMap({ $0 as? UIWindowScene })
//                    .first, let window = windowScene.keyWindow else {
//                    return
//                }
//                window.rootViewController?.present(alert, animated: true)
//            }), for: .touchUpInside)
//            view.canShowCallout = true
//            view.detailCalloutAccessoryView = button
//
//            if let memo = annotation.featureLog.memo {
//                let label = UILabel()
//                label.text = memo
//                label.font = .preferredFont(forTextStyle: .title3)
//                label.sizeToFit()
//                view.leftCalloutAccessoryView = label
//            }
            return view
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
