.PHONY: swift-format
swift-format:
	./BuildTools/swift-format/.build/release/swift-format ./Pog --recursive --in-place


.PHONY: build-swift-format
build-swift-format:
	swift build -c release --package-path BuildTools/swift-format --product swift-format

.PHONY: build
build:
	xcodebuild -project Pog/Pog.xcodeproj -scheme Pog build -destination 'platform=iOS Simulator,name=iPhone 13'

.PHONY: clean
clean:
	xcodebuild -project Pog/Pog.xcodeproj -scheme Pog clean -destination 'platform=iOS Simulator,name=iPhone 13'

.PHONY: test
test:
	xcodebuild -project Pog/Pog.xcodeproj -scheme Pog test -destination 'platform=iOS Simulator,name=iPhone 13'