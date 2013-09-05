package
{
	import flash.display.Sprite;
	
	/**
	 * 字体项目文件
	 * 
	 */
	public class FontLibrary extends Sprite
	{
		[Embed(source="FZSEJW.TTF", fontName="FZShaoEr-M11S",unicodeRange="", mimeType="application/x-font")]
		public static var DefaultFont : Class;
		
		
		
		/**
		 * 使用嵌入 
		 */
		public static const USE_EMBED:String = "useEmbed";
		
		/**
		 * 不使用嵌入 
		 */
		public static const NONUSE_EMBED:String = "nonuseEmbed";
		
		
		
		
		
		/**
		 *  默认字体，可以嵌入也可能不嵌入，通常根据语言（如英文为嵌入，中文不嵌入）
		 */
		public static const DEFAULT_FONT:String = "SimSun";
		
		/**
		 *  DEFAULT_FONT 是否嵌入
		 */
		public static const DEFAULT_FONT_EMBED:String = "nonuseEmbed";
		
		
		
		
		
		/**
		 * 已知的文字使用的字体，通常为嵌入字体
		 */
		public static const AFFIRMATORY_FONT:String = "DefaultFont";
		
		/**
		 * AFFIRMATORY_FONT 是否嵌入
		 */
		public static const AFFIRMATORY_FONT_EMBED:String = "useEmbed";
		
		
		/**
		 * 来自外部的文字，如后台返回，用户姓名等所使用的字体，通常为不嵌入字体 
		 */
		public static const EXTERNAL_FONT:String = "SimSun";
		
		/**
		 *  外部文字是否嵌入
		 */
		public static const EXTERNAL_FONT_EMBED:String = "nonuseEmbed";
		
		
		
		
		
		
		
		
		
	}
}