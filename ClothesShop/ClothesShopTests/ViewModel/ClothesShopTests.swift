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
}
