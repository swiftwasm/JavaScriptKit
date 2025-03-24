/**
 * This is a simple interface for testing
 */
interface SimpleInterface {
  /**
   * A simple string property
   */
  stringProperty: string;
  
  /**
   * A simple number property
   */
  numberProperty: number;
  
  /**
   * An optional boolean property
   */
  optionalProperty?: boolean;
  
  /**
   * A method that takes a string parameter and returns a boolean
   */
  testMethod(param: string): boolean;
  
  /**
   * A more complex method with multiple parameters and optional parameters
   */
  complexMethod(requiredParam: number, optionalParam?: string): Promise<string[]>;
}

/**
 * A simple type alias for testing
 */
type SimpleType = string | number;

/**
 * A simple enum for testing
 */
enum SimpleEnum {
  One,
  Two,
  Three
}

/**
 * Export everything for testing
 */
export {
  SimpleInterface,
  SimpleType,
  SimpleEnum
} 
