package edu.iu.vis.utils {
	
	import fl.motion.MatrixTransformer;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The DisplayUtil class defines general, static utility functions for DisplayObject objects.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class DisplayUtil {
		
		/**
		 * Rotates a DisplayObject around an internal registration point.
		 * 
		 * @param displayObject The DisplayObject to be rotated.
		 * @param point A Point relative to the registration point of the displayObject.
		 * @param rotation A value in degrees (<code>0 - 360</code>) to rotate the displayObject.
		 * 
		 * */
		public static function RotateAroundInnerPoint( displayObject:DisplayObject, point:Point, rotation:Number ):void {
			var m:Matrix = displayObject.transform.matrix;
			MatrixTransformer.rotateAroundInternalPoint( m, point.x, point.y, rotation );
			displayObject.transform.matrix = m;
		}

	}
}