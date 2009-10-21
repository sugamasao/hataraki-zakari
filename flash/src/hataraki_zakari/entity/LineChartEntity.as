package hataraki_zakari.entity {

	public class LineChartEntity {
		
		private var _legend:String = "";
		private var _minTime:Number = 0;
		private var _maxTime:Number = 0;
		[ArrayElementType("Years")] 
		private var _years:Array = [];
		
		public function LineChartEntity() {
		}

		public function set legend(val:String):void {
			_legend = val;
		}

		public function get legend():String {
			return _legend;
		}

		public function set minTime(val:Number):void {
			_minTime = val;
		}

		public function get minTime():Number {
			return _minTime;
		}

		public function set maxTime(val:Number):void {
			_maxTime = val;
		}

		public function get maxTime():Number {
			return _maxTime;
		}

		public function set years(val:Array):void {
			_years = val;
		}

		public function get years():Array {
			return _years;
		}

	}

}

