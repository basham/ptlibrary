package edu.iu.vis.tracking.symbols.dss {
	
	public class DSSConfig {

		public static const DEFAULT_ROTATION:Number = 0;
		public static const DEFAULT_RADIUS:Number = 100;
		
		private static var _depth:uint = 3;
		private static var _slice:uint = 5;
		
		public static var MinDepthRadius:Number = .25;
		public static var MaxDepthRadius:Number = .8;
		public static var CentroidMarkRadius:Number = .1;
		public static var OrientationMarkRadius:Number = .05;
		
		public static var Steps:uint = 360;
		
		private static var _layerColors:Array = [ 0x000000, 0xFFFFFF ];
		
		
		public static function get Depth():uint {
			return _depth;
		}
		
		public static function set Depth( value:uint ):void {
			_depth = value;
		}
		
		public static function get Slice():uint {
			return _slice;
		}
		
		public static function set Slice( value:uint ):void {
			_slice = value;
		}
		
		public static function LayerColor( value:uint ):uint {
			return _layerColors[ value % _layerColors.length ];
		}
		
		public static function get SingleDepthRadius():Number {
			return ( ( MaxDepthRadius - MinDepthRadius ) / Depth );
		}
		
		public static function get SingleSliceDegrees():Number {
			return ( 360 / Slice );
		}
		
	}
}