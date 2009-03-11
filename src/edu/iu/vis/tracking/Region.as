package edu.iu.vis.tracking {
	
	import edu.iu.vis.utils.RectangleUtil;
	import edu.iu.vis.utils.Pool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Region {
		
		private var _depth:uint;
		public var bounds:Rectangle;
		public var fillPoint:Point;

		public var children:Array;
		
		private var _relativeDepthSequence:String = '';
		private var _absoluteDepthSequence:String = '';
		
		public function Region( depth:uint, bounds:Rectangle, fillPoint:Point, graph:RegionAdjacencyGraph = null ) {
			this.depth = depth;
			this.bounds = bounds;
			this.fillPoint = fillPoint;
			this.children = new Array();
			if ( graph ) register( graph );
		}
		
		static public function GetInstance( depth:uint, bounds:Rectangle, fillPoint:Point, graph:RegionAdjacencyGraph = null ):Region {
			var r:Region = Pool.Get( Region, depth, bounds, fillPoint, graph );
			r.depth = depth;
			r.bounds = bounds;
			r.fillPoint = fillPoint;
			if ( graph ) r.register( graph );
			return r;
		}
		
		public function reset():void {
			_relativeDepthSequence = _absoluteDepthSequence = '';
		}
		
		public function get bit():Boolean {
			return depth % 2 == 0;
		}
		
		public function get bitColor():uint {
			return ( bit ? 0xFFFFFFFF : 0xFF000000 );
		}
		
		public function get depth():uint {
			return _depth;
		}
		
		public function set depth( value:uint ):void {
			_depth = value;
			_absoluteDepthSequence = '';
		}
		
		public function get relativeDepthSequence():String {
			
			if ( _relativeDepthSequence != '' )
				return _relativeDepthSequence;
			
			var rds:String = '0';
			
			for each( var child:Region in children )
				rds += Region.TranslateDepthSequence( child.relativeDepthSequence, 1 );
			
			_relativeDepthSequence = rds;
			_absoluteDepthSequence = '';
			
			return _relativeDepthSequence;
		}
		
		public function get absoluteDepthSequence():String {
			if ( _absoluteDepthSequence != '' )
				return _absoluteDepthSequence;
			
			_absoluteDepthSequence = Region.TranslateDepthSequence( relativeDepthSequence, depth );
			
			return _absoluteDepthSequence;
		}
		
		public function get centroid():Point {
			return RectangleUtil.Centroid( bounds );
		}
		
		public function getRegionsByNumChildren( numChildren:uint = 1 ):Array {
			
			var matches:Array = new Array();
			
			for each( var r:Region in children )
				if ( r.children.length == numChildren )
					matches.push( r );
			
			return matches;
		}
		
		/*
		compareBit
			0: Matches regions with any bit value
			1: Matches regions with TRUE/even bit values
			-1: Matches regions with FALSE/odd bit values
		*/
		
		public function getRegionsMatchingDepthSequence( pattern:*, compareBit:Number = 0, matchAbsoluteDepthSequence:Boolean = false ):Array {
			
			var matches:Array = new Array();
			
			for each( var r:Region in children ) {
				var sequence:String = matchAbsoluteDepthSequence ? r.absoluteDepthSequence : r.relativeDepthSequence;
				var match:Boolean = false;
				if ( sequence.search( pattern ) != -1 ) {
					switch( compareBit ) {
						case 0:
							match = true;
							break;
						case 1:
							if ( r.bit )
								match = true;
							break;
						case -1:
							if ( !r.bit )
								match = true;
							break;
					}
				}
				
				if ( match )
					matches.push( r );
			}
			
			return matches;
		}
		
		public function leftHeavySortChildren():void {
			children.sort( Region.LeftHeavyCompareRegions );
		}
		
		public function register( graph:RegionAdjacencyGraph ):void {
			graph.registerRegion( this );
		}
		
		public function registerChild( child:Region ):void {
			children.push( child );
			_relativeDepthSequence = _absoluteDepthSequence = '';
		}
		
		public function toString( traceChildren:Boolean = false ):String {
			
			var indent:String = '';
			for ( var i:uint = 0; i < depth; i++ )
				indent += ' -- ';
				
			var s:String = '';
			s += indent + '( ';
			s += 'depth: ' + this.depth + ', ';
			s += 'children: ' + this.children.length + ', ';
			s += 'relDSeq: ' + this.relativeDepthSequence + ', ';
			s += 'absDSeq: ' + this.absoluteDepthSequence + ', ';
			s += 'bounds: ' + this.bounds + ', ';
			s += 'fillPoint: ' + this.fillPoint;
			s += ' )\n';
			
			if ( traceChildren ) {
				for each( var child:Region in children )
					s += ( child as Region ).toString( traceChildren );
			}
			
			return s;
		}
		
		public function print( sourceBitmapData:BitmapData ):void {
			sourceBitmapData.floodFill( fillPoint.x, fillPoint.y, bitColor );
			for each( var child:Region in children )
				( child as Region ).print( sourceBitmapData );
		}
		
		public function dispose():void {
			for each( var child:Region in children )
				child.dispose();
			reset();
			children = new Array();
			Pool.Dispose( this );
		}
		
		public static function LeftHeavyCompareRegions( region1:Region, region2:Region ):Number {
			
			var rds1:String = region1.relativeDepthSequence;
			var rds2:String = region2.relativeDepthSequence;
			var l1:uint = rds1.length;
			var l2:uint = rds2.length;
			
			// If the sequences are the same, don't swap them
			if ( rds1 == rds2 )
				return 0;
			
			// Compare sequences through the length of the smallest sequence
			// Swap if you hit mismatched characters, i.e. depths
			for( var i:uint = 0; i < Math.min( l1, l2 ); i++ ) {
				if ( int(rds1.charAt(i)) < int(rds2.charAt(i)) )
					return 1;
				else if ( int(rds1.charAt(i)) > int(rds2.charAt(i)) )
					return -1;
			}
			
			// Compare string length, i.e. number of child regions
			if ( l1 < l2 )
				return 1;
			else if ( l1 > l2 )
				return -1;
			
			return 0;
		}
		
		public static function TranslateDepthSequence( depthSequence:String, depth:int ):String {
			var seq:String = '';
			for( var i:uint = 0; i < depthSequence.length; i++ )
				seq += int( depthSequence.charAt(i) ) + depth;
			return seq;
		}
		
	}
}