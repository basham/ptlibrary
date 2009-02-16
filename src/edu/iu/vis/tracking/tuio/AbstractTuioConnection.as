package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.tuio.Tuio2DObjEventMessage;
	import edu.iu.vis.tracking.tuio.Tuio2DObjMessage;
	import edu.iu.vis.tracking.symbols.dss.DSSymbol;
	
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	public class AbstractTuioConnection extends EventDispatcher {
		
		protected var connection:LocalConnection;
		
		private var _connectionName:String = '';
		
		public function AbstractTuioConnection( connectionName:String ) {
			registerClassAlias("it.h_umus.tuio.events.Tuio2DObjEvent", Tuio2DObjEvent);
			registerClassAlias("it.h_umus.tuio.Tuio2DObj", Tuio2DObj);
			registerClassAlias("edu.iu.vis.tracking.symbols.dss.DSSymbol", DSSymbol);
			registerClassAlias("edu.iu.vis.tracking.Tuio2DObjMessage", Tuio2DObjMessage);
			registerClassAlias("edu.iu.vis.tracking.Tuio2DObjEventMessage", Tuio2DObjEventMessage);

			this.connection = new LocalConnection();
			this.connectionName = connectionName;
		}

		public function get connectionName():String {
			return _connectionName;
		}
		
		public function set connectionName( value:String ):void {
			_connectionName = value;
			connect();
		}
		
		private function connect():void {
		}
	}
}