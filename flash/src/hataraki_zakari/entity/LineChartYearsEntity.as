package hataraki_zakari.entity {
	public class LineChartYearsEntity {
		private var _year:uint = 0;
		private var _month:uint = 0;
		private var _time:Number = 0;
		private var _comment:String = "";

		public function LineChartYearsEntity() {
		}

		public function set year(val:uint):void {
			_year = val;
		}

		public function get year():uint {
			return _year;
		}

		public function set month(val:uint):void {
			_month = val;
		}

		public function get month():uint {
			return _month;
		}

		public function set time(val:uint):void {
			_time = val;
		}

		public function get time():uint {
			return _time;
		}

		public function set comment(val:String):void {
			_comment = val;
		}

		public function get comment():String {
			return _comment;
		}
	}
}
