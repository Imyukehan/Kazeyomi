// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class SourcesQuery: GraphQLQuery {
    static let operationName: String = "Sources"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Sources($first: Int!, $offset: Int!) { sources(first: $first, offset: $offset, orderBy: NAME, orderByType: ASC) { __typename nodes { __typename id name displayName lang iconUrl isNsfw supportsLatest } } }"#
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
        .field("sources", Sources.self, arguments: [
          "first": .variable("first"),
          "offset": .variable("offset"),
          "orderBy": "NAME",
          "orderByType": "ASC"
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SourcesQuery.Data.self
      ] }

      var sources: Sources { __data["sources"] }

      /// Sources
      ///
      /// Parent Type: `SourceNodeList`
      struct Sources: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.SourceNodeList }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          SourcesQuery.Data.Sources.self
        ] }

        var nodes: [Node] { __data["nodes"] }

        /// Sources.Node
        ///
        /// Parent Type: `SourceType`
        struct Node: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.SourceType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", TachideskAPI.LongString.self),
            .field("name", String.self),
            .field("displayName", String.self),
            .field("lang", String.self),
            .field("iconUrl", String.self),
            .field("isNsfw", Bool.self),
            .field("supportsLatest", Bool.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            SourcesQuery.Data.Sources.Node.self
          ] }

          var id: TachideskAPI.LongString { __data["id"] }
          var name: String { __data["name"] }
          var displayName: String { __data["displayName"] }
          var lang: String { __data["lang"] }
          var iconUrl: String { __data["iconUrl"] }
          var isNsfw: Bool { __data["isNsfw"] }
          var supportsLatest: Bool { __data["supportsLatest"] }
        }
      }
    }
  }

}