////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.controls.beads.controllers
{
	import mx.collections.XMLListCollection;
	
	import org.apache.royale.core.IMenu;
	import org.apache.royale.html.beads.controllers.CascadingMenuSelectionMouseController;
	import org.apache.royale.core.ICascadingMenuModel
	import org.apache.royale.html.CascadingMenu;
	import org.apache.royale.events.ItemClickedEvent;
	
	import mx.events.MenuEvent;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import mx.supportClasses.IFoldable;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.html.beads.models.MenuModel;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.geom.Point;

/**
 *  The CascadingMenuSelectionMouseController is the default controller for emulation cascading menu
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

	public class CascadingMenuSelectionMouseController extends org.apache.royale.html.beads.controllers.CascadingMenuSelectionMouseController
	{

		override protected function getSubMenuDataProvider(node:Object, model:ICascadingMenuModel):Object
		{
			if (!(node is XML))
			{
				return super.getSubMenuDataProvider(node, model)
			}
			return new XMLListCollection((node as XML).children());
		}
		
		override protected function getHasMenu(node:Object, model:ICascadingMenuModel):Boolean
		{
			if (!(node is XML))
			{
				return super.getHasMenu(node, model)
			}
			return (node as XML).children().length() > 0;
		}

		override protected function removeMenu(menu:UIBase):void
		{
			super.removeMenu(menu);
			// this fixes issues of menu not being re-added after removal in mx control
			if (!menu.parent && menu.visible)
			{
				menu.visible = false;
			}
		}

		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			super.selectedHandler(event);
			if (event.target is IFoldable && (event.target as IFoldable).canUnfold)
			{
				return; // this is not selection, but rather a folding action
			}
			var menuEvent:MenuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
			var data:Object = event.target.data;
			menuEvent.item = data;
			var menu:IMenu = _strand as IMenu;
			var label:String;
			if (data is XML)
			{
				label = data.attribute(menu.labelField);
			}
			else
			{
				label = data[menu.labelField];
			}
			menuEvent.label = label;
			menuEvent.index = event.index;
			findMenuDispatcher().dispatchEvent(menuEvent);
		}

		/**
		 * @private
		 * 
		 *  Search for an open menu strand according to the given data provider.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override protected function getMenuWithDataProvider(menuList:Array, dp:Object):CascadingMenu
		{
			if (!(dp is XMLListCollection))
			{
				return super.getMenuWithDataProvider(menuList, dp);
			}
			var xmlListCollection:XMLListCollection = dp as XMLListCollection;
			// go over open menus and return the one with the given data provider
			for (var i:int = 0; i < menuList.length; i++)
			{
				var cascadingMenu:CascadingMenu = menuList[i] as CascadingMenu;
				if (cascadingMenu && (cascadingMenu.dataProvider as XMLListCollection).toXMLString() == xmlListCollection.toXMLString())
				{
					return cascadingMenu;
				}
			}
			return null;
		}

		override protected function getParentMenuBar():IEventDispatcher
		{
			var parentMenuBar:IEventDispatcher = (_strand as IMenu).parentMenuBar;
			return parentMenuBar ? parentMenuBar : _strand as IEventDispatcher;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (!(value as IUIBase).visible)
			{
				removeClickOutHandler(value);
				(value as IEventDispatcher).addEventListener('show', showHandler);
			}
		}

		protected function showHandler(event:Event):void
		{
			MenuModel.menuList.push(event.target);
			addClickOutHandler(event.target);
		}

		override protected function showSubMenu(menu:IMenu, component:IUIBase):void
		{
			var p:Point = PointUtils.localToGlobal(new Point(0, 0), component);
			menu.show(component, p.x + component.width, p.y);
		}


	}

}
