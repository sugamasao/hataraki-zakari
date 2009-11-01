import mx.core.UIComponent;
import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;

import hataraki_zakari.entity.*;

private var _base_point:Point = null; // 描画範囲の原点（左下）
private var _base_width:Number = 0; // メモリの間隔（幅）
private var _base_height:Number = 0; // メモリの間隔（高さ）
private var _base_color:uint = 0x000000;

private var _minTime:uint = 0;

private function init():void {
	trace("init+++++++++++")
}

public function draw(drawData:LineChartEntity):void {
	_base_point = chartCanvas.localToGlobal(new Point(chartCanvas.x, chartCanvas.y + chartCanvas.height))
	 // スタートの余白はここでやれば良いお
	_base_width = chartCanvas.width / (drawData.years.length -  1);
	_base_height = chartCanvas.height / (drawData.maxTime - drawData.minTime);
	_base_color = 0xFF9999;
	_minTime = drawData.minTime;

	chartCanvas.graphics.lineStyle(3, _base_color, 1.00);
	drawChartLine(chartCanvas as UIComponent, drawData.years);
	drawChartPoint(chartCanvas as UIComponent, drawData.years);
}

private function drawChartLine(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = 0;
	for(var i:uint = 0; i < lineParam.length; i++) {
		trace("lineParam ",baseX,  ((lineParam[i].time - _minTime) * _base_height))
		if(i == 0) {
			drawObj.graphics.moveTo(baseX, _base_point.y - ((lineParam[i].time - _minTime) * _base_height));
		} else if (i == lineParam.length - 1) {
			drawObj.graphics.curveTo(baseX, _base_point.y - ((lineParam[i].time - _minTime) * _base_height), baseX, _base_point.y - ((lineParam[i].time - _minTime) * _base_height));
		} else {
			//drawObj.graphics.curveTo(baseX , _base_point.y - ((lineParam[i].time - _minTime) * _base_height) , baseX + _base_width ,_base_point.y - ((lineParam[i+1].time- _minTime) * _base_height));
			drawObj.graphics.lineTo(baseX , _base_point.y - ((lineParam[i].time - _minTime) * _base_height));
		}
		baseX += _base_width;
	}
}

private function drawChartPoint(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = 0;
	var drawPoint:Point = new Point(0, 0);
	//trace("drawChartPoint")
	for(var i:uint = 0; i < lineParam.length; i++) {
		//baseX += _base_point.y;
		// 前後 1px を探すので、最悪３回実施する
		drawPoint = foundDrawPoint(drawObj, baseX);
		if(drawPoint == null) {
			drawPoint = foundDrawPoint(drawObj, baseX + 1);
		}
		if(drawPoint == null) {
			drawPoint = foundDrawPoint(drawObj, baseX - 1);
		}

		if(drawPoint != null) {
			//trace("draw Point");
			var monthPoint:UIComponent = new UIComponent();
			monthPoint.graphics.lineStyle(3, _base_color + 0x333333, 0.5);
			monthPoint.graphics.beginFill(_base_color);
			monthPoint.graphics.drawCircle(0, 0, 5);
			monthPoint.x = drawPoint.x;
			monthPoint.y = drawPoint.y;
			//monthPoint.buttonMode = true;
			monthPoint.toolTip = lineParam[i].year + "/" + lineParam[i].month + "の思い出：\n" + lineParam[i].comment
			drawObj.addChild(monthPoint);
			baseX += _base_width;
		}
	}
}

private function foundDrawPoint(drawObj:UIComponent, baseX:uint):Point {
	var resultPoint:Point = null;
	//trace("********", drawObj)
	var bitmap:BitmapData = new BitmapData(drawObj.width, drawObj.height);
	bitmap.draw(drawObj);

	for(var i:uint = 0; i < drawObj.height; i++) {
		if(bitmap.getPixel(baseX, i) == _base_color) {
			resultPoint = new Point(baseX, i);
			break;
		}
	}
	return resultPoint;
}

