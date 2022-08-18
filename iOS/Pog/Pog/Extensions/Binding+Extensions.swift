import SwiftUI

extension Binding {
    func isNotNil<OptionalValue>(readOnly: Bool = false) -> Binding<Bool> where Value == Optional<OptionalValue> {
        Binding<Bool> {
            wrappedValue != nil
        } set: { isNotNil, _ in
            if !isNotNil, !readOnly {
                wrappedValue = nil
            }
        }
    }
}
