package edu.iu.vis.utils {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The RectangleUtil class defines general, static utility functions for Rectangle objects.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class RectangleUtil {

		/**
		 * Calculates the centroid (middlepoint) of a Rectangle.
		 * 
		 * @param rect The referenced Rectangle.
		 * 
		 * @return Returns the Rectangle's centroid as a Point.
		 * 
		 * */
		public static function Centroid( rect:Rectangle ):Point {
			return new Point( rect.x + ( rect.width / 2 ), rect.y + ( rect.height / 2 ) );
		}
		
		/**
		 * Determines if a Rectangle's dimensions (default) or surface area is beneath a given threshold.
		 * 
		 * @param rect A Rectangle to be compared.
		 * @param minRect A Rectangle setting the threhold to compare rect.
		 * If not provided, minRect is assumed as a default Rectangle with zero width and hight.
		 * @param useMinArea If <code>false</code> (default), compares the two Rectangles according to dimensions.
		 * If <code>true</code>, compares the two Rectangles according to surface area.
		 * 
		 * @return Returns a Boolean.
		 * 
		 * */
		public static function Boundless( rect:Rectangle, minRect:Rectangle = null, useMinArea:Boolean = false ):Boolean {
			if ( !minRect )
				minRect = new Rectangle();
			if ( !useMinArea )
				return ( rect.width <= minRect.width && rect.height <= minRect.height );
			return ( rect.width * rect.height <= minRect.width * minRect.height );
		}

		/**
		 * Determines if a Rectangle is contained within any Rectangles contained in an array of Rectangles.
		 * 
		 * @param rect A Rectangle to be compared.
		 * @param rectangles An array of Rectangle objects.
		 * 
		 * @return Returns a Boolean.
		 * 
		 * */
		public static function AnyRectangleContainsRectangle( rect:Rectangle, rectangles:Array ):Boolean {
			for each( var r:Rectangle in rectangles )
				if ( r.containsRect( rect ) )
					return true;
			return false;
		}
		
		/**
		 * Removes any Rectangles contained within any others in an array of Rectangles.
		 * 
		 * @param rectangles An array of Rectangle objects.
		 * 
		 * @return Returns the original, modified array of Rectangle objects.
		 * 
		 * */
		public static function RemoveNestedRectangles( rectangles:Array ):Array {
			for ( var i:uint = 0; i < rectangles.length; i++ ) {
				var r1:Rectangle = rectangles[i];
				for ( var j:uint = 0; j < rectangles.length; j++ ) {
					var r2:Rectangle = rectangles[j];
					if ( r1.containsRect( r2 ) ) {
						rectangles.splice( j, 1 );
					}
				}
			}
			return rectangles;
		}
		
		/**
		 * Determines if a Rectangle's sides are of equivalent length within some given percentage of deviance.
		 * 
		 * @param rect The referenced Rectangle.
		 * @param deviance A percentage (<code>0 ... 1</code>) indicating how close the sides' length must match.
		 * A value of <code>0</code> means the width and height must be equivalent. A value of <code>.5</code>
		 * means a side could be up to 50% smaller or larger than the other side.
		 * 
		 * @return Returns a Boolean.
		 * 
		 * */
		public static function ApproachingSquare( rect:Rectangle, deviance:Number = 0 ):Boolean {
			var ratio:Number = rect.height / rect.width;
			deviance = ( deviance < 0 ) ? 0 : ( deviance > 1 ? 1 : deviance );
			return ( ratio >= 1 - deviance && ratio <= 1 + deviance );
		}
		
		/**
		 * Calculates the radius of a Rectangle as if the Rectangle shared the same dimensions with a circle.
		 * 
		 * @param rect The referenced Rectangle.
		 * 
		 * @return Returns the radius as a Number.
		 * 
		 * */
		public static function Radius( rect:Rectangle ):Number {
			return Math.max( rect.width, rect.height ) / 2;
		}
		
		/**
		 * Determines if any comparable sides of two Rectangles intersect.
		 * 
		 * @param rect1 A Rectangle to compare with rect2.
		 * @param rect2 A Rectangle to compare with rect1.
		 * 
		 * @return Returns a Boolean.
		 * 
		 * */
		public static function AnySidesIntersect( rect1:Rectangle, rect2:Rectangle ):Boolean {
			return ( rect1.top == rect2.top || rect1.right == rect2.right || rect1.bottom == rect2.bottom || rect1.left == rect2.left );
		}
		
	}
}