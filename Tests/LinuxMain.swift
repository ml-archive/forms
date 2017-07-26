// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


@testable import FormsTests
import XCTest

extension FieldSetEntryTests {
  static var allTests = [
    ("testThatKeyGetsSet", testThatKeyGetsSet),
    ("testThatEmptyFieldSetResultsInEmptyNode", testThatEmptyFieldSetResultsInEmptyNode),
    ("testThatNodeContainsAllValues", testThatNodeContainsAllValues),
    ("testThatFieldSetEntryWithoutErrorsIsValid", testThatFieldSetEntryWithoutErrorsIsValid),
    ("testThatFieldSetEntryWithErrorsIsInvalid", testThatFieldSetEntryWithErrorsIsInvalid),
  ]
}

extension FormFieldTests {
  static var allTests = [
    ("testThatAllValuesCanBeEmpty", testThatAllValuesCanBeEmpty),
    ("testThatAllValuesCanBeSet", testThatAllValuesCanBeSet),
    ("testThatFieldSetFromFormFieldWithValueWithOneErrorSetsError", testThatFieldSetFromFormFieldWithValueWithOneErrorSetsError),
    ("testThatFieldSetFromFormFieldWithValueWithTwoErrorsSetsErrors", testThatFieldSetFromFormFieldWithValueWithTwoErrorsSetsErrors),
    ("testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage", testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage),
    ("testThatNonOptionalFormFieldWithoutLabelOrValueProducesGenericError", testThatNonOptionalFormFieldWithoutLabelOrValueProducesGenericError),
    ("testThatNonOptionalFormFieldWithLabelAndNoValueProducesErrorWithLabelInMessage", testThatNonOptionalFormFieldWithLabelAndNoValueProducesErrorWithLabelInMessage),
    ("testThatOutputValueGetsTransformed", testThatOutputValueGetsTransformed),
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
    ("testThatMakeFieldSetIncludesAllValues", testThatMakeFieldSetIncludesAllValues),
    ("testThatMakeFieldSetIncludesAllValuesAndErrors", testThatMakeFieldSetIncludesAllValuesAndErrors),
  ]
}

XCTMain([
  testCase(FieldSetEntryTests.allTests),
  testCase(FormFieldTests.allTests),
  testCase(FormFieldValidationErrorTests.allTests),
  testCase(FormTests.allTests),
])
