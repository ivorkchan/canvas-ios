//
// This file is part of Canvas.
// Copyright (C) 2016-present  Instructure, Inc.
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

import UIKit
import CanvasCore
import Core

class StudentTabBarController: UITabBarController {
    private var previousSelectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewControllers = [
            dashboardTab(),
            calendarTab(),
            todoTab(),
            notificationsTab(),
        ]
        if AppEnvironment.shared.currentSession?.isFakeStudent == false {
            viewControllers?.append(inboxTab())
        }

        let paths = [ "/", "/calendar", "/to-do", "/notifications", "/conversations" ]
        selectedIndex = AppEnvironment.shared.userDefaults?.landingPath
            .flatMap { paths.firstIndex(of: $0) } ?? 0
        tabBar.useGlobalNavStyle()
    }

    func dashboardTab() -> UIViewController {
        let dashboardVC = HelmViewController(moduleName: "/", props: [:])
        let dashboardNav = HelmNavigationController(rootViewController: dashboardVC)
        let dashboardSplit = HelmSplitViewController()
        let emptyNav = UINavigationController(rootViewController: EmptyViewController())
        dashboardNav.delegate = dashboardSplit
        dashboardNav.navigationBar.useGlobalNavStyle()
        dashboardSplit.viewControllers = [dashboardNav, emptyNav]
        dashboardSplit.tabBarItem.title = NSLocalizedString("Dashboard", comment: "dashboard page title")
        dashboardSplit.tabBarItem.image = .dashboardTab
        dashboardSplit.tabBarItem.selectedImage = .dashboardTabActive
        dashboardSplit.tabBarItem.accessibilityIdentifier = "TabBar.dashboardTab"
        dashboardSplit.navigationItem.titleView = Brand.shared.headerImageView()
        return dashboardSplit
    }

    func calendarTab() -> UIViewController {
        let split = HelmSplitViewController()
        split.viewControllers = [
            UINavigationController(rootViewController: PlannerViewController.create()),
            UINavigationController(rootViewController: EmptyViewController()),
        ]
        split.view.tintColor = Brand.shared.primary.ensureContrast(against: .backgroundLightest)
        split.tabBarItem.title = NSLocalizedString("Calendar", comment: "Calendar page title")
        split.tabBarItem.image = .calendarTab
        split.tabBarItem.selectedImage = .calendarTabActive
        split.tabBarItem.accessibilityIdentifier = "TabBar.calendarTab"
        return split
    }

    func todoTab() -> UIViewController {
        let todo = HelmSplitViewController()
        todo.viewControllers = [
            UINavigationController(rootViewController: TodoListViewController.create()),
            UINavigationController(rootViewController: EmptyViewController()),
        ]
        todo.tabBarItem.title = NSLocalizedString("To Do", comment: "Title of the Todo screen")
        todo.tabBarItem.image = .todoTab
        todo.tabBarItem.selectedImage = .todoTabActive
        todo.tabBarItem.accessibilityIdentifier = "TabBar.todoTab"
        return todo
    }

    func notificationsTab() -> UIViewController {
        let split = HelmSplitViewController()
        split.viewControllers = [
            UINavigationController(rootViewController: ActivityStreamViewController.create()),
            UINavigationController(rootViewController: EmptyViewController()),
        ]
        split.tabBarItem.title = NSLocalizedString("Notifications", comment: "Notifications tab title")
        split.tabBarItem.image = .alertsTab
        split.tabBarItem.selectedImage = .alertsTabActive
        split.tabBarItem.accessibilityIdentifier = "TabBar.notificationsTab"
        return split
    }

    func inboxTab() -> UIViewController {
        let inboxVC: UIViewController
        let inboxNav: UINavigationController
        let inboxSplit = HelmSplitViewController()

        if ExperimentalFeature.nativeStudentInbox.isEnabled || ExperimentalFeature.nativeTeacherInbox.isEnabled {
            inboxVC = ConversationsViewController.create()
            inboxNav = UINavigationController(rootViewController: inboxVC)
        } else {
            inboxVC = HelmViewController(moduleName: "/conversations", props: [:])
            inboxNav = HelmNavigationController(rootViewController: inboxVC)
        }

        inboxNav.navigationBar.useGlobalNavStyle()
        inboxVC.navigationItem.titleView = Core.Brand.shared.headerImageView()

        let empty = HelmNavigationController()
        empty.navigationBar.useGlobalNavStyle()

        inboxSplit.viewControllers = [inboxNav, empty]
        let title = NSLocalizedString("Inbox", comment: "Inbox tab title")
        inboxSplit.tabBarItem = UITabBarItem(title: title, image: .inboxTab, selectedImage: .inboxTabActive)
        inboxSplit.tabBarItem.accessibilityIdentifier = "TabBar.inboxTab"
        inboxSplit.extendedLayoutIncludesOpaqueBars = true
        TabBarBadgeCounts.messageItem = inboxSplit.tabBarItem

        return inboxSplit
    }
}

extension StudentTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        tabBarController.resetViewControllerIfSelected(viewController)
        let map = ["dashboard_selected", "calendar_selected", "todo_list_selected", "notifications_selected", "inbox_selected"]
        if let index = viewControllers?.firstIndex(of: viewController),
            selectedViewController != viewController {
            let event = map[index]
            Analytics.shared.logEvent(event)
        }
        return true
    }
}
