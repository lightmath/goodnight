package org.flexlite.events
{
	import flash.events.Event;
	
	
	/**
	 * 
	 * @author LC
	 */
	public class PublishEvent extends Event
	{
		/**
		 * 字体嵌入完成
		 */		
		public static const EMBED_FONT_COMPLETE:String = "embedFontComplete";
		/**
		 * 编译程序完成
		 */		
		public static const COMPILE_COMPLETE:String = "compileComplete";
		/**
		 * 混淆，加密完成
		 */		
		public static const ENCRYPT_COMPLETE:String = "encryptComplete";
		
		public function PublishEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}