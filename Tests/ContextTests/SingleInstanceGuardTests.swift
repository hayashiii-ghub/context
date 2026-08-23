import Foundation
import Testing
@testable import Context

struct SingleInstanceGuardTests {
    @Test func onlyOneGuardCanOwnAnApplicationIdentifier() {
        let identifier = "ContextTests.\(UUID().uuidString)"
        let first = SingleInstanceGuard(identifier: identifier)
        let second = SingleInstanceGuard(identifier: identifier)

        #expect(first != nil)
        #expect(second == nil)
    }
}
