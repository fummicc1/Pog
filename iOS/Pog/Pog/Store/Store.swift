import Combine
import CoreData
import Foundation

/// @mockable
public protocol Store {
    var searchConfiguration: AnyPublisher<SearchConfiguration, Never> { get }
    var logs: AnyPublisher<[PlaceLogData], Never> { get }
    var interestingPlaceVisitingLogDatas: AnyPublisher<[InterestingPlaceVisitingLogData], Never>
    {
        get
    }
    var interestingPlaces: AnyPublisher<[InterestingPlaceData], Never> { get }
    var locationSettings: AnyPublisher<LocationSettingsData?, Never> { get }
    var context: NSManagedObjectContext { get }

    func deleteWithBatch(_ request: NSBatchDeleteRequest) throws
    func fetch<Obj: NSManagedObject>(type: Obj.Type) throws -> [Obj]
    func updateSearchConfiguration<Value>(
        keypath: WritableKeyPath<SearchConfiguration, Value>,
        value: Value
    )
}

extension Const {
    public enum UserDefaults {
        static let searchedWords = "searchedWords"
        static let numberOfSearchPerDay: String = "numberOfSearchPerDay"
        static let lastSearchedDate: String = "lastSearchedDate"
    }
}

public class StoreImpl {

    private let container = NSPersistentContainer(name: "Pog")

    private let userDefaults: UserDefaults = UserDefaults(suiteName: "group.fummicc1.pog")!

    private let interestingPlaceVisitingLogDatasSubject:
        CurrentValueSubject<[InterestingPlaceVisitingLogData], Never> = .init([])
    private let placeLogDataSubject: CurrentValueSubject<[PlaceLogData], Never> = .init([])
    private let interestingPlacesSubject: CurrentValueSubject<[InterestingPlaceData], Never> =
        .init([])
    private let locationSettingsDataSubject: CurrentValueSubject<LocationSettingsData?, Never> =
        .init(nil)

    private var keyObservers: [String: NSKeyValueObservation] = [:]

    private let searchConfigurationSubject: CurrentValueSubject<SearchConfiguration, Never> =
        .init(
            .init()
        )
    private let que: DispatchQueue = .init(label: "dev.fummicc1.Pog.ios.store")

    private static var numberOfInit: Int = 0

    public init(notificationCenter: NotificationCenter = .default) {
        Self.numberOfInit += 1
        assert(Self.numberOfInit == 1)
        que.async {
            let searchedWordsObservation = self.userDefaults.observe(
                \.searchedWords,
                options: [.initial, .new]
            ) { _, change in
                if let new = change.newValue {
                    var config = self.searchConfigurationSubject.value
                    config.searchedWords = new
                    self.searchConfigurationSubject.send(config)
                }
            }
            self.keyObservers[Const.UserDefaults.searchedWords]?.invalidate()
            self.keyObservers[Const.UserDefaults.searchedWords] =
                searchedWordsObservation

            let numberOfSearchPerDayObservation = self.userDefaults.observe(
                \.numberOfSearchPerDay,
                options: [.initial, .new]
            ) { _, change in
                if let new = change.newValue {
                    var config = self.searchConfigurationSubject.value
                    config.numberOfSearchPerDay = new
                    self.searchConfigurationSubject.send(config)
                }
            }
            self.keyObservers[Const.UserDefaults.numberOfSearchPerDay]?
                .invalidate()
            self.keyObservers[Const.UserDefaults.numberOfSearchPerDay] =
                numberOfSearchPerDayObservation

            let lastSearchedDateObservation = self.userDefaults.observe(
                \.lastSearchedDate,
                options: [.initial, .new]
            ) { _, change in
                if let new = change.newValue {
                    var config = self.searchConfigurationSubject.value
                    if new == 0 {
                        config.lastSearchedDate = nil
                    }
                    else {
                        config.lastSearchedDate = Date.init(
                            timeIntervalSince1970: new
                        )
                    }
                    self.searchConfigurationSubject.send(config)
                }
            }
            self.keyObservers[Const.UserDefaults.lastSearchedDate]?.invalidate()
            self.keyObservers[Const.UserDefaults.lastSearchedDate] =
                lastSearchedDateObservation

            self.container.loadPersistentStores { _, error in
                if let error = error {
                    print(error)
                }
                if let logs = try? self.container.viewContext.fetch(
                    PlaceLogData.fetchRequest()
                ) {
                    self.placeLogDataSubject.send(logs)
                }
                if let places = try? self.container.viewContext.fetch(
                    InterestingPlaceData.fetchRequest()
                ) {
                    self.interestingPlacesSubject.send(places)
                }
                if let locationSettingsData = try? self.container
                    .viewContext.fetch(
                        LocationSettingsData.fetchRequest()
                    )
                {
                    if !locationSettingsData.isEmpty {
                        assert(locationSettingsData.count == 1)
                        self.locationSettingsDataSubject.send(
                            locationSettingsData.last!
                        )
                    }
                }
                if let visitingLogs = try? self.container.viewContext.fetch(
                    InterestingPlaceVisitingLogData.fetchRequest()
                ) {
                    self.interestingPlaceVisitingLogDatasSubject.send(
                        visitingLogs
                    )
                }
            }

            notificationCenter.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: self.context,
                queue: nil
            ) { notification in
                if let added = notification.userInfo?[NSInsertedObjectsKey]
                    as? Set<NSManagedObject>
                {
                    var addedLogs: [PlaceLogData] = []
                    var addedPlaces: [InterestingPlaceData] = []
                    var addedLocationSettingsData: LocationSettingsData?
                    var addedVisitingLogs: [InterestingPlaceVisitingLogData] = []

                    for obj in added {
                        if let log = obj as? PlaceLogData {
                            addedLogs.append(log)
                        }
                        if let place = obj
                            as? InterestingPlaceData
                        {
                            addedPlaces.append(place)
                        }
                        if let locationSettingsData = obj
                            as? LocationSettingsData
                        {
                            addedLocationSettingsData =
                                locationSettingsData
                        }
                        if let visitingLog = obj
                            as? InterestingPlaceVisitingLogData
                        {
                            addedVisitingLogs.append(
                                visitingLog
                            )
                        }
                    }

                    _ = {
                        let all =
                            self.placeLogDataSubject.value
                            + addedLogs
                        self.placeLogDataSubject.send(all)
                    }()
                    _ = {
                        let all =
                            self.interestingPlacesSubject
                            .value + addedPlaces
                        self.interestingPlacesSubject.send(all)
                    }()
                    _ = {
                        self.locationSettingsDataSubject.send(
                            addedLocationSettingsData
                        )
                    }()
                    _ = {
                        let all =
                            self
                            .interestingPlaceVisitingLogDatasSubject
                            .value + addedVisitingLogs
                        self
                            .interestingPlaceVisitingLogDatasSubject
                            .send(all)
                    }()
                }
                if let deleted = notification.userInfo?[NSDeletedObjectsKey]
                    as? Set<
                        NSManagedObject
                    >
                {
                    var deletedLogs: [PlaceLogData] = []
                    var deletedPlaces: [InterestingPlaceData] = []
                    var isDeletedLocationSettingsData: Bool = false

                    for obj in deleted {
                        if let log = obj as? PlaceLogData {
                            deletedLogs.append(log)
                        }
                        if let place = obj
                            as? InterestingPlaceData
                        {
                            deletedPlaces.append(place)
                        }
                        if obj is LocationSettingsData {
                            isDeletedLocationSettingsData =
                                true
                        }
                    }

                    _ = {
                        var current = self
                            .interestingPlacesSubject
                            .value
                        current.removeAll(where: { place in
                            deletedPlaces.map(\.id)
                                .contains(place.id)
                        })
                        self.interestingPlacesSubject.send(
                            current
                        )
                    }()
                    _ = {
                        var current = self.placeLogDataSubject
                            .value
                        current.removeAll(where: {
                            placeLogData in
                            deletedLogs.map(\.id)
                                .contains(
                                    placeLogData
                                        .id
                                )
                        })
                        self.placeLogDataSubject.send(current)
                    }()
                    _ = {
                        if isDeletedLocationSettingsData {
                            self
                                .locationSettingsDataSubject
                                .send(nil)
                        }
                    }()
                }
                if let updated = notification.userInfo?[NSUpdatedObjectsKey]
                    as? Set<
                        NSManagedObject
                    >
                {
                    var updatedLocationSettingsData: LocationSettingsData?
                    var updatedInterestingPlaceVisitingLogDatas: [InterestingPlaceVisitingLogData] =
                        []
                    for obj in updated {
                        if let locationSettingsData = obj
                            as? LocationSettingsData
                        {
                            updatedLocationSettingsData =
                                locationSettingsData
                        }
                        if let visitingLog = obj
                            as? InterestingPlaceVisitingLogData
                        {
                            updatedInterestingPlaceVisitingLogDatas
                                .append(visitingLog)
                        }
                    }
                    if let updatedLocationSettingsData =
                        updatedLocationSettingsData
                    {
                        self.locationSettingsDataSubject.send(
                            updatedLocationSettingsData
                        )
                    }
                    let newInterestingPlaceVisitingLogDatas = Set(
                        updatedInterestingPlaceVisitingLogDatas
                            + self
                            .interestingPlaceVisitingLogDatasSubject
                            .value
                    ).map { $0 }
                    self.interestingPlaceVisitingLogDatasSubject.send(
                        newInterestingPlaceVisitingLogDatas
                    )
                }
            }
        }
    }

    deinit {
        keyObservers.values.forEach { $0.invalidate() }
    }
}

extension StoreImpl: Store {

    public var searchConfiguration: AnyPublisher<SearchConfiguration, Never> {
        searchConfigurationSubject.share().eraseToAnyPublisher()
    }

    public var interestingPlaces: AnyPublisher<[InterestingPlaceData], Never> {
        interestingPlacesSubject.share().eraseToAnyPublisher()
    }

    public var logs: AnyPublisher<[PlaceLogData], Never> {
        placeLogDataSubject.share().eraseToAnyPublisher()
    }

    public var locationSettings: AnyPublisher<LocationSettingsData?, Never> {
        locationSettingsDataSubject.share().eraseToAnyPublisher()
    }

    public var interestingPlaceVisitingLogDatas:
        AnyPublisher<[InterestingPlaceVisitingLogData], Never>
    {
        interestingPlaceVisitingLogDatasSubject.eraseToAnyPublisher()
    }

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    public func deleteWithBatch(_ request: NSBatchDeleteRequest) throws {
        request.resultType = .resultTypeObjectIDs
        let batchResult = try context.execute(request) as? NSBatchDeleteResult
        guard let deleteResult = batchResult?.result as? [NSManagedObjectID] else {
            return
        }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }

    public func fetch<Obj>(type: Obj.Type) throws -> [Obj] where Obj: NSManagedObject {
        let request = Obj.fetchRequest()
        return try context.fetch(request) as? [Obj] ?? []
    }

    public func updateSearchConfiguration<Value>(
        keypath: WritableKeyPath<SearchConfiguration, Value>,
        value: Value
    ) {
        var val = searchConfigurationSubject.value
        val[keyPath: keypath] = value

        // MARK: Save to UserDefaults
        userDefaults.set(
            val.searchedWords,
            forKey: Const.UserDefaults.searchedWords
        )
        userDefaults.set(
            val.numberOfSearchPerDay,
            forKey: Const.UserDefaults.numberOfSearchPerDay
        )
        userDefaults.set(
            val.lastSearchedDate?.timeIntervalSince1970 ?? 0,
            forKey: Const.UserDefaults.lastSearchedDate
        )
    }
}

// MARK: UserDefaults Observation
extension UserDefaults {
    @objc public dynamic var searchedWords: [String] {
        return array(forKey: Const.UserDefaults.searchedWords) as? [String] ?? []
    }
    @objc public dynamic var numberOfSearchPerDay: Int {
        return integer(forKey: Const.UserDefaults.numberOfSearchPerDay)
    }
    @objc public dynamic var lastSearchedDate: Double {
        return double(forKey: Const.UserDefaults.lastSearchedDate)
    }
}
