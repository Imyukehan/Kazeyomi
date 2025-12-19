// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct UpdateMangaCategoriesPatchInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      addToCategories: GraphQLNullable<[Int]> = nil,
      clearCategories: GraphQLNullable<Bool> = nil,
      removeFromCategories: GraphQLNullable<[Int]> = nil
    ) {
      __data = InputDict([
        "addToCategories": addToCategories,
        "clearCategories": clearCategories,
        "removeFromCategories": removeFromCategories
      ])
    }

    var addToCategories: GraphQLNullable<[Int]> {
      get { __data["addToCategories"] }
      set { __data["addToCategories"] = newValue }
    }

    var clearCategories: GraphQLNullable<Bool> {
      get { __data["clearCategories"] }
      set { __data["clearCategories"] = newValue }
    }

    var removeFromCategories: GraphQLNullable<[Int]> {
      get { __data["removeFromCategories"] }
      set { __data["removeFromCategories"] = newValue }
    }
  }

}