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

// ラインを描画する領域のマージン
private var _margin:Number = 0.05;

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
	_base_width = (chartCanvas.width - (chartCanvas.width * _margin* 2)) / (drawData.years.length -  1);
	_base_height = (chartCanvas.height - (chartCanvas.height * _margin)) / (drawData.maxTime - drawData.minTime);
	_base_color = 0xFF9999;
	_minTime = drawData.minTime;

	chartCanvas.graphics.lineStyle(3, _base_color, 1.00);

	// ライン描画
	drawChartLine(chartCanvas as UIComponent, drawData.years);
	var drawPoints:Array = drawChartPoint(chartCanvas as UIComponent, drawData.years);

	// 横軸描画
	drawAbscissaAxis(abscissaAxis as UIComponent, drawPoints, drawData);
	// 縦軸描画
	drawOrdinateAxis(ordinateAxis as UIComponent, drawPoints, drawData);
}

/**
 * チャートを描画する
 * @drawObj 描画対象領域
 * @lineParam 描画するデータ。LineChartYearsEntity型の配列
 */
private function drawChartLine(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = drawObj.width * _margin;
	for(var i:uint = 0; i < lineParam.length; i++) {
		// 描画する Y 座標を計算する
		var baseY:uint = _base_point.y - ((lineParam[i].time - _minTime + _base_height) * _base_height);
		if(i == 0) {
			drawObj.graphics.moveTo(baseX, baseY);
		} else if (i == lineParam.length - 1) {
			drawObj.graphics.curveTo(baseX, baseY, baseX, _base_point.y - ((lineParam[i].time - _minTime + _base_height) * _base_height));
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
 * @return drawResultPoints Array(Point) 実際にポイントを打った座標の配列
 */
private function drawChartPoint(drawObj:UIComponent, lineParam:Array):Array {
	var baseX:uint = drawObj.width * _margin;
	var drawPoint:Point = new Point(0, 0);
	var drawResultPoints:Array = [];
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
			drawResultPoints.push(drawPoint);
		}
	}
	return drawResultPoints;
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

/**
 * 縦軸を描画する
 * @param drawObj 描画領域
 * @param drawPoints ラインの中で描画したポイントの座標
 * @param 描画データ
 */
private function drawAbscissaAxis(drawObj:UIComponent, drawPoints:Array, drawData:LineChartEntity):void {
	// ライン用描画設定
	var rowLabelY:uint = _base_point.y - (drawData.minTime - _minTime + _base_height) * _base_height;
	var highLabelY:uint = _base_point.y - (drawData.maxTime - _minTime + _base_height) * _base_height;
	var rowPoint:Point = drawObj.localToGlobal(new Point(drawObj.width, rowLabelY));
	var highPoint:Point = drawObj.localToGlobal(new Point(drawObj.width, highLabelY));
	this.graphics.lineStyle(1, 0x333333, 0.5);
	this.graphics.moveTo(rowPoint.x, rowPoint.y);
	this.graphics.lineTo(parent.width, rowPoint.y);
	this.graphics.moveTo(highPoint.x, highPoint.y);
	this.graphics.lineTo(parent.width, highPoint.y);

	var rowLabel:Label = new Label();
	rowLabel.text = drawData.minTime.toString();
	drawObj.addChild(rowLabel);
	rowLabel.y = rowLabelY - 10; // 微調整

	var highLabel:Label = new Label();
	highLabel.text = drawData.maxTime.toString();
	drawObj.addChild(highLabel);
	highLabel.y = highLabelY - 10; // 微調整

	var minTime:uint = drawData.minTime;
	var maxTime:uint = drawData.maxTime;
	var diffTime:uint = maxTime - minTime;
	var upCount:uint = 0;

	// メモリ線の間隔
	if(diffTime < 10) {
		upCount = 2;
	} else if(diffTime < 50) {
		upCount = 10;
	} else if(diffTime < 100) {
		upCount = 15;
	} else if(diffTime < 200) {
		upCount = 25;
	} else if(diffTime < 300) {
		upCount = 50;
	} else {
		upCount = 75;
	}

	// メモリ線を描画する
	for(var i:uint = minTime; i < maxTime; i++) {
		if(i % upCount == 0) {
			var pointY:uint = _base_point.y - (i - _minTime + _base_height) * _base_height;
			var label:Label = new Label();
			label.text = String(i);
			drawObj.addChild(label);
			label.y = pointY - 10;

			var point:Point = drawObj.localToGlobal(new Point(drawObj.width, pointY));
			this.graphics.moveTo(point.x, point.y);
			this.graphics.lineTo(parent.width, point.y);
		}
	}
}

/**
 * 横軸を描画する
 * @param drawObj 描画領域
 * @param drawPoints ラインの中で描画したポイントの座標
 * @param 描画データ
 */
private function drawOrdinateAxis(drawObj:UIComponent, drawPoints:Array, drawData:LineChartEntity):void {
	for(var i:uint = 0; i < drawPoints.length; i++) {
		var label:Label = new Label();
		label.text = (drawData.years[i].year.toString() + "/" + drawData.years[i].month.toString());
		drawObj.addChild(label);
		// だいたい真ん中になるようにあわせる
		label.x = drawPoints[i].x - 25;
	}
}


