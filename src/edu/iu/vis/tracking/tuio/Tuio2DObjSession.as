package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.NumberUtil;
	import edu.iu.vis.utils.Pool;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjSession {
		
		static private const MAX_STORED_NUM_FRAMES:uint = 10;
		static private const MAX_STATIC_NUM_FRAMES:uint = 10;
		
		private var _sessionId:uint;
		private var _classId:uint;
		private var _frames:Array;
		
		public function Tuio2DObjSession( sessionId:uint = 0, classId:uint = 0 ) {
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
			return ( TuioInterpreter.FrameCount - latest.frame < MAX_STATIC_NUM_FRAMES );
		}
		
		public function get latest():Tuio2DObjFrame {
			return ( _frames[0] ? _frames[0] : null );
		}
		
		public function update( frame:uint, x:Number, y:Number, a:Number ):void {
			
			// Calculate X, Y, A vectors
			
			//var t:Tuio2DObj = new Tuio2DObj( sessionId, classId, x, y, a, 0, 0, 0, 0, 0 );
			var t:Tuio2DObj = Tuio2DObjFrame.GetTuioInstance();
			t.s = sessionId;
			t.i = classId;
			t.update( x, y, a, 0, 0, 0, 0, 0 );
			
			//var f:Tuio2DObjFrame = Tuio2DObjFrame.GetInstance( frame, t );
			var f:Tuio2DObjFrame = Pool.Get( Tuio2DObjFrame );
			f.frame = frame;
			f.tuio = t;
			
			_frames.unshift( f );
			removeFrames( MAX_STORED_NUM_FRAMES );
		}
		
		public function updateByTuio( frame:uint, tuio:Tuio2DObj ):void {
			if ( tuio.i != classId )
				return;
			update( frame, tuio.x, tuio.y, tuio.a );
		}

		public function difference( tuio:Tuio2DObj ):Number {
			
			if ( !tuio || !latest ) // Ignore any null objects
				return -1;
			
			if ( !latest.tuio || tuio.i != classId ) // Ignore if Class Id doesn't match
				return -1;
			
			var sourceWidth:uint = 320;
			var sourceHeight:uint = 240;
			var xDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.x, tuio.x, sourceWidth ) * 100;
			var yDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.y, tuio.y, sourceHeight ) * 100;
			var aDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.tuio.a, tuio.a, 180 ) * 100;

			var diff:Number = ( xDiffPerc + yDiffPerc + aDiffPerc ) / 3; // Combine the diffs into a single, comparable value
			
			return diff;
		}
		
		public function PoolDisposer():void {
			removeFrames();
		}
		
		private function removeFrames( remainingFrames:uint = 0 ):void {
			while( _frames.length > remainingFrames )
				Pool.Dispose( _frames.pop() );
		}

	}
}