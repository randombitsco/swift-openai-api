import Foundation

public struct Moderations: JSONPostCall {
  public enum Model: String, Equatable, Encodable {
    case latest = "text-moderation-latest"
    case stable = "text-moderation-stable"
  }
  
  public var path: String { "moderations" }
  
  /// The input text to classify.
  public let input: Prompt
  
  /// Two content moderations models are available: ``Model/stable`` and ``Model/latest``.
  ///
  /// The default is ``Model/latest`` which will be automatically upgraded over time. This ensures you are always using our most accurate model. If you use ``Model/stable``, we will provide advanced notice before updating the model. Accuracy of ``Model/stable`` may be slightly lower than for ``Model/latest``.
  public let model: Model?
  
  public init(input: Prompt, model: Model?) {
    self.input = input
    self.model = model
  }
}

public extension Moderations {
  enum Category: String, Hashable, Decodable {
    case hate
    case hateThreatening = "hate/threatening"
    case selfHarm = "self-harm"
    case sexual
    case sexualMinors = "sexual/minors"
    case violence
    case violenceGraphic = "violence/graphic"
  }
  
  struct Response: JSONResponse {
    /// The unique identifier for the moderation response.
    public struct ID: Identifier {
      public var value: String
      
      public init(_ value: String) {
        self.value = value
      }
    }
    
    /// The ``Moderations/Response/ID``.
    let id: ID
    
    /// The actual model used to perform the moderation.
    let model: String?
    
    /// The list of results.
    let results: [Result]
    
    public init(id: ID, model: String?, results: [Result]) {
      self.id = id
      self.model = model
      self.results = results
    }
  }
  
  struct Result: Decodable, Equatable {
    let categories: [Category: Bool]
    let categoryScores: [Category: Float]
    let flagged: Bool
    
    public init(categories: [Category : Bool], categoryScores: [Category : Float], flagged: Bool) {
      self.categories = categories
      self.categoryScores = categoryScores
      self.flagged = flagged
    }
  }
}
