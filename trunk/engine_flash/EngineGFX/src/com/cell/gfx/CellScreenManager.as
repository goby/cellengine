package com.cell.gfx
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 屏幕管理类，游戏跟节点。
	 */
	public class CellScreenManager extends Sprite
	{
		private var adapter 			: IScreenAdapter;
		
		private var current_screen		: CellScreen;
		
		private var update_time			: int = 0;
		
		private var frame_interval		: int = 1;
		
		private var next_screen_name	: String;
		private var next_screen_args	: Array;
		
		private var transition			: IScreenTransition;
				
		public function CellScreenManager(adapter:IScreenAdapter)
		{
			this.adapter = adapter;
			super.addEventListener(Event.ENTER_FRAME, onUpdate);
			super.addEventListener(Event.EXIT_FRAME, onLastUpdate);
		}
		
		protected function onUpdate(e:Event) : void
		{
			var cur_time : int = getTimer();
			var interval : int = cur_time - update_time;
			this.update_time = cur_time;
		
			if (current_screen != null) {
				current_screen._interval = interval;
				current_screen.update();
			}
				
			if (next_screen_name != null) {
				tryChangeStage();
			}
		}
		
		protected function onLastUpdate(e:Event) : void
		{
			if (this.transition != null) {
				this.transition.render(this);
			}
		}
		
		/**设置切换屏幕时的特效*/
		public function setTransition(t:IScreenTransition) : void
		{
			this.transition = t;
		}
		
		/**获得切换屏幕时的特效*/
		public function getTransition() : IScreenTransition
		{
			return this.transition;
		}
		
		/**是否正在进入当前屏幕*/
		public function isTransitionIn() : Boolean
		{
			if (this.transition != null) {
				return this.transition.isTransitionIn();
			}
			return false;
		}
		
		/**只否正在离开当前屏幕*/
		public function isTransitionOut() : Boolean
		{
			if (this.transition != null) {
				return this.transition.isTransitionOut();
			}
			return false;
		}
		
		/**只否正在进入或离开当前屏幕*/
		public function isTransition() : Boolean
		{
			if (this.transition != null) {
				return this.transition.isTransitionIn() || this.transition.isTransitionOut();
			}
			return false;
		}
		
		protected function tryChangeStage() : void
		{
			// clear current stage
			if (current_screen!=null)
			{
				if (!isTransition())
				{
					this.removeChild(current_screen);
					current_screen.removed(this);
					current_screen = null;
				}
			}
			else
			{
				this.current_screen = adapter.createScreen(this, next_screen_name);
				trace("ChangeStage -> "+ current_screen.toString());	
				this.addChild(current_screen);
				this.current_screen.added(this, next_screen_args);
				if (this.transition != null) {
					this.transition.startTransitionIn();
				}
				this.next_screen_args	= null;
				this.next_screen_name	= null;
			}
		}
		
		/**开始切换到下一屏幕
		 * @param screen_name 下一屏的名字，一般由IScreenAdapter提供。
		 * @param args 参数组
		 */
		public function changeScreen(screen_name:String, args:Array=null) : void
		{
			this.next_screen_name = screen_name;
		}
	}
}