//
//  AppError.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import Foundation

enum AppError: Error {
	case emptyResponseData
	case someError(Error)
}
