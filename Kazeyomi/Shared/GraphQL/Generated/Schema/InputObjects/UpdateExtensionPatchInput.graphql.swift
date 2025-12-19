// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct UpdateExtensionPatchInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      install: GraphQLNullable<Bool> = nil,
      uninstall: GraphQLNullable<Bool> = nil,
      update: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "install": install,
        "uninstall": uninstall,
        "update": update
      ])
    }

    var install: GraphQLNullable<Bool> {
      get { __data["install"] }
      set { __data["install"] = newValue }
    }

    var uninstall: GraphQLNullable<Bool> {
      get { __data["uninstall"] }
      set { __data["uninstall"] = newValue }
    }

    var update: GraphQLNullable<Bool> {
      get { __data["update"] }
      set { __data["update"] = newValue }
    }
  }

}