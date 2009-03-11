package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.Pool;
	import edu.iu.vis.utils.TrigUtil;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjSession {
		
		static private const MAX_STORED_NUM_FRAMES:uint = 5; // Need 1, more to interpret gestures
		static private const MAX_STATIC_NUM_FRAMES:uint = 5;
		
		public var interpreter:TuioInterpreter;
		
		private var _sessionId:uint;
		private var _classId:uint;
		private var _frames:Array;
		
		public function Tuio2DObjSession( interpreter:TuioInterpreter, sessionId:uint = 0, classId:uint = 0 ) {
			this.interpreter = interpreter;
			this.sessionId = sessionId;
			this.classId = classId;
			_frames = new Array();
		}
		
		public function get sessionId():uint {
			return _sessionId;
		}
		
		public function set sessionId( value:uint ):void {
			_sessionId = value;
			for each( var f:Tuio2DObjFrame in _frames )
				f.tuio.s = value;
		}
		
		public function get classId():uint {
			return _classId;
		}
		
		public function set classId( value:uint ):void {
			_classId = value;
			for each( var f:Tuio2DObjFrame in _frames )
				f.tuio.i = value;
		}
		
		public function get alive():Boolean {
			return ( interpreter.frame - latest.frame < MAX_STATIC_NUM_FRAMES );
		}
		
		public function get latest():Tuio2DObjFrame {
			return ( _frames[0] ? _frames[0] : null );
		}
		
		public function update( frame:uint, x:Number, y:Number, a:Number ):void {
			
			var lf:uint = 0, lx:Number = 0, ly:Number = 0, la:Number = 0, lX:Number = 0, lY:Number = 0, lA:Number = 0;
			
			if ( latest != null ) {
				lf = latest.frame;
				lx = latest.tuio.x;
				ly = latest.tuio.y;
				la = latest.tuio.a;
				lX = latest.tuio.X;
				lY = latest.tuio.Y;
				lA = latest.tuio.A;
			}
			
			// Calculate X, Y, A, m, r parameters
			// See http://mtg.upf.edu/reactable/?tuio
			var df:uint = frame - lf; // time delta ( should be relative to 1 second, not in frames! )
			var X:Number = ( x - lx ) / df; // 'x' speed
			var Y:Number = ( y - ly ) / df; // 'y' speed
			var A:Number = ( ( a - la ) / 2 * Math.PI ) / df; // rotation speed
			var m:Number = 0; // motion acceleration // ( speed - last_speed ) / dt
			var r:Number = ( A - lA ) / df; // rotation acceleration
			
			//var t:Tuio2DObj = new Tuio2DObj( sessionId, classId, x, y, a, 0, 0, 0, 0, 0 );
			var t:Tuio2DObj = Tuio2DObjFrame.GetTuioInstance();
			t.s = sessionId;
			t.i = classId;
			t.update( x, y, a, X, Y, A, m, r );
			
			//var f:Tuio2DObjFrame = Tuio2DObjFrame.GetInstance( frame, t );
			var f:Tuio2DObjFrame = Pool.Get( Tuio2DObjFrame );
			f.frame = frame;
			f.tuio = t;
			this.addFrame( f );
		}
		
		public function updateByTuio( frame:uint, tuio:Tuio2DObj ):void {
			if ( tuio.i != classId )
				return;
			update( frame, tuio.x, tuio.y, tuio.a );
		}

		public function difference( x:Number, y:Number ):Number {
			if ( !latest )
				return -1;
			return TrigUtil.DistanceBetweenCoordinates( x, y, latest.tuio.x, latest.tuio.y );
		}

		public function differencer( i:uint, x:Number, y:Number, a:Number ):Number {
			
			if ( !latest ) // Ignore any null objects
				return -1;
			
			if ( !latest.tuio || i != classId ) // Ignore if Class Id doesn't match
				return -1;
			
			var xDiffPerc:Number = Math.abs( latest.tuio.x - x );
			var yDiffPerc:Number = Math.abs( latest.tuio.y - y );
			var aDiffPerc:Number = Math.abs( latest.tuio.a - a );
			//var xDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.x, x, interpreter.sourceWidth ) * 100;
			//var yDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.y, y, interpreter.sourceHeight ) * 100;
			//var aDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.a, a, 180 ) * 100;

			var diff:Number = ( xDiffPerc + yDiffPerc + aDiffPerc ) / 3; // Combine the diffs into a single, comparable value
			
			return diff;
		}
		
		public function dispose():void {
			removeFrames();
		}
		
		private function addFrame( frame:Tuio2DObjFrame ):void {
			_frames.unshift( frame );
			removeFrames( MAX_STORED_NUM_FRAMES );
		}
		
		private function removeFrames( remainingFrames:uint = 0 ):void {
			while( _frames.length > remainingFrames )
				Pool.Dispose( _frames.pop() );
		}

	}
}