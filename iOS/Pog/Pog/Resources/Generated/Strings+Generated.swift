// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Common.Cancel", fallback: #"Cancel"#)
    /// Close
    internal static let close = L10n.tr("Localizable", "Common.Close", fallback: #"Close"#)
    /// Complete
    internal static let complete = L10n.tr("Localizable", "Common.Complete", fallback: #"Complete"#)
    /// Confirm with Settings app
    internal static let confirmWithSettings = L10n.tr("Localizable", "Common.ConfirmWithSettings", fallback: #"Confirm with Settings app"#)
    /// Default
    internal static let `default` = L10n.tr("Localizable", "Common.Default", fallback: #"Default"#)
    /// Delete
    internal static let delete = L10n.tr("Localizable", "Common.Delete", fallback: #"Delete"#)
    /// Departed At
    internal static let departureTime = L10n.tr("Localizable", "Common.DepartureTime", fallback: #"Departed At"#)
    /// Display Mode
    internal static let displayMode = L10n.tr("Localizable", "Common.DisplayMode", fallback: #"Display Mode"#)
    /// DONE
    internal static let done = L10n.tr("Localizable", "Common.DONE", fallback: #"DONE"#)
    /// Email Adress
    internal static let emailAddress = L10n.tr("Localizable", "Common.EmailAddress", fallback: #"Email Adress"#)
    /// Environment
    internal static let environment = L10n.tr("Localizable", "Common.Environment", fallback: #"Environment"#)
    /// Error Occured
    internal static let errorOccured = L10n.tr("Localizable", "Common.ErrorOccured", fallback: #"Error Occured"#)
    /// Need to fill out required form
    internal static let inadequateStatus = L10n.tr("Localizable", "Common.InadequateStatus", fallback: #"Need to fill out required form"#)
    /// Log
    internal static let log = L10n.tr("Localizable", "Common.Log", fallback: #"Log"#)
    /// Map
    internal static let map = L10n.tr("Localizable", "Common.Map", fallback: #"Map"#)
    /// Message
    internal static let message = L10n.tr("Localizable", "Common.Message", fallback: #"Message"#)
    /// Open Settings
    internal static let openSettings = L10n.tr("Localizable", "Common.OpenSettings", fallback: #"Open Settings"#)
    /// Optional
    internal static let `optional` = L10n.tr("Localizable", "Common.Optional", fallback: #"Optional"#)
    /// Required
    internal static let `required` = L10n.tr("Localizable", "Common.Required", fallback: #"Required"#)
    /// Save
    internal static let save = L10n.tr("Localizable", "Common.Save", fallback: #"Save"#)
    /// Select Date
    internal static let selectDate = L10n.tr("Localizable", "Common.SelectDate", fallback: #"Select Date"#)
    /// Send
    internal static let send = L10n.tr("Localizable", "Common.Send", fallback: #"Send"#)
    /// Unknown
    internal static let unknown = L10n.tr("Localizable", "Common.Unknown", fallback: #"Unknown"#)
    /// Visit
    internal static let visit = L10n.tr("Localizable", "Common.Visit", fallback: #"Visit"#)
    /// Visited At
    internal static let visitingTime = L10n.tr("Localizable", "Common.VisitingTime", fallback: #"Visited At"#)
  }
  internal enum InquiryFormPage {
    /// Feature Request / Inquiry
    internal static let title = L10n.tr("Localizable", "InquiryFormPage.Title", fallback: #"Feature Request / Inquiry"#)
    internal enum Form {
      /// Complete sending message. Thank you!
      internal static let complete = L10n.tr("Localizable", "InquiryFormPage.Form.Complete", fallback: #"Complete sending message. Thank you!"#)
      /// Please write down the message
      internal static let message = L10n.tr("Localizable", "InquiryFormPage.Form.Message", fallback: #"Please write down the message"#)
    }
  }
  internal enum InterestingPlaceVisitingListView {
    internal enum InterestingPlace {
      /// failed to find registered place's name.
      internal static let emptyList = L10n.tr("Localizable", "InterestingPlaceVisitingListView.InterestingPlace.EmptyList", fallback: #"failed to find registered place's name."#)
      /// Registered Places
      internal static let places = L10n.tr("Localizable", "InterestingPlaceVisitingListView.InterestingPlace.Places", fallback: #"Registered Places"#)
    }
    internal enum Place {
      /// There is no visiting yet.
      internal static let noVisitingHistoryYet = L10n.tr("Localizable", "InterestingPlaceVisitingListView.Place.NoVisitingHistoryYet", fallback: #"There is no visiting yet."#)
      /// • Visiting History
      internal static let visitingHistory = L10n.tr("Localizable", "InterestingPlaceVisitingListView.Place.VisitingHistory", fallback: #"• Visiting History"#)
      /// • Visiting History（Latest ten）
      internal static let visitingHistoryTen = L10n.tr("Localizable", "InterestingPlaceVisitingListView.Place.VisitingHistory (Ten)", fallback: #"• Visiting History（Latest ten）"#)
    }
  }
  internal enum MapView {
    internal enum Location {
      /// Pog has a feature to keep a log of location. Please allow location request to use these features.
      internal static let authorizeRecommendation = L10n.tr("Localizable", "MapView.Location.AuthorizeRecommendation", fallback: #"Pog has a feature to keep a log of location. Please allow location request to use these features."#)
      /// To Use Pog confortably
      internal static let toUseConfortably = L10n.tr("Localizable", "MapView.Location.ToUseConfortably", fallback: #"To Use Pog confortably"#)
    }
    internal enum Place {
      /// failed to fetch place's name.
      internal static let failedToFetch = L10n.tr("Localizable", "MapView.Place.FailedToFetch", fallback: #"failed to fetch place's name."#)
      /// Register Notification
      internal static let registerNotification = L10n.tr("Localizable", "MapView.Place.RegisterNotification", fallback: #"Register Notification"#)
      /// Find a Place to Notify
      internal static let searchPlacesToRegister = L10n.tr("Localizable", "MapView.Place.SearchPlacesToRegister", fallback: #"Find a Place to Notify"#)
    }
  }
  internal enum PlaceLogPage {
    internal enum Alert {
      internal enum DeleteConfirmance {
        /// Do you delete logs in %@ ?
        internal static func title(_ p1: Any) -> String {
          return L10n.tr("Localizable", "PlaceLogPage.Alert.DeleteConfirmance.Title", String(describing: p1), fallback: #"Do you delete logs in %@ ?"#)
        }
      }
    }
    internal enum Buttons {
      /// Delete Logs
      internal static let deleteForSelectedDate = L10n.tr("Localizable", "PlaceLogPage.Buttons.DeleteForSelectedDate", fallback: #"Delete Logs"#)
    }
    internal enum Place {
      /// Empty Location Log
      internal static let empty = L10n.tr("Localizable", "PlaceLogPage.Place.Empty", fallback: #"Empty Location Log"#)
    }
  }
  internal enum SearchPlaceModel {
    internal enum Notification {
      /// confirm with app
      internal static let confirmWithApp = L10n.tr("Localizable", "SearchPlaceModel.Notification.ConfirmWithApp", fallback: #"confirm with app"#)
      internal enum InterestingPlace {
        /// registered Place
        internal static let defaultName = L10n.tr("Localizable", "SearchPlaceModel.Notification.InterestingPlace.DefaultName", fallback: #"registered Place"#)
        /// is near
        internal static let existNearBy = L10n.tr("Localizable", "SearchPlaceModel.Notification.InterestingPlace.ExistNearBy", fallback: #"is near"#)
      }
    }
  }
  internal enum SearchPlacePage {
    internal enum Notification {
      /// Disable Notification
      internal static let disable = L10n.tr("Localizable", "SearchPlacePage.Notification.Disable", fallback: #"Disable Notification"#)
      /// Distance for Notification to be Triggered
      internal static let distanceToTrigger = L10n.tr("Localizable", "SearchPlacePage.Notification.DistanceToTrigger", fallback: #"Distance for Notification to be Triggered"#)
      /// Enable Notification
      internal static let enable = L10n.tr("Localizable", "SearchPlacePage.Notification.Enable", fallback: #"Enable Notification"#)
    }
  }
  internal enum SettingsModel {
    internal enum Authorization {
      /// always
      internal static let always = L10n.tr("Localizable", "SettingsModel.Authorization.Always", fallback: #"always"#)
      /// confirm next time
      internal static let confirmNextTime = L10n.tr("Localizable", "SettingsModel.Authorization.ConfirmNextTime", fallback: #"confirm next time"#)
      /// deny
      internal static let notAuthorized = L10n.tr("Localizable", "SettingsModel.Authorization.NotAuthorized", fallback: #"deny"#)
      /// authorize while app is in use
      internal static let whileInUse = L10n.tr("Localizable", "SettingsModel.Authorization.WhileInUse", fallback: #"authorize while app is in use"#)
    }
    internal enum Location {
      /// fuzzy location
      internal static let fuzzyLocation = L10n.tr("Localizable", "SettingsModel.Location.FuzzyLocation", fallback: #"fuzzy location"#)
      /// precise location
      internal static let preciseLocation = L10n.tr("Localizable", "SettingsModel.Location.PreciseLocation", fallback: #"precise location"#)
    }
  }
  internal enum SettingsPage {
    internal enum Alert {
      /// Delete
      internal static let delete = L10n.tr("Localizable", "SettingsPage.Alert.Delete", fallback: #"Delete"#)
      /// Do you want to clear the log completely?
      internal static let doesDeleteAllLogsTotally = L10n.tr("Localizable", "SettingsPage.Alert.DoesDeleteAllLogsTotally", fallback: #"Do you want to clear the log completely?"#)
      /// Do you want to completely clear the notification?
      internal static let doesDeleteAllNotificationTotally = L10n.tr("Localizable", "SettingsPage.Alert.DoesDeleteAllNotificationTotally", fallback: #"Do you want to completely clear the notification?"#)
    }
    internal enum Data {
      /// About User's Data
      internal static let about = L10n.tr("Localizable", "SettingsPage.Data.About", fallback: #"About User's Data"#)
      /// Totally Delete All Logs
      internal static let totallyDeleteAllLogs = L10n.tr("Localizable", "SettingsPage.Data.TotallyDeleteAllLogs", fallback: #"Totally Delete All Logs"#)
      /// Totally Delete All Notifications for Places
      internal static let totallyDeleteAllNotifications = L10n.tr("Localizable", "SettingsPage.Data.TotallyDeleteAllNotifications", fallback: #"Totally Delete All Notifications for Places"#)
    }
    internal enum Location {
      /// About User's Location
      internal static let about = L10n.tr("Localizable", "SettingsPage.Location.About", fallback: #"About User's Location"#)
      /// Accuracy（meter）
      internal static let accuracyUnitMeter = L10n.tr("Localizable", "SettingsPage.Location.Accuracy_unit_meter", fallback: #"Accuracy（meter）"#)
      /// Location Authorized Status
      internal static let authorizeStatus = L10n.tr("Localizable", "SettingsPage.Location.AuthorizeStatus", fallback: #"Location Authorized Status"#)
      /// The smaller the number, the more accurate the recording.
      internal static let lessTheNumberIsMoreAccurateRecordedLocationIs = L10n.tr("Localizable", "SettingsPage.Location.Less the number is, more accurate recorded location is.", fallback: #"The smaller the number, the more accurate the recording."#)
      /// If you turn it off, location information will not be recorded if the app is not running.
      internal static let messageAboutUpdateOnBackground = L10n.tr("Localizable", "SettingsPage.Location.MessageAboutUpdateOnBackground", fallback: #"If you turn it off, location information will not be recorded if the app is not running."#)
      /// Location Privacy
      internal static let privacy = L10n.tr("Localizable", "SettingsPage.Location.Privacy", fallback: #"Location Privacy"#)
      /// Location Update on Background
      internal static let updateOnBackground = L10n.tr("Localizable", "SettingsPage.Location.UpdateOnBackground", fallback: #"Location Update on Background"#)
    }
    internal enum Pog {
      /// About Pog
      internal static let about = L10n.tr("Localizable", "SettingsPage.Pog.About", fallback: #"About Pog"#)
      /// About Pog（Feature）
      internal static let aboutFeatures = L10n.tr("Localizable", "SettingsPage.Pog.AboutFeatures", fallback: #"About Pog（Feature）"#)
      /// Feedback
      internal static let feedback = L10n.tr("Localizable", "SettingsPage.Pog.Feedback", fallback: #"Feedback"#)
      /// Feature Request / Inquiry
      internal static let inquiry = L10n.tr("Localizable", "SettingsPage.Pog.Inquiry", fallback: #"Feature Request / Inquiry"#)
      /// Review Pog
      internal static let review = L10n.tr("Localizable", "SettingsPage.Pog.Review", fallback: #"Review Pog"#)
    }
  }
  internal enum WalkthroughPage {
    internal enum First {
      /// Always allow location request
      internal static let authorizeAlwaysLocationRequest = L10n.tr("Localizable", "WalkthroughPage.First.AuthorizeAlwaysLocationRequest", fallback: #"Always allow location request"#)
      /// Pog is an application that constantly records the user's location. You will also be notified that you are currently visiting the registered location.
      internal static let headline = L10n.tr("Localizable", "WalkthroughPage.First.Headline", fallback: #"Pog is an application that constantly records the user's location. You will also be notified that you are currently visiting the registered location."#)
      /// Location request is always allowed
      internal static let locationRequestIsAlwaysAuthorized = L10n.tr("Localizable", "WalkthroughPage.First.LocationRequestIsAlwaysAuthorized", fallback: #"Location request is always allowed"#)
      /// When using the location tracking feature, it is necessary to set the location request authorization to "Always allow" from the Settings app. Location data is not stored in the cloud, only on the local device.
      internal static let message = L10n.tr("Localizable", "WalkthroughPage.First.Message", fallback: #"When using the location tracking feature, it is necessary to set the location request authorization to "Always allow" from the Settings app. Location data is not stored in the cloud, only on the local device."#)
      /// What is Pog（1/3）
      internal static let title = L10n.tr("Localizable", "WalkthroughPage.First.Title", fallback: #"What is Pog（1/3）"#)
    }
    internal enum Page {
      /// About Location tracking feature
      internal static let aboutLocationTrackingFeature = L10n.tr("Localizable", "WalkthroughPage.Page.AboutLocationTrackingFeature", fallback: #"About Location tracking feature"#)
      /// About User's Location
      internal static let location = L10n.tr("Localizable", "WalkthroughPage.Page.Location", fallback: #"About User's Location"#)
      /// About Notification feature
      internal static let notification = L10n.tr("Localizable", "WalkthroughPage.Page.Notification", fallback: #"About Notification feature"#)
      /// What is Pog?
      internal static let pog = L10n.tr("Localizable", "WalkthroughPage.Page.Pog", fallback: #"What is Pog?"#)
    }
    internal enum Second {
      /// If the location registered from the "Map" screen is within 300 meters from your current location, you can receive a notification from the app.
      internal static let message = L10n.tr("Localizable", "WalkthroughPage.Second.Message", fallback: #"If the location registered from the "Map" screen is within 300 meters from your current location, you can receive a notification from the app."#)
      /// Notification feature（2/3）
      internal static let title = L10n.tr("Localizable", "WalkthroughPage.Second.Title", fallback: #"Notification feature（2/3）"#)
    }
    internal enum Third {
      /// Introducing a feature that constantly records the user's location. Location tracking is completely activated by setting Pog's location to "Always Allow" from iOS settings. In addition, the log when a certain time elapses or a distance movement occurs is also displayed as a map-pin.
      internal static let message = L10n.tr("Localizable", "WalkthroughPage.Third.Message", fallback: #"Introducing a feature that constantly records the user's location. Location tracking is completely activated by setting Pog's location to "Always Allow" from iOS settings. In addition, the log when a certain time elapses or a distance movement occurs is also displayed as a map-pin."#)
      /// Location Tracking feature（3/3）
      internal static let title = L10n.tr("Localizable", "WalkthroughPage.Third.Title", fallback: #"Location Tracking feature（3/3）"#)
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
