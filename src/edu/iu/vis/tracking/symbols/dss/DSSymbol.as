package edu.iu.vis.tracking.symbols.dss {
	
	import edu.iu.vis.utils.ArrayUtil;
	import edu.iu.vis.utils.DisplayUtil;
	import edu.iu.vis.utils.TrigUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class DSSymbol {
		
		private var _code:Array;
		private var _rotation:Number;
		private var _radius:Number;
		private var _centroid:Point;
		//public var 
		
		public var enableDraw:Boolean = false;
		
		private var _symbol:Sprite = new Sprite(); // Symbol Container
		private var bg:Shape = new Shape(); // Symbol Background
		private var ds:Shape = new Shape(); // Symbol Depth-Slice
		private var cm:Shape = new Shape(); // Symbol Centroid Mark
		private var om:Shape = new Shape(); // Symbol Orientation Mark
		
		public function DSSymbol( code:Array = null,
			rotation:Number = DSSConfig.DEFAULT_ROTATION, radius:Number = DSSConfig.DEFAULT_RADIUS ) {

			symbol.addChild( bg );
			symbol.addChild( ds );
			symbol.addChild( cm );
			symbol.addChild( om );

			this.code = code;
			this.rotation = rotation;
			this.radius = radius;
			
			this.enableDraw = true;
			draw();
		}

		public function get code():Array {
			return _code;
		}
		
		public function set code( value:Array ):void {
			_code = ArrayUtil.FitToLength( value, DSSConfig.Slice );
			draw();
		}

		public function get rotation():Number {
			return _rotation;
		}
		
		public function set rotation( value:Number ):void {
			rotate( -_rotation ); // Undo previous Orientation
			_rotation = value;
			rotate( _rotation );
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius( value:Number ):void {
			_radius = value;
			_centroid = null;
			draw();
		}
		
		public function get centroid():Point {
			if (_centroid)
				return _centroid;
			_centroid = new Point( radius, radius );
			return _centroid;
		}
		
		public function get symbol():Sprite {
			return _symbol;
		}
		
		private function get minDepthRadius():Number {
			return radius * DSSConfig.MinDepthRadius;
		}
		
		private function get maxDepthRadius():Number {
			return radius * DSSConfig.MaxDepthRadius;
		}

		private function get singleDepthRadius():Number {
			return radius * DSSConfig.SingleDepthRadius;
		}

		private function get centroidMarkRadius():Number {
			return radius * DSSConfig.CentroidMarkRadius;
		}
		
		private function get orientationMarkRadius():Number {
			return radius * DSSConfig.OrientationMarkRadius;
		}
		
		public function draw():void {
			if (!enableDraw)
				return;
			drawBG();
			drawDS();
			drawCM();
			drawOM();
		}
		
		private function drawBG():void {
			bg.graphics.clear();
			bg.graphics.beginFill( DSSConfig.LayerColor(0) );
			bg.graphics.drawCircle( radius, radius, radius );
			bg.graphics.endFill();
		}
		
		private function drawDS():void {
			ds.graphics.clear();
			//ds.graphics.lineStyle( 1, 0xFFFFFF );
			ds.graphics.beginFill( DSSConfig.LayerColor(1) );
			
			var degreesPerStep:Number = 360 / DSSConfig.Steps;
			var degreesPerSlice:Number = 360 / DSSConfig.Slice;
			var rotationOffset:Number = degreesPerSlice / 2;
			
			for( var i:Number = 0; i < DSSConfig.Steps; i++ ) {
				var degree:Number = i * degreesPerStep;
				var degreeOffset:Number = ( degree + rotationOffset ) % 360; // Rotates drawing
				var sliceIndex:uint = Math.floor( degreeOffset / degreesPerSlice ); // Finds respective index
				var p:Point = getSlicePoint( degree, code[ sliceIndex ] );

				if (i == 0)
					ds.graphics.moveTo( p.x, p.y );
					
				ds.graphics.lineTo( p.x, p.y );
			}
		
			ds.graphics.endFill();
		}

		private function drawCM():void {
			cm.graphics.clear();
			cm.graphics.beginFill( DSSConfig.LayerColor(0) );
			cm.graphics.drawCircle( radius, radius, centroidMarkRadius );
			cm.graphics.endFill();
		}
		
		private function drawOM():void {
			om.graphics.clear();
			om.graphics.beginFill( DSSConfig.LayerColor(1) );
			om.graphics.drawCircle( radius, ( radius - maxDepthRadius ) / 2, orientationMarkRadius );
			om.graphics.endFill();
		}
		
		public function getSlicePoint( degree:Number, sliceDepth:Number, middleDepth:Boolean = false ):Point {
			if ( middleDepth )
				sliceDepth -= .5;
			var r:Number = TrigUtil.Radians( degree );
			var dw:Number = sliceDepth * singleDepthRadius + minDepthRadius;
			var px:Number = centroid.x + Math.sin( r ) * dw;
			var py:Number = centroid.y - Math.cos( r ) * dw;
			return new Point( px, py );
		}
		
		private function rotate( rotation:Number ):void {
			if (!enableDraw)
				return;
			DisplayUtil.RotateAroundInnerPoint( symbol, centroid, rotation );
		}

		public function toString():String {
			return ( code.toString() + ' ' + rotation.toString() );
		}
	}
}