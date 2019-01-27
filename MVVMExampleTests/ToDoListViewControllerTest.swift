//
//  ToDoListViewControllerTest.swift
//  MVVMExampleTests
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

@testable import MVVMExample
import Nimble
import Quick
import XCTest
import SpecLeaks

class ToDoListViewControllerTest: QuickSpec {
    override func spec() {
        describe("ToDoListViewController") {
            describe("viewDidLoad") {
                
                let test = LeakTest {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ToDoListViewController")
                    return controller as! ToDoListViewController
                }

                it("must not leak"){
                    expect(test).toNot(leak())
                }
            }
        }
    }
}
