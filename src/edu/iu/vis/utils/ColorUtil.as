package edu.iu.vis.utils {
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * The ColorUtil class defines general, static utility functions for color calculations, conversions.
	 * 
	 * @author Chris Basham
	 * 
	 * */
	public class ColorUtil {
		
		/**
		 * Calculates the average hexidecimal color from a BitmapData instance.
		 * 
		 * @see http://blog.soulwire.co.uk/flash/actionscript-3/extract-average-colours-from-bitmapdata/
		 * 
		 * @param sourceBitmapData A referenced BitmapData instance.
		 * @param clipRect A Rectangle indicating the area from the referenced BitmapData to find the average color.
		 * If no Rectangle is provided, the entire BitmapData area is utilized.
		 * 
		 * @return Returns a 16-bit hexidecimal color.
		 * 
		 * @internal BitmapData resizing to determine color average works only in a limited number of cases,
		 * e.g. a square with "grid" regions.
		 * Though the getPixel method works, it may be more CPU than GPU intensive.
		 * 
		 * */
		public static function AverageColor( sourceBitmapData:BitmapData, clipRect:Rectangle = null ):uint {
			
			clipRect = clipRect == null ? sourceBitmapData.rect : clipRect;
			
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;
		 
			var count:Number = 0;
			var pixel:uint;
		 
			for ( var x:uint = clipRect.x; x < clipRect.x + clipRect.width; x++ ) {
				for ( var y:uint = clipRect.y; y < clipRect.y + clipRect.height; y++ ) {
					
					pixel = sourceBitmapData.getPixel( x, y );
		 
					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;
		 
					count++
				}
			}
		 
			red /= count;
			green /= count;
			blue /= count;
		 
			return red << 16 | green << 8 | blue;
		}
		 /*
		public static function AverageColor( sourceBitmapData:BitmapData, clipRect:Rectangle = null ):uint {

			// Use entire source area if "clipRect" not specified
			clipRect = clipRect == null ? sourceBitmapData.rect : clipRect;
			
			// Copies Source in order to redraw a scaled version later
			var tempData:BitmapData = new BitmapData( clipRect.width, clipRect.height );
			tempData.copyPixels( sourceBitmapData, clipRect, new Point() );

			// Create Matrix to scale Bitmap to 1x1
			var sx:Number = 1 / clipRect.width;
			var sy:Number = 1 / clipRect.height;
			var matrix:Matrix = new Matrix( sx, 0, 0, sy );
			
			// Create BitmapData holder, copying, resizing source
			var averageData:BitmapData = new BitmapData( 1, 1 );
			averageData.draw( sourceBitmapData, matrix, null, null, clipRect, true );
			
			// Average Color is found at origin coordinates
			var averageColor:uint = averageData.getPixel( 0, 0 );
			trace( '#', averageColor.toString(16) );
			
			// Cleanup
			tempData.dispose();
			averageData.dispose();
			
			return averageColor;
		}
		*/
		
		/**
		 * Converts a hexidecimal color to equivalent HSL values.
		 * 
		 * @see http://en.wikipedia.org/wiki/HSV_color_space#Conversion_from_RGB_to_HSL_or_HSV
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns an Object containing values <code>{ h: hue [0, 360], s: saturation [0, 1], l: lightness [0, 1] }</code>.
		 * 
		 * */
		public static function HexToHSL( hex:uint ):Object {
			var hsl:Object = new Object();
			
			// Normalize RGB to values ranging [ 0, 1 ]
			var r:Number = HexToRed( hex ) / 0xFF;
			var g:Number = HexToGreen( hex ) / 0xFF;
			var b:Number = HexToBlue( hex ) / 0xFF;
			var min:Number = Math.min( r, g, b );
			var max:Number = Math.max( r, g, b );
			
			// Hue
			var h:Number;
			switch( max ) {
				case min:
					h = 0;
					break;
				case r:
					h = ( 60 * ( g - b ) / ( max - min ) ) % 360;
					break;
				case g:
					h = 60 * ( b - r ) / ( max - min ) + 120;
					break;
				case b:
					h = 60 * ( r - g ) / ( max - min ) + 240;
					break;
			}
			
			// Lightness
			var l:Number = ( max + min ) / 2;
			
			// Saturation
			var s:Number = max == min ? 0 : ( l <= .5 ? ( max - min ) / 2 * l : ( max - min ) / ( 2 - 2 * l ) );

			hsl.h = h;
			hsl.s = s;				
			hsl.l = l;
			return hsl;
		}
		
		/**
		 * Calculates the Hue from a hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a Hue Number value with ranges <code>[0, 360]</code>.
		 * 
		 * */
		public static function HexToHue( hex:uint ):Number {
			return HexToHSL( hex ).h;
		}
		
		/**
		 * Calculates the Saturation from a hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a Saturation Number value with ranges <code>[0, 1]</code>.
		 * 
		 * */
		public static function HexToSaturation( hex:uint ):Number {
			return HexToHSL( hex ).s;
		}
		
		/**
		 * Calculates the Lightness, i.e. percentage of white, from a hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a Lightness Number value with ranges <code>[0, 1]</code>.
		 * 
		 * */
		public static function HexToLightness( hex:uint ):Number {
			return HexToHSL( hex ).l;
		}
		
		/**
		 * Converts a hexidecimal color to equivalent RGB values.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns an Object containing values <code>{ r: red [0, 255], g: green [0, 255], b: blue [0, 255] }</code>.
		 * 
		 * */
		public static function HexToRGB( hex:uint ):Object {
			var rgb:Object = new Object();
			rgb.r = HexToRed( hex );
			rgb.g = HexToGreen( hex );
			rgb.b = HexToBlue( hex );
			return rgb;
		}
		
		/**
		 * Finds the hexidecimal Red color value from a 16-bit hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * 
		 * */
		public static function HexToRed( hex:uint ):uint {
			return ( hex & 0xFF0000 ) >> 16;
		}
		
		/**
		 * Finds the hexidecimal Green color value from a 16-bit hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * 
		 * */
		public static function HexToGreen( hex:uint ):uint {
			return ( hex & 0x00FF00 ) >> 8;
		}
		
		/**
		 * Finds the hexidecimal Blue color value from a 16-bit hexidecimal color.
		 * 
		 * @param hex A hexidecimal color.
		 * 
		 * @return Returns a 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * 
		 * */
		public static function HexToBlue( hex:uint ):uint {
			return ( hex & 0x0000FF );
		}
		
		/**
		 * Converts an RGB Object to a 16-bit hexidecimal color value.
		 * 
		 * @param rgb A RGB Object structured as <code>{ r: red, g: green, b: blue }</code>.
		 * 
		 * @return Returns a 16-bit hexidecimal color value.
		 * 
		 * */
		public static function RGBObjectToHex( rgb:Object ):uint {
			return RGBToHex( rgb.r, rgb.g, rgb.b );
		}
		
		/**
		 * Converts an RGB value set to a 16-bit hexidecimal color value.
		 * 
		 * @param red A 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * @param green A 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * @param blue A 4-bit hexidecimal value with ranges <code>[0, 255]</code>.
		 * 
		 * @return Returns a 16-bit hexidecimal color value.
		 * 
		 * */
		public static function RGBToHex( red:uint, green:uint, blue:uint ):uint {
			return red << 16 | green << 8 | blue
			//return ( red << 16 ) + ( green << 8 ) + blue; 
		}

	}
}