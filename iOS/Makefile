.PHONY: swift-format
swift-format:
	./BuildTools/swift-format/.build/release/swift-format ./Pog --recursive --in-place

.PHONY: generate-mock
generate-mock: build-mockolo
	./BuildTools/mockolo/.build/release/mockolo -s ./Pog/Pog -d ./Pog/Pog/Mock/Generated/GeneratedMock.swift

.PHONY: swiftgen
swiftgen: build-swiftgen
	./BuildTools/swiftgen/.build/release/swiftgen

.PHONY: build-BuildTools
build-BuildTools:
	make build-swift-format build-swiftgen build-mockolo

.PHONY: bootstrap
bootstrap:
	./install_mint.sh	
	git submodule update --init --recursive
	make build-BuildTools
	mint bootstrap --mintfile Pog/Mintfile

build-swift-format:
	swift build -c release --package-path ./BuildTools/swift-format --product swift-format

build-swiftgen:
	swift build -c release --package-path ./BuildTools/swiftgen --product swiftgen

build-mockolo:
	swift build -c release --package-path ./BuildTools/mockolo --product mockolo

.PHONY: build
build:
	xcodebuild -project ./Pog/Pog.xcodeproj -scheme Pog build -destination 'platform=iOS Simulator,name=iPhone 13'

.PHONY: clean
clean:
	xcodebuild -project ./Pog/Pog.xcodeproj -scheme Pog clean -destination 'platform=iOS Simulator,name=iPhone 13'

.PHONY: test
test:
	xcodebuild -project ./Pog/Pog.xcodeproj -scheme Pog test -destination 'platform=iOS Simulator,name=iPhone 13'

