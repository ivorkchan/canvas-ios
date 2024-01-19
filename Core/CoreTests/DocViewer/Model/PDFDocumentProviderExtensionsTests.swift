//
// This file is part of Canvas.
// Copyright (C) 2024-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

@testable import Core
import XCTest

class PDFDocumentProviderExtensionsTests: CoreTestCase {

    func testRotationAppliedFromDocviewerMetadata() {
        let providers = getProviders()
        XCTAssertEqual(providers.documentProvider.pageInfoForPage(at: 0)?.rotationOffset.rawValue, 0)
        let docViewerRotationMetadata = APIDocViewerMetadata(annotations: nil,
                                                             panda_push: nil,
                                                             rotations: ["0": 90],
                                                             urls: .init(pdf_download: URL(string: "/")!))

        // WHEN
        providers.documentProvider.applyRotation(from: docViewerRotationMetadata)

        // THEN
        XCTAssertEqual(providers.documentProvider.pageInfoForPage(at: 0)?.rotationOffset.rawValue, 90)
    }
}
