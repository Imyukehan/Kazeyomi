// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class AllCategoriesQuery: GraphQLQuery {
    static let operationName: String = "AllCategories"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query AllCategories($first: Int!, $offset: Int!) { categories(first: $first, orderBy: ORDER, orderByType: ASC, offset: $offset) { __typename nodes { __typename id name order default } } }"#
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
        .field("categories", Categories.self, arguments: [
          "first": .variable("first"),
          "orderBy": "ORDER",
          "orderByType": "ASC",
          "offset": .variable("offset")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        AllCategoriesQuery.Data.self
      ] }

      var categories: Categories { __data["categories"] }

      /// Categories
      ///
      /// Parent Type: `CategoryNodeList`
      struct Categories: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CategoryNodeList }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          AllCategoriesQuery.Data.Categories.self
        ] }

        var nodes: [Node] { __data["nodes"] }

        /// Categories.Node
        ///
        /// Parent Type: `CategoryType`
        struct Node: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CategoryType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("name", String.self),
            .field("order", Int.self),
            .field("default", Bool.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            AllCategoriesQuery.Data.Categories.Node.self
          ] }

          var id: Int { __data["id"] }
          var name: String { __data["name"] }
          var order: Int { __data["order"] }
          var `default`: Bool { __data["default"] }
        }
      }
    }
  }

}