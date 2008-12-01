package edu.iu.vis.utils {
	
	import fl.motion.MatrixTransformer;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class DisplayUtil {
		
		public static function RotateAroundInnerPoint( displayObject:DisplayObject, point:Point, ratation:Number ):void {
			var m:Matrix = displayObject.transform.matrix;
			MatrixTransformer.rotateAroundInternalPoint( m, point.x, point.y, ratation );
			displayObject.transform.matrix = m;
		}

	}
}