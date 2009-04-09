package edu.iu.vis.net {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	public class AbstractLocalConnection extends EventDispatcher {
		
		public var autoConnect:Boolean;
		
		protected var connection:LocalConnection;
		
		private var _connectionName:String = '';
		private var _connected:Boolean = false;
		
		public function AbstractLocalConnection( connectionName:String, autoConnect:Boolean = false ) {
			this.autoConnect = autoConnect;
			this.connection = new LocalConnection();
			this.connection.client = this;
			this.connection.allowDomain('*');
			this.connectionName = connectionName;
			this.connection.addEventListener(StatusEvent.STATUS, onStatus);
			this.connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}

		public function get connectionName():String {
			return _connectionName;
		}
		
		public function set connectionName( value:String ):void {
			_connectionName = value;
			if ( autoConnect )
				connect();
		}
		
		public function get connected():Boolean {
			return _connected;
		}
		
		protected function set connected( value:Boolean ):void {
			_connected = value;
		}
		
		protected function connect():void {
			try {
		    	connection.connect(connectionName);
			}
			catch ( error:ArgumentError ) {
		    	trace( error.message );
			}
		}
		
		protected function onStatus( e:StatusEvent ):void {
			switch( e.level ) {
				case "status":
					//trace('++ Connected');
					_connected = true;
					break;
				case "error":
					//trace('** Crappy Connection');
					_connected = false;
					break;
			}
		}
		
		protected function onAsyncError( e:AsyncErrorEvent ):void {
			trace(e);
		}
		
		public function close():void {
			try {
				this.connection.close();
			}
			catch ( error:ArgumentError ) {
				trace( error.message );
			}
		}
		
	}
}