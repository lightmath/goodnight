package com.pw282.swf.tags.shapes
{
	import com.pw282.swf.data.Rect;
	import com.pw282.swf.data.ShapeWithStyle;
	
	import com.pw282.swf.tags.Tag;
	
	import com.pw282.swf.utils.Tools;
	
	public class DefineShape4Tag extends Tag
	{
		public var ShapeId:int;
		public var ShapeBounds:Rect;
		public var EdgeBounds:Rect;
		public var Reserved:uint;
		public var UsesFillWindingRule:uint;
		public var UsesNonScalingStrokes:uint;
		public var UsesScalingStrokes:uint;
		public var Shapes:ShapeWithStyle;
		public function DefineShape4Tag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			ShapeId = bt.readUnsignedShort();
			ShapeBounds = new Rect(bt);
			EdgeBounds = new Rect(bt);
			var start:int = bt.position * 8;
			Reserved = Tools.readUBits(bt, start, 5);
			UsesFillWindingRule = Tools.readUBits(bt, start + 5, 1);
			UsesNonScalingStrokes = Tools.readUBits(bt, start + 6, 1);
			UsesScalingStrokes = Tools.readUBits(bt, start + 7, 1);
			Shapes = new ShapeWithStyle(bt);
		}
		override public function toString():String{
			return super.toString() + "\n ShapeId:" + ShapeId
				+ "\n ShapeBounds:" + ShapeBounds
				+ "\n EdgeBounds:" + EdgeBounds
				+ "\n Reserved:" + Reserved
				+ "\n UsesFillWindingRule:" + UsesFillWindingRule
				+ "\n UsesNonScalingStrokes:" + UsesNonScalingStrokes
				+ "\n UsesScalingStrokes:" + UsesScalingStrokes
				+ "\n Shapes:" + Shapes
		}
	}
}