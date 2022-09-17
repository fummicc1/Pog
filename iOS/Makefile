.PHONY: swift-format
swift-format:
	./BuildTools/swift-format/.build/release/swift-format ./Pog --recursive --in-place


.PHONY: build-swift-format
build-swift-format:
	swift build -c release --package-path BuildTools/swift-format --product swift-format