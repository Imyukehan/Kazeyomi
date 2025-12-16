// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class LastUpdateTimestampQuery: GraphQLQuery {
    static let operationName: String = "LastUpdateTimestamp"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query LastUpdateTimestamp { lastUpdateTimestamp { __typename timestamp } }"#
      ))

    public init() {}

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("lastUpdateTimestamp", LastUpdateTimestamp.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        LastUpdateTimestampQuery.Data.self
      ] }

      var lastUpdateTimestamp: LastUpdateTimestamp { __data["lastUpdateTimestamp"] }

      /// LastUpdateTimestamp
      ///
      /// Parent Type: `LastUpdateTimestampPayload`
      struct LastUpdateTimestamp: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.LastUpdateTimestampPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("timestamp", TachideskAPI.LongString.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          LastUpdateTimestampQuery.Data.LastUpdateTimestamp.self
        ] }

        var timestamp: TachideskAPI.LongString { __data["timestamp"] }
      }
    }
  }

}