import Testing
@testable import RemoSwift

@Test func remoHasDefaultPort() {
    #expect(Remo.defaultPort == 9930)
}
