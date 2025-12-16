// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class DownloadStatusQuery: GraphQLQuery {
    static let operationName: String = "DownloadStatus"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query DownloadStatus { downloadStatus { __typename state queue { __typename position progress state } } }"#
      ))

    public init() {}

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("downloadStatus", DownloadStatus.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        DownloadStatusQuery.Data.self
      ] }

      var downloadStatus: DownloadStatus { __data["downloadStatus"] }

      /// DownloadStatus
      ///
      /// Parent Type: `DownloadStatus`
      struct DownloadStatus: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.DownloadStatus }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("state", GraphQLEnum<TachideskAPI.DownloaderState>.self),
          .field("queue", [Queue].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          DownloadStatusQuery.Data.DownloadStatus.self
        ] }

        var state: GraphQLEnum<TachideskAPI.DownloaderState> { __data["state"] }
        var queue: [Queue] { __data["queue"] }

        /// DownloadStatus.Queue
        ///
        /// Parent Type: `DownloadType`
        struct Queue: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.DownloadType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("position", Int.self),
            .field("progress", Double.self),
            .field("state", GraphQLEnum<TachideskAPI.DownloadState>.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            DownloadStatusQuery.Data.DownloadStatus.Queue.self
          ] }

          var position: Int { __data["position"] }
          var progress: Double { __data["progress"] }
          var state: GraphQLEnum<TachideskAPI.DownloadState> { __data["state"] }
        }
      }
    }
  }

}