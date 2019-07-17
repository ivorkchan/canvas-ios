//
// This file is part of Canvas.
// Copyright (C) 2017-present  Instructure, Inc.
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

import ReactiveSwift
import Marshal


extension UserEnrollment {
    public static func getUsers(enrolledInCourseWithID courseID: String, session: Session) throws -> SignalProducer<[JSONObject], NSError> {
        
        let parameters: [String: Any] = ["include": ["avatar_url"]]
        let path = "\(ContextID.course(withID: courseID).apiPath)/enrollments"
        let request = try session.GET(path, parameters: parameters)
        return session.paginatedJSONSignalProducer(request)
    }
}
