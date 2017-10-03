// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


@testable import FormsTests
import XCTest

extension FieldsetEntryTests {
  static var allTests = [
    ("testThatKeyGetsSet", testThatKeyGetsSet),
    ("testThatEmptyFieldsetResultsInEmptyNode", testThatEmptyFieldsetResultsInEmptyNode),
    ("testThatNodeContainsAllValues", testThatNodeContainsAllValues),
  ]
}

extension FormFieldTests {
  static var allTests = [
    ("testThatAllValuesCanBeEmpty", testThatAllValuesCanBeEmpty),
    ("testThatAllValuesCanBeSet", testThatAllValuesCanBeSet),
    ("testThatFieldsetFromFormFieldWithValueWithOneErrorSetsError", testThatFieldsetFromFormFieldWithValueWithOneErrorSetsError),
    ("testThatFieldsetFromFormFieldWithValueWithTwoErrorsSetsErrors", testThatFieldsetFromFormFieldWithValueWithTwoErrorsSetsErrors),
    ("testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage", testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage),
    ("testValidationModes", testValidationModes),
  ]
}

extension FormFieldValidationErrorTests {
  static var allTests = [
    ("testThatValidatorErrorConformsToFormFieldValidationError", testThatValidatorErrorConformsToFormFieldValidationError),
    ("testThatErrorListConformsToFormFieldValidationError", testThatErrorListConformsToFormFieldValidationError),
  ]
}

extension FormTests {
  static var allTests = [
    ("testThatMakeFieldsetIncludesAllValues", testThatMakeFieldsetIncludesAllValues),
    ("testThatMakeFieldsetIncludesAllValuesAndErrors", testThatMakeFieldsetIncludesAllValuesAndErrors),
  ]
}

XCTMain([
  testCase(FieldsetEntryTests.allTests),
  testCase(FormFieldTests.allTests),
  testCase(FormFieldValidationErrorTests.allTests),
  testCase(FormTests.allTests),
])
