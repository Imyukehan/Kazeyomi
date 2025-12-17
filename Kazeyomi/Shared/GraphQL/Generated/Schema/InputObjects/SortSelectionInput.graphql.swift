// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct SortSelectionInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      ascending: Bool,
      index: Int
    ) {
      __data = InputDict([
        "ascending": ascending,
        "index": index
      ])
    }

    var ascending: Bool {
      get { __data["ascending"] }
      set { __data["ascending"] = newValue }
    }

    var index: Int {
      get { __data["index"] }
      set { __data["index"] = newValue }
    }
  }

}