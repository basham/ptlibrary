package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.tuio.profiles.ITuioInterpreterProfile;
	import edu.iu.vis.utils.Pool;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	/**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.ADD_TUIO_2D_OBJ
     **/
    [Event(name="addTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
    
    /**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ
     **/
    [Event(name="updateTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
    
    /**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ
     **/
    [Event(name="removeTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]

	
	public class TuioInterpreter extends EventDispatcher {
		
		static private const SESSION_DIFF_THRESHOLD:Number = 10;
		
		static private var _FrameCount:uint = 0;
		
		private var sessions:Dictionary = new Dictionary(true);
		private var profiles:Array = new Array();
		
		private var _outboundConnection:OutboundTuioConnection;
		private var rag:RegionAdjacencyGraph;

		private var sessionCount:uint = 0;
		private var sourceWidth:uint = 320;
		private var sourceHeight:uint = 240;
		
		public function TuioInterpreter() {
		}
		
		static public function get FrameCount():uint {
			return _FrameCount;
		}
		
		public function get outboundConnection():OutboundTuioConnection {
			return _outboundConnection;
		}

		public function set outboundConnection( value:OutboundTuioConnection ):void {
			_outboundConnection = value;
		}

		public function addProfile( profile:ITuioInterpreterProfile ):void {
			profile.interpreter = this;
			profiles.push( profile );
		}

		public function interpret( source:BitmapData ):void {
			sourceWidth = source.width;
			sourceHeight = source.height;
			
			rag = new RegionAdjacencyGraph( source );
			rag.graph();
			
			for each( var profile:ITuioInterpreterProfile in profiles ) // Loop through profiles, each interpreting the graph
				profile.interpretGraph( rag );
			
			rag.remove();
			removeDeadSessions();
			
			_FrameCount++;
		}
		
		override public function toString():String {
			return rag.toString();
		}
		
		public function printBounds():void {
			rag.printBounds();
		}

		public function generateEventFromObj( tuio:Tuio2DObj ):void {
				
			// Continual most likely match of this Tuio to a stored Tuio session
			var bestSessionMatch:uint;
			var bestSessionDiff:Number = -1;
			
			// Attempt to find the best match in a previous Tuio session.
			for each ( var s:Tuio2DObjSession in sessions ) { // Loop through value objects
			
				var diff:Number = s.difference( tuio );
				
				if ( diff >= bestSessionDiff && bestSessionDiff >= 0 ) // Ignore session if its not the best match so far
					continue;
				
				// This session is the new best match
				bestSessionMatch = s.sessionId;
				bestSessionDiff = diff;
			}
			
			//trace('-', bestSessionDiff );
			// Establish session for this Tuio2DObj
			var newSession:Boolean = !( bestSessionDiff < SESSION_DIFF_THRESHOLD && bestSessionDiff >= 0 );
			var sid:uint = newSession ? sessionCount++ : bestSessionMatch;
			//var session:Tuio2DObjSession = newSession ? Tuio2DObjSession.GetInstance( sid, tuio.i ) : sessions[ sid ];
			var session:Tuio2DObjSession = newSession ? Pool.Get( Tuio2DObjSession ) : sessions[ sid ];

			session.sessionId = sid;
			session.classId = tuio.i;
			session.updateByTuio( FrameCount, tuio );
			
			sessions[ sid ] = session;
			
			// Broadcast event
			//trace('s=' + tuio.s, 'i=' + tuio.i, 'x=' + tuio.x, 'y=' + tuio.y, 'a=' + int(tuio.a), newSession ? '**' : '');
			var u:Tuio2DObj = session.latest.tuio;
			trace('s=' + u.s, 'i=' + u.i, 'x=' + u.x, 'y=' + u.y, 'a=' + int(u.a), newSession ? '**' : '', bestSessionDiff);
			dispatchObjEvent( new Tuio2DObjEvent( ( newSession ? Tuio2DObjEvent.ADD_TUIO_2D_OBJ : Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ ), u ) );				
		}
		
		private function removeDeadSessions():void {
			for ( var sessionKey:String in sessions )
				if ( !( sessions[ sessionKey ] as Tuio2DObjSession ).alive )
					removeSession( sessionKey );
		}
		
		private function removeSession( sessionKey:String ):void {
			var session:Tuio2DObjSession = sessions[ sessionKey ];
			dispatchObjEvent( new Tuio2DObjEvent( Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ, session.latest.tuio ) );
			//session.remove();
			Pool.Dispose( session );
			sessions[ sessionKey ] = null;
			delete( sessions[ sessionKey ] );
		}

		private function dispatchObjEvent( tuioEvent:Tuio2DObjEvent ):void {
			this.dispatchEvent( tuioEvent );
			if ( outboundConnection )
				outboundConnection.sendObjEvent( tuioEvent );
		}
	}
}