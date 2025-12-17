// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol TachideskAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == TachideskAPI.SchemaMetadata {}

protocol TachideskAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == TachideskAPI.SchemaMetadata {}

protocol TachideskAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == TachideskAPI.SchemaMetadata {}

protocol TachideskAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == TachideskAPI.SchemaMetadata {}

extension TachideskAPI {
  typealias SelectionSet = TachideskAPI_SelectionSet

  typealias InlineFragment = TachideskAPI_InlineFragment

  typealias MutableSelectionSet = TachideskAPI_MutableSelectionSet

  typealias MutableInlineFragment = TachideskAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "AboutServerPayload": return TachideskAPI.Objects.AboutServerPayload
      case "CategoryNodeList": return TachideskAPI.Objects.CategoryNodeList
      case "CategoryType": return TachideskAPI.Objects.CategoryType
      case "ChapterNodeList": return TachideskAPI.Objects.ChapterNodeList
      case "ChapterType": return TachideskAPI.Objects.ChapterType
      case "DownloadNodeList": return TachideskAPI.Objects.DownloadNodeList
      case "DownloadStatus": return TachideskAPI.Objects.DownloadStatus
      case "DownloadType": return TachideskAPI.Objects.DownloadType
      case "ExtensionNodeList": return TachideskAPI.Objects.ExtensionNodeList
      case "FetchChapterPagesPayload": return TachideskAPI.Objects.FetchChapterPagesPayload
      case "FetchChaptersPayload": return TachideskAPI.Objects.FetchChaptersPayload
      case "FetchSourceMangaPayload": return TachideskAPI.Objects.FetchSourceMangaPayload
      case "GlobalMetaNodeList": return TachideskAPI.Objects.GlobalMetaNodeList
      case "LastUpdateTimestampPayload": return TachideskAPI.Objects.LastUpdateTimestampPayload
      case "MangaNodeList": return TachideskAPI.Objects.MangaNodeList
      case "MangaType": return TachideskAPI.Objects.MangaType
      case "Mutation": return TachideskAPI.Objects.Mutation
      case "PageInfo": return TachideskAPI.Objects.PageInfo
      case "Query": return TachideskAPI.Objects.Query
      case "SourceNodeList": return TachideskAPI.Objects.SourceNodeList
      case "SourceType": return TachideskAPI.Objects.SourceType
      case "TrackRecordNodeList": return TachideskAPI.Objects.TrackRecordNodeList
      case "TrackerNodeList": return TachideskAPI.Objects.TrackerNodeList
      case "UpdateChapterPayload": return TachideskAPI.Objects.UpdateChapterPayload
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}