package edu.iu.vis.tracking {
	
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
		
		public function Region( depth:uint, bounds:Rectangle, fillPoint:Point, graph:RegionAdjacencyGraph = null, children:Array = null ) {
			this.depth = depth;
			this.bounds = bounds;
			this.fillPoint = fillPoint;
			this.children = children ? children : new Array();
			if ( graph ) graph.registerRegion( this );
		}
		
		public function get bit():Boolean {
			return depth % 2 == 0;
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
			
			for each( var child:Region in children ) {
				rds += Region.TranslateDepthSequence( child.relativeDepthSequence, 1 );
			}
			
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
		
		public function leftHeavySortChildren():void {
			children.sort( Region.LeftHeavyCompareRegions );
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
			sourceBitmapData.floodFill( fillPoint.x, fillPoint.y, RegionAdjacencyGraph.DepthToBit( depth + 1 ) );
			for each( var child:Region in children )
				( child as Region ).print( sourceBitmapData );
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