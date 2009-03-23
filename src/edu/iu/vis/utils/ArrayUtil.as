package edu.iu.vis.utils {
	
	/**
	 * The ArrayUtil class defines general, static utility functions for Arrays.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class ArrayUtil {
		
		/**
		 * Compares the content of Arrays containing simple, standard objects,
		 * e.g. uint, Number, Boolean, String.
		 * 
		 * @param array1 The first array to compare.
		 * @param array2 The second array to compare.
		 * 
		 * @return Returns true if the arrays' content are identical.
		 * 
		 * */
		public static function CompareSimpleArrays( array1:Array, array2:Array ):Boolean {
			return ( array1.toString() == array2.toString() );
		}
		
		/**
		 * Truncates or pads an array to a specified length.
		 * 
		 * @param array The referenced array.
		 * @param length The length the array should be.
		 * @param buffer A default object to add to the array if padding is required.
		 * 
		 * @return Returns the referenced, modified array.
		 * 
		 * */
		public static function FitToLength( array:Array, length:uint, buffer:* = null ):Array {
			if (!array)
				array = new Array();
			while( array.length < length )
				array.push( buffer );
			while( array.length > length )
				array.pop();
			return array;
		}

		/**
		 * Converts an array of strings to a single, concatenated string.
		 * 
		 * @param array The referenced array.
		 * 
		 * @return Returns the concatenated string.
		 * 
		 * @internal TODO: Allow optional character delimators.
		 * 
		 * */
		public static function ToSimpleString( array:Array ):String {
			var s:String = '';
			for each( var a:String in array )
				s += a;
			return s;
		}

	}
}