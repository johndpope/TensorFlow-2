// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: tensorflow/core/protobuf/debug.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// EXPERIMENTAL. Option for watching a node.
public struct Tensorflow_DebugTensorWatch: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".DebugTensorWatch"

  /// Name of the node to watch.
  public var nodeName: String = String()

  /// Output slot to watch.
  /// The semantics of output_slot == -1 is that the node is only watched for
  /// completion, but not for any output tensors. See NodeCompletionCallback
  /// in debug_gateway.h.
  /// TODO(cais): Implement this semantics.
  public var outputSlot: Int32 = 0

  /// Name(s) of the debugging op(s).
  /// One or more than one probes on a tensor.
  /// e.g., {"DebugIdentity", "DebugNanCount"}
  public var debugOps: [String] = []

  /// URL(s) for debug targets(s).
  ///
  /// Supported URL formats are:
  ///   - file:///foo/tfdbg_dump: Writes out Event content to file
  ///     /foo/tfdbg_dump.  Assumes all directories can be created if they don't
  ///     already exist.
  ///   - grpc://localhost:11011: Sends an RPC request to an EventListener
  ///     service running at localhost:11011 with the event.
  ///   - memcbk:///event_key: Routes tensors to clients using the
  ///     callback registered with the DebugCallbackRegistry for event_key.
  ///
  /// Each debug op listed in debug_ops will publish its output tensor (debug
  /// signal) to all URLs in debug_urls.
  ///
  /// N.B. Session::Run() supports concurrent invocations of the same inputs
  /// (feed keys), outputs and target nodes. If such concurrent invocations
  /// are to be debugged, the callers of Session::Run() must use distinct
  /// debug_urls to make sure that the streamed or dumped events do not overlap
  /// among the invocations.
  /// TODO(cais): More visible documentation of this in g3docs.
  public var debugUrls: [String] = []

  /// Do not error out if debug op creation fails (e.g., due to dtype
  /// incompatibility). Instead, just log the failure.
  public var tolerateDebugOpCreationFailures: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.nodeName)
      case 2: try decoder.decodeSingularInt32Field(value: &self.outputSlot)
      case 3: try decoder.decodeRepeatedStringField(value: &self.debugOps)
      case 4: try decoder.decodeRepeatedStringField(value: &self.debugUrls)
      case 5: try decoder.decodeSingularBoolField(value: &self.tolerateDebugOpCreationFailures)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.nodeName.isEmpty {
      try visitor.visitSingularStringField(value: self.nodeName, fieldNumber: 1)
    }
    if self.outputSlot != 0 {
      try visitor.visitSingularInt32Field(value: self.outputSlot, fieldNumber: 2)
    }
    if !self.debugOps.isEmpty {
      try visitor.visitRepeatedStringField(value: self.debugOps, fieldNumber: 3)
    }
    if !self.debugUrls.isEmpty {
      try visitor.visitRepeatedStringField(value: self.debugUrls, fieldNumber: 4)
    }
    if self.tolerateDebugOpCreationFailures != false {
      try visitor.visitSingularBoolField(value: self.tolerateDebugOpCreationFailures, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

/// EXPERIMENTAL. Options for initializing DebuggerState.
public struct Tensorflow_DebugOptions: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".DebugOptions"

  /// Debugging options
  public var debugTensorWatchOpts: [Tensorflow_DebugTensorWatch] = []

  /// Caller-specified global step count.
  /// Note that this is distinct from the session run count and the executor
  /// step count.
  public var globalStep: Int64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 4: try decoder.decodeRepeatedMessageField(value: &self.debugTensorWatchOpts)
      case 10: try decoder.decodeSingularInt64Field(value: &self.globalStep)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.debugTensorWatchOpts.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.debugTensorWatchOpts, fieldNumber: 4)
    }
    if self.globalStep != 0 {
      try visitor.visitSingularInt64Field(value: self.globalStep, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "tensorflow"

extension Tensorflow_DebugTensorWatch: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "node_name"),
    2: .standard(proto: "output_slot"),
    3: .standard(proto: "debug_ops"),
    4: .standard(proto: "debug_urls"),
    5: .standard(proto: "tolerate_debug_op_creation_failures"),
  ]

  public func _protobuf_generated_isEqualTo(other: Tensorflow_DebugTensorWatch) -> Bool {
    if self.nodeName != other.nodeName {return false}
    if self.outputSlot != other.outputSlot {return false}
    if self.debugOps != other.debugOps {return false}
    if self.debugUrls != other.debugUrls {return false}
    if self.tolerateDebugOpCreationFailures != other.tolerateDebugOpCreationFailures {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Tensorflow_DebugOptions: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    4: .standard(proto: "debug_tensor_watch_opts"),
    10: .standard(proto: "global_step"),
  ]

  public func _protobuf_generated_isEqualTo(other: Tensorflow_DebugOptions) -> Bool {
    if self.debugTensorWatchOpts != other.debugTensorWatchOpts {return false}
    if self.globalStep != other.globalStep {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}