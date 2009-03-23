package edu.iu.vis.utils {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The BitmapDataUtil class defines general, static utility functions for BitmapData objects.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class BitmapDataUtil {

		/**
		 * Strokes a rectangle on a BitmapData.
		 * 
		 * @param rect The rectangle that to be stroked.
		 * @param source The referenced BitmapData.
		 * @param strokeColor A hexidecimal value coloring the stroke.
		 * @param strokeThickness The stroke thickness in pixels.
		 * 
		 * */
		public static function StrokeRect( rect:Rectangle, source:BitmapData, strokeColor:uint = 0xFF0000, strokeThickness:uint = 2 ):void {
			var s:Shape = new Shape();
			s.graphics.lineStyle(strokeThickness, strokeColor);
			s.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			source.draw( s );
		}
		
		/**
		 * Strokes a point on a BitmapData.
		 * 
		 * @param point The point that to be stroked.
		 * @param source The referenced BitmapData.
		 * @param strokeColor A hexidecimal value coloring the stroke.
		 * @param strokeThickness The stroke thickness in pixels.
		 * 
		 * */
		public static function StrokePoint( point:Point, source:BitmapData, strokeColor:uint = 0xFF0000, strokeThickness:uint = 2 ):void {
			var s:Shape = new Shape();
			s.graphics.lineStyle(strokeThickness, strokeColor);
			s.graphics.drawRect(point.x - (strokeThickness / 2), point.y - (strokeThickness / 2), strokeThickness, strokeThickness);
			source.draw( s );
		}
		
		/**
		 * Reduces a BitmapData to two 32-bit colors according to a threshold.
		 * 
		 * @param source The referenced BitmapData.
		 * @param ratio The relative percentage between the two high/low colors defining the color value to threshold the source BitmapData.
		 * @param colorLow The low, extreme 32-bit ARGB color for thresholding. Default: 100% visible black.
		 * @param colorHigh The high, extreme 32-bit ARGB color for thresholding. Default: 100% visible white.
		 * @param mask The 32-bit ARGB color mask for thresholding.
		 * 
		 * @internal Should transparency be maintained?
		 * 
		 * */
		public static function TwoBitBitmap( source:BitmapData, ratio:Number = .5, colorLow:uint = 0xFF000000, colorHigh:uint = 0xFFFFFFFF, mask:uint = 0xFFFFFFFF ):void {
			var p:Point = new Point();
			var thresh:uint = ( ( colorHigh - colorLow ) * NumberUtil.CleanPercentage(ratio) ) + colorLow;
			
			source.threshold( source, source.rect, p, ">", thresh, colorHigh, mask, false );
			source.threshold( source, source.rect, p, "<=", thresh, colorLow, mask, false );
		}
		
		/**
		 * Finds the bounding rectangular region of a blob containing the given point.
		 * 
		 * <p>Note: The unique color must not be present in the sourceBitmapData, otherwise, false results are returned</p>
		 * 
		 * @param source The referenced BitmapData.
		 * @param point The point relative to the source BitmapData contained in a blob region.
		 * @param fillColor A 32-bit ARGB color filling the blob region containing the point.
		 * @param uniqueColor A 32-bit ARGB color that is not present in the source BitmapData.
		 * If the color is not unique, the function will return false results.
		 * @param copySource A Boolean indicating if the function should use a working copy (<code>true</code>)
		 * or modify the source BitmapData (<code>false</code>).
		 * 
		 * @return Returns a Rectangle indicating the bounding region of a blob containing the given point.
		 * 
		 * @internal TODO: Automatically find a unique color but probably too computationally intensive.
		 * Optionally refill the region with the same color from the given point instead of a new color.
		 * 
		 * */
		public static function GetBoundingRectFromPointRegion( source:BitmapData, point:Point, fillColor:uint = 0xFFFFF000,
			uniqueColor:uint = 0xFFFFFF00, copySource:Boolean = false ):Rectangle {
			
			var bitmap:BitmapData = copySource ? source.clone() : source;
			
			// Fill the bitmap with a unique color to separate the blob from the rest of the search area
			bitmap.floodFill( point.x, point.y, uniqueColor );

			// Find the bounds of the unique color, which is the bounds of the blob
			var bound:Rectangle = bitmap.getColorBoundsRect( 0xFFFFFFFF, uniqueColor, true );
			
			if ( copySource )
				bitmap.dispose();
			else 
				bitmap.floodFill( point.x, point.y, fillColor ); // Refill the bitmap, replacing the unique color
			
			return bound;
		}
		
		/**
		 * Find a single point along a retangular bounds who's pixel color matches a given color according to a certain operation.
		 * 
		 * @param color A 32-bit ARGB color attempted to be matched.
		 * @param source The referenced BitmapData.
		 * @param rect The retangular bounds to search for the point.
		 * @param operation Any standard set of operations in string form to compare the color to a point, e.g. '<=', '==', '>', '!=', etc.
		 * 
		 * @return Returns a Point if a matched pixel color is found or NULL if no match is found.
		 * 
		 * */
		public static function SelectClosestColor( color:uint, source:BitmapData, rect:Rectangle = null, operation:String = "<=" ):Point {

			rect = ( rect == null ) ? source.rect : rect;

			// Since the bound is known, there must be at least one point in the first row
			// of the bound that matches the parameterized color value. Therefore, it is
			// unnecessary to do a nested loop to look beyond the first row of data.
			
			// Search the shortest side of the bounds, either the first row or first column, to minimize enumeration
			if ( rect.width <= rect.height ) {
				for ( var x:uint = rect.x; x < rect.x + rect.width; x++ ) {
					// If the color at least exceeds the found color, it returns the coordinates of the pixel
					if ( Util.StringOperation( source.getPixel32( x, rect.y ), color, operation ) )
						return new Point( x, rect.y );
				}
			}
			else {
				for ( var y:uint = rect.y; y < rect.y + rect.height; y++ ) {
					// If the color at least exceeds the found color, it returns the coordinates of the pixel
					if ( Util.StringOperation( source.getPixel32( rect.x, y ), color, operation ) )
						return new Point( rect.x, y );
				}
			}

			// No pixel color found
			return null;
		}
		
		/**
		 * Finds the color region within a rectangular bound in the source bitmap.
		 * 
		 * @param source The referenced BitmapData.
		 * @param rect The retangular bounds to search for a colored region.
		 * @param mask A 32-bit ARGB color mask.
		 * @param color A color to be searched for in the source BitmapData.
		 * @param relativeBounds A Boolean indicating how to adjust the returned bound value.
		 * If set to <code>false</code> (default), the bound coordinates are calculated relative to the rect parameter.
		 * If set to <code>true</code>, the bound coordinates are calculated relative to the source BitmapData bounding rectangle.
		 * 
		 * @return Returns a Rectangle indicating the bounds of a certain colored region.
		 * 
		 * */
		public static function GetSmartColorBoundsRect( source:BitmapData, rect:Rectangle, mask:uint, color:uint, relativeBounds:Boolean = false ):Rectangle {
			var bmp:BitmapData = new BitmapData( rect.width, rect.height );
			bmp.copyPixels( source, rect, new Point() );
			var bounds:Rectangle = bmp.getColorBoundsRect( mask, color, true );
			bmp.dispose();
			
			if ( !relativeBounds ) {
				bounds.x += rect.x;
				bounds.y += rect.y;
			}
			
			return bounds;
		}
		
	}
}