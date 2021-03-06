/* Copyright 2017 The Octadero Authors. All Rights Reserved.
Created by Volodymyr Pavliukevych on 2017.

Licensed under the GPL License, Version 3.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.gnu.org/licenses/gpl-3.0.txt

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import Foundation
import CTensorFlow
import Proto
import CAPI
import CCAPI

/// Swift `Error` represents error occurred at `Graph` manipulation.
public enum GraphError: Error {
	case newBufferIsNil
	case incorrectAttributeValueType
	
}

/// Graph represents a computation graph. Graphs may be shared between sessions.
public class Graph  {
    public private(set) var tfGraph: TF_Graph
	
	/// Public constructor.
	/// - Return: Returns a new Graph.
	public init() {
		tfGraph = CAPI.newGraph()
	}
	
	/// Import imports the nodes and edges from a serialized representation of
	/// another Graph into g.
	///
	/// Names of imported nodes will be prefixed with prefix.
	func `import`(def:[Byte], prefix: String) throws {
		
		let opts = newImportGraphDefOptions()
		
		defer {
			delete(importGraphDefOptions: opts)
		}
		
		setPrefix(into: opts, prefix: prefix)
		
		guard let buffer = CAPI.newBuffer(from: def, length: def.count) else {
			throw GraphError.newBufferIsNil
		}
		
		let status = Status()
		defer {
			deleteBuffer(buffer)
		}
		
		CAPI.import(graph: self.tfGraph, in: buffer, sessionOptions: opts, status: status.tfStatus)
		if let error = status.error() {
			throw error
		}
	}
	
	/// Save graph at folder.
	///		Using EventsWriter core feature to represent grapht Data.
	/// - Parameters:
	///		- folder: folder where file will be stored.
	///		- fileName: file name prefix for file.
	///		- wallTime: time will be showing at tensorboard as wall time. If you sen nil, save with `now` time.
	///		- step: step of process.
	public func save(at folder: URL, fileName: String, wallTime specialTime: Date? = nil, step: Int64) throws {
		var wallTime = Date()
		if let specialTime = specialTime {
			wallTime = specialTime
		}
		
		let url = folder.appendingPathComponent(fileName)
		let pathString = url.absoluteString
		let bufferPointer = TF_NewBuffer()
		try CAPI.graphDef(of: self.tfGraph, graphDef: bufferPointer)
		let tfBuffer = TF_GetBuffer(bufferPointer)
		CCAPI.createEventWriter(tfBuffer.data,
		                        UInt(tfBuffer.length),
		                        UnsafeMutablePointer(mutating: pathString.cString(using: .utf8)),
		                        wallTime.timeIntervalSince1970,
		                        step)
		TF_DeleteBuffer(bufferPointer)
	}
	
	/// Operation returns the Operation named name in the Graph, or nil if no such
	/// operation is present.
	public func operation(by name:String) throws -> Operation? {
		if let tfOperation = CAPI.operation(in: self.tfGraph, by: name) {
			return try TensorFlowKit.Operation(tfOperation: tfOperation, graph: self)
		}
		return nil
	}
	
	/// Dispatch attribute commands to special CAPI function.
	func setAttribute(operationDescription: TF_OperationDescription?, name: String, value: Any) throws {
		if let tensor = value as? Tensor {
			try CAPI.setAttribute(tensor: tensor.tfTensor, by: name, for: operationDescription)
		} else if let dtType = value as? TF_DataType {
			CAPI.setAttribute(type: dtType, by: name, for: operationDescription)
		} else if let bool = value as? Bool {
			CAPI.setAttribute(value: bool, by: name, for: operationDescription)
		} else if let string = value as? String {
			CAPI.setAttribute(value: string, by: name, for: operationDescription)
		} else if let int = value as? Int64 {
			CAPI.setAttribute(value: int, by: name, for: operationDescription)
		} else if let float = value as? Float {
			CAPI.setAttribute(value: float, by: name, for: operationDescription)
		} else if let collectionOfFloat = value as? [Float] {
			CAPI.setAttribute(values: collectionOfFloat, by: name, for: operationDescription)
		} else if let collectionOfInt64 = value as? [Int64] {
			CAPI.setAttribute(values: collectionOfInt64, by: name, for: operationDescription)
        } else if let collectionOfBool = value as? [Bool] {
            CAPI.setAttribute(values: collectionOfBool, by: name, for: operationDescription)
        } else if let collectionOfDataType = value as? [TF_DataType] {
            CAPI.setAttribute(types: collectionOfDataType, by: name, for: operationDescription)
        } else if let shape = value as? Shape {
			switch shape {
			case .unknown:
				CAPI.setAttributeShape(dimensions: nil, by: name, for: operationDescription)
			case .dimensions(let value):
				CAPI.setAttributeShape(dimensions: value, by: name, for: operationDescription)
			}
        } else {
			//TODO: - Add [Shape] and [Tensor] to attributes.
			fatalError("Not ready for: \(type(of:value)) value")
		}
	}
	
	/// Internal function for appending new operation
	func addOperation (specification: OpSpec) throws -> Operation {
		let tfOperationDescription = newOperation(in: self.tfGraph, operationType: specification.type, operationName: specification.name)
		
		for input in specification.input {
			if let output = input as? Output {
				CAPI.add(input: output.tfOutput(), for: tfOperationDescription)
			} else {
				fatalError("Can't get input of: \(type(of: input))")
			}
		}
		for (name, value) in specification.attrs {
			try setAttribute(operationDescription: tfOperationDescription, name: name, value: value)
		}
		
		let tfOperation = try finish(operationDescription: tfOperationDescription)
		let operation = try TensorFlowKit.Operation(tfOperation: tfOperation, graph: self)
		return operation
	}

	/// Obtain `Tensorflow_GraphDef` representation of current graph.
	public func graphDef() throws -> Tensorflow_GraphDef {
		let data = try allocAndProcessBuffer { (bufferPointer) in
			try CAPI.graphDef(of: self.tfGraph, graphDef: bufferPointer)
		}
		return try Tensorflow_GraphDef(serializedData: data)
	}
	
	/// At deinit phase we need to delete C Graph object by TF_Grapht pointer.
	deinit {
		CAPI.delete(graph: tfGraph)
	}
}
