package edu.iu.vis.utils {
	
	public class ArrayUtil {
		
		public static function CompareSimpleArrays( array1:Array, array2:Array ):Boolean {
			return ( array1.toString() == array2.toString() );
		}
		
		public static function FitToLength( array:Array, length:uint, buffer:uint = 0 ):Array {
			if (!array)
				array = new Array();
			while( array.length < length )
				array.push( buffer );
			while( array.length > length )
				array.pop();
			return array;
		}

	}
}