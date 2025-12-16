// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class AboutServerQuery: GraphQLQuery {
    static let operationName: String = "AboutServer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query AboutServer { aboutServer { __typename name version revision buildType } }"#
      ))

    public init() {}

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("aboutServer", AboutServer.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        AboutServerQuery.Data.self
      ] }

      var aboutServer: AboutServer { __data["aboutServer"] }

      /// AboutServer
      ///
      /// Parent Type: `AboutServerPayload`
      struct AboutServer: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.AboutServerPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("version", String.self),
          .field("revision", String.self),
          .field("buildType", String.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          AboutServerQuery.Data.AboutServer.self
        ] }

        var name: String { __data["name"] }
        var version: String { __data["version"] }
        var revision: String { __data["revision"] }
        var buildType: String { __data["buildType"] }
      }
    }
  }

}