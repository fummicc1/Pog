import SwiftUI

extension Binding {
   func isNotNil<OptionalValue>() -> Binding<Bool> where Value == Optional<OptionalValue> {
       Binding<Bool> {
           wrappedValue != nil
       } set: { isNotNil, _ in
           if !isNotNil {
               wrappedValue = nil
           }
       }
   }
}
