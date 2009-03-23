package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.Pool;
	import edu.iu.vis.utils.TrigUtil;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjSession {
		
		static private const MAX_STORED_NUM_FRAMES:uint = 5; // Minimally need 1, more to interpret complex gestures
		static private const MAX_IDLE_NUM_FRAMES:uint = 5; // Number of frames before a session is declaired dead
		
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
			for each( var f:Tuio2DObjFrame in _frames ) // Syncs all frames with the new sessionId
				f.tuio.s = value;
		}
		
		public function get classId():uint {
			return _classId;
		}
		
		public function set classId( value:uint ):void {
			_classId = value;
			for each( var f:Tuio2DObjFrame in _frames ) // Syncs all frames with the new classId
				f.tuio.i = value;
		}
		
		public function get alive():Boolean {
			return ( interpreter.frame - latest.frame < MAX_IDLE_NUM_FRAMES );
		}
		
		public function get latest():Tuio2DObjFrame {
			return ( _frames[0] ? _frames[0] : null );
		}
		
		public function update( frame:uint, fps:uint, x:Number, y:Number, a:Number ):void {
			
			// Calculated Tuio parameters presets
			var X:Number = 0, Y:Number = 0, A:Number = 0, m:Number = 0, r:Number = 0;
			
			// Calculate advanced X, Y, A, m, r parameters if a suitable fps is provided (can't divide by zero)
			// and the Latest frame is available. Time calculations need to compare two points in time, not one.
			// See http://www.tuio.org/?specification
			// TODO: Values need to be verified!
			if ( fps > 0 && latest != null ) {
				var lt:Tuio2DObj = latest.tuio; // Latest Tuio
				var dt:Number = ( frame - latest.frame ) / fps; // Time Delta relative to 1 second
				X = ( x - lt.x ) / dt; // 'x' speed : x percentage per second
				Y = ( y - lt.y ) / dt; // 'y' speed : y percentage per second
				A = ( ( a - lt.a ) / 2 * Math.PI ) / dt; // Rotation speed : radians per second
				m = TrigUtil.DistanceBetweenCoordinates( X, Y, lt.X, lt.Y ) / dt; // Motion acceleration : ( speed - last_speed ) / dt
				r = ( A - lt.A ) / dt; // Rotation acceleration
			}
			
			// Initialize Tuio Obj with calculated values
			var t:Tuio2DObj = Tuio2DObjFrame.GetTuioInstance();
			t.s = sessionId;
			t.i = classId;
			t.update( x, y, a, X, Y, A, m, r );
			
			// Initialize Frame with Tuio Obj; include it in 'this' Session
			var f:Tuio2DObjFrame = Pool.Get( Tuio2DObjFrame );
			f.frame = frame;
			f.tuio = t;
			this.addFrame( f );
		}
		
		public function updateByTuio( frame:uint, fps:uint, tuio:Tuio2DObj ):void {
			if ( tuio.i != classId )
				return;
			update( frame, fps, tuio.x, tuio.y, tuio.a );
		}

		public function difference( x:Number, y:Number ):Number {
			if ( !latest )
				return -1; // There is no history to compare the coordinates
			return TrigUtil.DistanceBetweenCoordinates( x, y, latest.tuio.x, latest.tuio.y );
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