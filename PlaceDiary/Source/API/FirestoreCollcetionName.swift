//
//  FirestoreCollcetionName.swift
//  ToiletMap
//
//  Created by Fumiya Tanaka on 2020/01/02.
//

import Foundation

enum FirestoreCollcetionName: String {
	#if DEBUG
	case diaries = "diaries_debug"
	#else
	case diaries
	#endif
}
