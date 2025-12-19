// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class UpdateExtensionMutation: GraphQLMutation {
    static let operationName: String = "UpdateExtension"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateExtension($id: String!, $patch: UpdateExtensionPatchInput!) { updateExtension(input: { id: $id, patch: $patch }) { __typename extension { __typename pkgName name lang versionName versionCode iconUrl isInstalled hasUpdate isObsolete isNsfw repo apkName } } }"#
      ))

    public var id: String
    public var patch: UpdateExtensionPatchInput

    public init(
      id: String,
      patch: UpdateExtensionPatchInput
    ) {
      self.id = id
      self.patch = patch
    }

    public var __variables: Variables? { [
      "id": id,
      "patch": patch
    ] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("updateExtension", UpdateExtension?.self, arguments: ["input": [
          "id": .variable("id"),
          "patch": .variable("patch")
        ]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateExtensionMutation.Data.self
      ] }

      var updateExtension: UpdateExtension? { __data["updateExtension"] }

      /// UpdateExtension
      ///
      /// Parent Type: `UpdateExtensionPayload`
      struct UpdateExtension: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.UpdateExtensionPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("extension", Extension?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateExtensionMutation.Data.UpdateExtension.self
        ] }

        var `extension`: Extension? { __data["extension"] }

        /// UpdateExtension.Extension
        ///
        /// Parent Type: `ExtensionType`
        struct Extension: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ExtensionType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("pkgName", String.self),
            .field("name", String.self),
            .field("lang", String.self),
            .field("versionName", String.self),
            .field("versionCode", Int.self),
            .field("iconUrl", String.self),
            .field("isInstalled", Bool.self),
            .field("hasUpdate", Bool.self),
            .field("isObsolete", Bool.self),
            .field("isNsfw", Bool.self),
            .field("repo", String?.self),
            .field("apkName", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UpdateExtensionMutation.Data.UpdateExtension.Extension.self
          ] }

          var pkgName: String { __data["pkgName"] }
          var name: String { __data["name"] }
          var lang: String { __data["lang"] }
          var versionName: String { __data["versionName"] }
          var versionCode: Int { __data["versionCode"] }
          var iconUrl: String { __data["iconUrl"] }
          var isInstalled: Bool { __data["isInstalled"] }
          var hasUpdate: Bool { __data["hasUpdate"] }
          var isObsolete: Bool { __data["isObsolete"] }
          var isNsfw: Bool { __data["isNsfw"] }
          var repo: String? { __data["repo"] }
          var apkName: String { __data["apkName"] }
        }
      }
    }
  }

}