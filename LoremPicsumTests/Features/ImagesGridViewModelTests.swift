import XCTest
@testable import LoremPicsum
import Combine

class ImagesGridViewModelTests: XCTestCase {
    private var repository = ImagesRepositoryTypeMock()
    private var viewModel: ImagesGridViewModel!
    private var bag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = ImagesGridViewModel(repository: repository)
    }

    func testLoadMoreActionSuccess() {
        repository.loadImagesListPageClosure = { page in
            if page == 1 { return JSONLoader.loadJSON(named: "imagesList") }
            else { return JSONLoader.loadJSON(named: "imagesList2") }
        }
        viewModel.handleAction(.initialLoad)
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
        viewModel.handleAction(.loadMore(28))
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 60)
        } else {
            XCTFail()
        }
    }
    func testLoadMoreActionError() {
        repository.loadImagesListPageClosure = { page in
            if page == 1 { return JSONLoader.loadJSON(named: "imagesList") }
            else { return Fail(error: APIError.badURL).eraseToAnyPublisher() }
        }
        viewModel.handleAction(.initialLoad)
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
        viewModel.handleAction(.loadMore(28))
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
    }

    func testLoadMoreActionInvalidRow() {
        repository.loadImagesListPageClosure = { page in
            if page == 1 { return JSONLoader.loadJSON(named: "imagesList") }
            else { return JSONLoader.loadJSON(named: "imagesList2") }
        }
        viewModel.handleAction(.initialLoad)
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
        viewModel.handleAction(.loadMore(30))
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
    }

    func testNavigateToImageActionCorrectRow() {
        repository.loadImagesListPageReturnValue = JSONLoader.loadJSON(named: "imagesList")
        viewModel.handleAction(.initialLoad)
        let expectation = self.expectation(description: "navigate")
        viewModel.navigateToImageDetails = { image in
            XCTAssert(image.id == "0")
            expectation.fulfill()
        }
        viewModel.handleAction(.navigateToImage(0))
        wait(for: [expectation], timeout: 10)
    }

    func testNavigateToImageActionInvalidRow() {
        XCTExpectFailure("Should not navigate to image")
        repository.loadImagesListPageReturnValue = JSONLoader.loadJSON(named: "imagesList")
        viewModel.handleAction(.initialLoad)
        let expectation = self.expectation(description: "navigate")
        viewModel.navigateToImageDetails = { image in
            expectation.fulfill()
        }
        viewModel.handleAction(.navigateToImage(100))
        wait(for: [expectation], timeout: 1)
    }

    func testInitialLoadActionSuccess() {
        repository.loadImagesListPageReturnValue = JSONLoader.loadJSON(named: "imagesList")
        XCTAssertFalse(repository.loadImagesListPageCalled)
        viewModel.handleAction(.initialLoad)
        XCTAssert(repository.loadImagesListPageCalled)
        if case let .loaded(images) = viewModel.state {
            XCTAssert(images.count == 30)
        } else {
            XCTFail()
        }
    }

    func testInitialLoadActionError() {
        repository.loadImagesListPageReturnValue = Fail(error: APIError.badURL).eraseToAnyPublisher()
        XCTAssertFalse(repository.loadImagesListPageCalled)
        viewModel.handleAction(.initialLoad)
        XCTAssert(repository.loadImagesListPageCalled)
        if case let .error(error) = viewModel.state {
            XCTAssert(error.errorLabel == "Bad URL")
        } else {
            XCTFail()
        }
    }
}


