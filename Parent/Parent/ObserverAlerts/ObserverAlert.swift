//
// This file is part of Canvas.
// Copyright (C) 2020-present  Instructure, Inc.
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

import CoreData
import Core

extension ObserverAlert: WriteableModel {
    @discardableResult
    public static func save(_ item: APIObserverAlert, in context: NSManagedObjectContext) -> ObserverAlert {
        let model: ObserverAlert = context.first(where: #keyPath(ObserverAlert.id), equals: item.id.value) ?? context.insert()
        model.actionDate = item.action_date
        model.alertType = item.alert_type
        model.contextID = item.context_id?.value
        model.courseID = item.course_id?.value
        model.htmlURL = item.html_url?.rawValue
        model.id = item.id.value
        model.observerID = item.observer_id.value
        model.thresholdID = item.observer_alert_threshold_id.value
        model.title = item.title
        model.userID = item.user_id.value
        model.workflowState = item.workflow_state
        return model
    }
}
