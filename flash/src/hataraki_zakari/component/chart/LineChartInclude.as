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

/**
 * creationComplete イベントハンドラ。
 * 画面に描画したタイミングでの初期化を行う。
 */
private function onCreationComplete(event:Event):void {
	trace("onCreationComplete", event);
}

/**
 * チャートに描画する
 * @param drawData 描画データ。LineChartEntity
 */
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

/**
 * チャートを描画する
 * @drawObj 描画対象領域
 * @lineParam 描画するデータ。LineChartYearsEntity型の配列
 */
private function drawChartLine(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = 0;
	for(var i:uint = 0; i < lineParam.length; i++) {
		// 描画する Y 座標を計算する
		var baseY:uint = _base_point.y - ((lineParam[i].time - _minTime) * _base_height);
		if(i == 0) {
			drawObj.graphics.moveTo(baseX, baseY);
		} else if (i == lineParam.length - 1) {
			drawObj.graphics.curveTo(baseX, baseY, baseX, _base_point.y - ((lineParam[i].time - _minTime) * _base_height));
		} else {
			drawObj.graphics.lineTo(baseX , baseY);
		}
		baseX += _base_width;
	}
}

/**
 * チャート上にポイントを描画する
 * @param drawObj 描画する UIComponent
 * @param lineParam 描画するデータ。LineChartYearsEntity型の配列
 */
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
			monthPoint.graphics.lineStyle(3, _base_color * 1.25 , 0.5);
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

/**
 * チャート上に打つポイントを描画する座標を探する
 * baseX を元に、 Y 座標をシーケンシャルに探す
 * @param drawObj 探索するUIComponent
 * @param baseX 探索する X 座標
 * @return Point 見つかった座標。見つからなかった場合は null を返す
 */
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

