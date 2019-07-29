//
// This file is part of Canvas.
// Copyright (C) 2018-present  Instructure, Inc.
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

import Foundation

// https://canvas.instructure.com/doc/api/assignments.html#method.assignments_api.show
public struct GetAssignmentRequest: APIRequestable {
    public typealias Response = APIAssignment

    let courseID: String
    let assignmentID: String
    let include: [GetAssignmentInclude]

    public enum GetAssignmentInclude: String {
        case submission
    }

    public var path: String {
        let context = ContextModel(.course, id: courseID)
        return "\(context.pathComponent)/assignments/\(assignmentID)"
    }

    public var query: [APIQueryItem] {
        var include = self.include.map { $0.rawValue }
        include.append("observed_users")
        return [ .array("include", include) ]
    }
}

struct APIAssignmentParameters: Codable, Equatable {
    let name: String
    let description: String?
    let points_possible: Double
    let due_at: Date?
    let submission_types: [SubmissionType]
    let allowed_extensions: [String]
    let published: Bool
    let grading_type: GradingType
    let lock_at: Date?
    let unlock_at: Date?
}

// https://canvas.instructure.com/doc/api/assignments.html#method.assignments_api.create
struct PostAssignmentRequest: APIRequestable {
    typealias Response = APIAssignment
    struct Body: Codable, Equatable {
        let assignment: APIAssignmentParameters
    }

    let courseID: String

    let body: Body?
    let method = APIMethod.post
    public var path: String {
        let context = ContextModel(.course, id: courseID)
        return "\(context.pathComponent)/assignments"
    }
}

// https://canvas.instructure.com/doc/api/assignments.html#method.assignments_api.index
public struct GetAssignmentsRequest: APIRequestable {
    public enum OrderBy: String {
        case position, name
    }

    public typealias Response = [APIAssignment]

    let courseID: String
    let orderBy: OrderBy

    public init(courseID: String, orderBy: OrderBy = .position) {
        self.courseID = courseID
        self.orderBy = orderBy
    }

    public var path: String {
        let context = ContextModel(.course, id: courseID)
        return "\(context.pathComponent)/assignments?per_page=100"
    }

    public var query: [APIQueryItem] {
        return [
            .value("order_by", orderBy.rawValue),
        ]
    }
}
