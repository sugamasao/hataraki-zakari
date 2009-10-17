package hataraki_zakari.utils {

	public class Logger {
		public function Logger() {
		}

		public static function info(message:String):void {
			Logger.write(message);
		}

		private static function write(message:String):void {
			// debug モードの時だけ出力するよ
			CONFIG::DEBUG {
				trace(message);
			}
		}
	}
}
