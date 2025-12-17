// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct SourcePreferenceChangeInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      checkBoxState: GraphQLNullable<Bool> = nil,
      editTextState: GraphQLNullable<String> = nil,
      listState: GraphQLNullable<String> = nil,
      multiSelectState: GraphQLNullable<[String]> = nil,
      position: Int,
      switchState: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "checkBoxState": checkBoxState,
        "editTextState": editTextState,
        "listState": listState,
        "multiSelectState": multiSelectState,
        "position": position,
        "switchState": switchState
      ])
    }

    var checkBoxState: GraphQLNullable<Bool> {
      get { __data["checkBoxState"] }
      set { __data["checkBoxState"] = newValue }
    }

    var editTextState: GraphQLNullable<String> {
      get { __data["editTextState"] }
      set { __data["editTextState"] = newValue }
    }

    var listState: GraphQLNullable<String> {
      get { __data["listState"] }
      set { __data["listState"] = newValue }
    }

    var multiSelectState: GraphQLNullable<[String]> {
      get { __data["multiSelectState"] }
      set { __data["multiSelectState"] = newValue }
    }

    var position: Int {
      get { __data["position"] }
      set { __data["position"] = newValue }
    }

    var switchState: GraphQLNullable<Bool> {
      get { __data["switchState"] }
      set { __data["switchState"] = newValue }
    }
  }

}