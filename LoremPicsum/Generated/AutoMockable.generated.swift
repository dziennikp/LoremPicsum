// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine















class ImagesRepositoryTypeMock: ImagesRepositoryType {

    //MARK: - loadImagesList

    var loadImagesListPageCallsCount = 0
    var loadImagesListPageCalled: Bool {
        return loadImagesListPageCallsCount > 0
    }
    var loadImagesListPageReceivedPage: Int?
    var loadImagesListPageReceivedInvocations: [Int] = []
    var loadImagesListPageReturnValue: AnyPublisher<[Image], APIError>!
    var loadImagesListPageClosure: ((Int) -> AnyPublisher<[Image], APIError>)?

    func loadImagesList(page: Int) -> AnyPublisher<[Image], APIError> {
        loadImagesListPageCallsCount += 1
        loadImagesListPageReceivedPage = page
        loadImagesListPageReceivedInvocations.append(page)
        return loadImagesListPageClosure.map({ $0(page) }) ?? loadImagesListPageReturnValue
    }

}
