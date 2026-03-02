import XCTest
import RxSwift
import RxCocoa
import Moya
@testable import ClothesShop

final class NotificationsViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }
    
    func test_loadTrigger_success_fetchesAndEmitsSections() {

        // GIVEN
        let mockJSON = """
        [
            {
                "sectionDate": "Today",
                "items": [
                    {
                        "id": "1",
                        "title": "Order Shipped",
                        "description": "Your clothes are on the way!",
                        "isRead": false,
                        "iconType": "shipping"
                    }
                ]
            }
        ]
        """.data(using: .utf8)!

        let provider = MoyaProvider<EcommerceAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, mockJSON) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: { _ in .delayed(seconds: 0.01) } // 👈 tránh malloc bug
        )

        let viewModel = NotificationsViewModel(provider: provider)

        var fetchedSections: [NotificationSection] = []
        let expectation = self.expectation(description: "Fetched sections")

        // WHEN
        viewModel.outputs.sections
            .skip(1) 
            .drive(onNext: { sections in
                fetchedSections = sections
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.inputs.loadTrigger.onNext(())

        // THEN
        waitForExpectations(timeout: 2.0)

        XCTAssertEqual(fetchedSections.count, 1)
        XCTAssertEqual(fetchedSections.first?.sectionDate, "Today")
        XCTAssertEqual(fetchedSections.first?.items.first?.title, "Order Shipped")
    }
    
    func test_loadTrigger_failure_emitsErrorAndEmptySections() {

        // GIVEN
        let provider = MoyaProvider<EcommerceAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: {
                        .networkError(NSError(domain: "TestError", code: -1))
                    },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: { _ in .immediate }
        )

        let viewModel = NotificationsViewModel(provider: provider)

        var receivedError: String?
        var receivedSections: [NotificationSection] = []
        
        let errorExpectation = expectation(description: "Error emitted")
        let sectionExpectation = expectation(description: "Sections emitted")

        viewModel.outputs.error
            .emit(onNext: { error in
                receivedError = error
                errorExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.sections
            .skip(1)
            .drive(onNext: { sections in
                receivedSections = sections
                sectionExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        // WHEN
        viewModel.inputs.loadTrigger.onNext(())

        // THEN
        waitForExpectations(timeout: 2.0)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedSections.count, 0)
    }
    
    func test_loadTrigger_emitsLoadingStateCorrectly() {

        // GIVEN
        let mockJSON = "[]".data(using: .utf8)!

        let provider = MoyaProvider<EcommerceAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, mockJSON) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: { _ in .delayed(seconds: 0.01) }
        )

        let viewModel = NotificationsViewModel(provider: provider)

        var loadingStates: [Bool] = []
        let expectation = self.expectation(description: "Loading states")

        viewModel.outputs.isLoading
            .skip(1) 
            .drive(onNext: { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // WHEN
        viewModel.inputs.loadTrigger.onNext(())

        // THEN
        waitForExpectations(timeout: 2.0)

        XCTAssertEqual(loadingStates[0], true)
        XCTAssertEqual(loadingStates[1], false)
    }
    func test_loadTrigger_emptyResponse_emitsEmptySections() {

        // GIVEN
        let emptyJSON = "[]".data(using: .utf8)!

        let provider = MoyaProvider<EcommerceAPI>(
            endpointClosure: { target in
                Endpoint(
                    url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, emptyJSON) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: { _ in .immediate }
        )

        let viewModel = NotificationsViewModel(provider: provider)

        var sections: [NotificationSection] = []
        let expectation = self.expectation(description: "Empty emitted")

        viewModel.outputs.sections
            .skip(1)
            .drive(onNext: { value in
                sections = value
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // WHEN
        viewModel.inputs.loadTrigger.onNext(())

        // THEN
        waitForExpectations(timeout: 2.0)

        XCTAssertTrue(sections.isEmpty)
    }
}
