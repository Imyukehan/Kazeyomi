// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct FilterChangeInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      checkBoxState: GraphQLNullable<Bool> = nil,
      groupChange: GraphQLNullable<FilterChangeInput> = nil,
      position: Int,
      selectState: GraphQLNullable<Int> = nil,
      sortState: GraphQLNullable<SortSelectionInput> = nil,
      textState: GraphQLNullable<String> = nil,
      triState: GraphQLNullable<GraphQLEnum<TriState>> = nil
    ) {
      __data = InputDict([
        "checkBoxState": checkBoxState,
        "groupChange": groupChange,
        "position": position,
        "selectState": selectState,
        "sortState": sortState,
        "textState": textState,
        "triState": triState
      ])
    }

    var checkBoxState: GraphQLNullable<Bool> {
      get { __data["checkBoxState"] }
      set { __data["checkBoxState"] = newValue }
    }

    var groupChange: GraphQLNullable<FilterChangeInput> {
      get { __data["groupChange"] }
      set { __data["groupChange"] = newValue }
    }

    var position: Int {
      get { __data["position"] }
      set { __data["position"] = newValue }
    }

    var selectState: GraphQLNullable<Int> {
      get { __data["selectState"] }
      set { __data["selectState"] = newValue }
    }

    var sortState: GraphQLNullable<SortSelectionInput> {
      get { __data["sortState"] }
      set { __data["sortState"] = newValue }
    }

    var textState: GraphQLNullable<String> {
      get { __data["textState"] }
      set { __data["textState"] = newValue }
    }

    var triState: GraphQLNullable<GraphQLEnum<TriState>> {
      get { __data["triState"] }
      set { __data["triState"] = newValue }
    }
  }

}