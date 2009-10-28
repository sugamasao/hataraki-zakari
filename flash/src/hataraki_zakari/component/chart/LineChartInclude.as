import mx.core.UIComponent;
import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;

import hataraki_zakari.entity.*;

private static const BASE_Y_POINT:uint = 300;
private static const BASE_X_WIDTH:uint = 100;
private static const DRAW_COLOR:uint = 0xCCCC00;

private function init():void {
	trace("init+++++++++++")
}

public function draw(drawData:LineChartEntity):void {
	trace("draw!!!!!!", "this.id=", this.id);
	var array:Array = [100, 140, 200, 100];
	var roundObject:UIComponent = new UIComponent();
	roundObject.graphics.lineStyle(2, DRAW_COLOR, .75);

	for each(var years:Years in drawData.years) {
		trace("******", years.year)
	}

	this.addChild(roundObject);

	this.graphics.lineStyle(3, DRAW_COLOR, 1.00);
	drawChartLine(this as UIComponent, drawData.years);
	drawChartPoint(this as UIComponent, drawData.years);
	//drawChartLine(this as UIComponent, array);
	//drawChartPoint(this as UIComponent, array);
}

private function drawChartLine(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = 0;
	for(var i:uint = 0; i < lineParam.length; i++) {
		baseX += BASE_X_WIDTH;
		//trace("drawChart ", baseX, BASE_Y_POINT - lineParam[i])
		if(i == 0) {
			drawObj.graphics.moveTo(baseX, BASE_Y_POINT - lineParam[i].time);
		} else if (i == lineParam.length - 1) {
			drawObj.graphics.curveTo(baseX, BASE_Y_POINT - lineParam[i].time, baseX, BASE_Y_POINT - lineParam[i].time);
		} else {
			drawObj.graphics.curveTo(baseX , BASE_Y_POINT - lineParam[i].time , baseX + BASE_X_WIDTH, BASE_Y_POINT - lineParam[i+1].time);
		}
	}
}

private function drawChartPoint(drawObj:UIComponent, lineParam:Array):void {
	var baseX:uint = 0;
	var drawPoint:Point = new Point(0, 0);
	trace("drawChartPoint")
	for(var i:uint = 0; i < lineParam.length; i++) {
		baseX += BASE_X_WIDTH;
		drawPoint = foundDrawPoint(drawObj, baseX, BASE_Y_POINT, 0);

		if(drawPoint != null) {
			trace("draw Point");
			var monthPoint:UIComponent = new UIComponent();
			monthPoint.graphics.lineStyle(3, DRAW_COLOR, 0.75);
			monthPoint.graphics.beginFill(0x333333);
			monthPoint.graphics.drawCircle(0, 0, 5);
			monthPoint.x = drawPoint.x;
			monthPoint.y = drawPoint.y;
			//monthPoint.buttonMode = true;
			monthPoint.toolTip = lineParam[i].year + "/" + lineParam[i].month + "の思い出：\n" + lineParam[i].comment
			drawObj.addChild(monthPoint);
		}
	}
}

private function foundDrawPoint(drawObj:UIComponent, baseX:uint, startY:uint, endY:uint):Point {
	var resultPoint:Point = null;
	var bitmap:BitmapData = new BitmapData(this.width, this.height);
	bitmap.draw(this);

	for(var i:uint = endY; i < startY; i++) {
		//trace("bitmap.getPixel x =", baseX , " y =", i, " pixel=", bitmap.getPixel(baseX, i), "target_color =", DRAW_COLOR, "0.75=", 0xFFFFFF);
		if(bitmap.getPixel(baseX, i) == DRAW_COLOR) {
			trace("")
			resultPoint = new Point(baseX, i);
			break;
		}
	}
	return resultPoint;
}

