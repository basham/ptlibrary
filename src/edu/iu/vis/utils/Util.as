package edu.iu.vis.utils {
	
	/**
	 * The Util class defines general, static utility functions not specializing in any class or algorithm.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class Util {
		
		/**
		 * Creates a new instance of a class given an array of parameters.
		 * 
		 * <p>Note: This function will only construct instances using up to 10 parameters.
		 * Parameters are not checked, so it's up to the developer to properly determine
		 * parameter order and data types.</p>
		 * 
		 * @param type A reference to a Class type to be constructed.
		 * @param parameters An array of parameters to applied in the constructor of the class instance.
		 * 
		 * @return Returns the newly created class instance object.
		 * 
		 * */
		public static function Construct( type:Class, parameters:Array ):* {
			switch( parameters.length ) {
				case 0:
					return new type();
				case 1:
					return new type( parameters[0] );
				case 2:
					return new type( parameters[0], parameters[1] );
				case 3:
					return new type( parameters[0], parameters[1], parameters[2] );
				case 4:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3] );
				case 5:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] );
				case 6:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5] );
				case 7:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6] );
				case 8:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7] );
				case 9:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8] );
				case 10:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9] );
				default:
					return null;
			}
		}
		
		/**
		 * Compares any two numbers according to an operation.
		 * 
		 * @param value1 A Number value to compare with value2.
		 * @param value2 A Number value to compare with value1.
		 * @param operation A String indicating how the two values will be compared.
		 * Valid values include "<code><</code>", "<code><=</code>", "<code>></code>", "<code>>=</code>",
		 * "<code>==</code>" and "<code>!=</code>".
		 * 
		 * @return Returns a Boolean indicating how the two values compare according to the operation.
		 * 
		 * */
		public static function StringOperation( value1:Number, value2:Number, operation:String ):Boolean {
			switch( operation ) {
				case '<':
					return ( value1 < value2 );
				case '<=':
					return ( value1 <= value2 );
				case '>':
					return ( value1 > value2 );
				case '>=':
					return ( value1 >= value2 );
				case '==':
					return ( value1 == value2 );
				case '!=':
					return ( value1 != value2 );
				default:
					return false;
			}
		}

	}
}