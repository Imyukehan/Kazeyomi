// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct UpdateMangaPatchInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      inLibrary: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "inLibrary": inLibrary
      ])
    }

    var inLibrary: GraphQLNullable<Bool> {
      get { __data["inLibrary"] }
      set { __data["inLibrary"] = newValue }
    }
  }

}