// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class FetchExtensionsMutation: GraphQLMutation {
    static let operationName: String = "FetchExtensions"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation FetchExtensions { fetchExtensions(input: {  }) { __typename extensions { __typename pkgName name lang versionName versionCode iconUrl isInstalled hasUpdate isObsolete isNsfw repo apkName } } }"#
      ))

    public init() {}

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("fetchExtensions", FetchExtensions?.self, arguments: ["input": []]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        FetchExtensionsMutation.Data.self
      ] }

      var fetchExtensions: FetchExtensions? { __data["fetchExtensions"] }

      /// FetchExtensions
      ///
      /// Parent Type: `FetchExtensionsPayload`
      struct FetchExtensions: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.FetchExtensionsPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("extensions", [Extension].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          FetchExtensionsMutation.Data.FetchExtensions.self
        ] }

        var extensions: [Extension] { __data["extensions"] }

        /// FetchExtensions.Extension
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
            FetchExtensionsMutation.Data.FetchExtensions.Extension.self
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