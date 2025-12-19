// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class ExtensionsQuery: GraphQLQuery {
    static let operationName: String = "Extensions"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Extensions($first: Int!, $offset: Int!) { extensions(first: $first, offset: $offset, orderBy: NAME, orderByType: ASC) { __typename nodes { __typename pkgName name lang versionName versionCode iconUrl isInstalled hasUpdate isObsolete isNsfw repo apkName } } }"#
      ))

    public var first: Int
    public var offset: Int

    public init(
      first: Int,
      offset: Int
    ) {
      self.first = first
      self.offset = offset
    }

    public var __variables: Variables? { [
      "first": first,
      "offset": offset
    ] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("extensions", Extensions.self, arguments: [
          "first": .variable("first"),
          "offset": .variable("offset"),
          "orderBy": "NAME",
          "orderByType": "ASC"
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ExtensionsQuery.Data.self
      ] }

      var extensions: Extensions { __data["extensions"] }

      /// Extensions
      ///
      /// Parent Type: `ExtensionNodeList`
      struct Extensions: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ExtensionNodeList }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ExtensionsQuery.Data.Extensions.self
        ] }

        var nodes: [Node] { __data["nodes"] }

        /// Extensions.Node
        ///
        /// Parent Type: `ExtensionType`
        struct Node: TachideskAPI.SelectionSet {
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
            ExtensionsQuery.Data.Extensions.Node.self
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