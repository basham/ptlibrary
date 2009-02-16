package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.tuio.Tuio2DObjEventMessage;
	import it.h_umus.tuio.Tuio2DObj;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.StatusEvent;
	
	public class OutboundTuioConnection extends AbstractTuioConnection {
		
		private var _connected:Boolean = false;
		
		public function OutboundTuioConnection( connectionName:String ) {
			super(connectionName);
			connection.addEventListener(StatusEvent.STATUS, onStatus);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}
		
		public function get connected():Boolean {
			return _connected;
		}
		
		private function onStatus( e:StatusEvent ):void {
			switch( e.level ) {
				case "status":
					trace('++ Connected');
					_connected = true;
					break;
				case "error":
					trace('** Crappy Connection');
					_connected = false;
					break;
			}
		}
		
		private function onAsyncError( e:AsyncErrorEvent ):void {
			trace(e);
		}
		
		public function sendObjEvent( eventType:String, tuioObj:Tuio2DObj ):void {
			trace( connectionName);
			connection.send( connectionName, "tuioDispatcher", new Tuio2DObjEventMessage( eventType, tuioObj ) );
		}
	}
}