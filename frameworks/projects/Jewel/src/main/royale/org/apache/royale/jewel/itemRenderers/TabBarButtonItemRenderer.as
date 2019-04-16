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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.INavigationRenderer;
	import org.apache.royale.jewel.beads.controls.TextAlign;
	import org.apache.royale.jewel.supportClasses.util.getLabelFromData;
    
	/**
	 *  The TabBarButtonItemRenderer defines the basic Item Renderer for a Jewel 
     *  TabBar List Component. It handles Objects with "label" and "href" data.
	 *  Extend this (you can do it in MXML) to support more data like for example: icon data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TabBarButtonItemRenderer extends StyledMXMLItemRenderer implements INavigationRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TabBarButtonItemRenderer()
		{
			super();

			typeNames = "jewel tabbarbutton";
			addClass("selectable");

			if(MXMLDescriptor != null)
			{
				addClass("mxmlContent");
			}

			textAlign = new TextAlign();
			textAlign.align = TextAlign.CENTER;
			addBead(textAlign);
		}

		private var _href:String = "#";
        /**
         *  the navigation link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get href():String
		{
            return _href;   
		}
		public function set href(value:String):void
		{
            _href = value;
		}

		private var _text:String = "";

		[Bindable(event="textChange")]
        /**
         *  The text of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
            if(value != _text) {
				_text = value;
				COMPILE::JS
				{
				if(MXMLDescriptor == null)
				{
					element.innerHTML = _text;
				}
				}
				dispatchEvent(new Event('textChange'));
			}
		}

		private var textAlign:TextAlign;

		/**
		 *  How text align in the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get align():String
		{
			return textAlign.align;
		}

		public function set align(value:String):void
		{
			textAlign.align = value;
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set data(value:Object):void
		{
			text = getLabelFromData(this, value);
            super.data = value;
			
            if(value.href !== undefined)
			{
                href = String(value.href);
			}

			// COMPILE::JS
			// {
			// if(textNode != null)
			// {
			// 	textNode.nodeValue = text;
			// 	(element as HTMLElement).setAttribute('href', href);
			// }	
			// }
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLSpanElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var span:HTMLSpanElement = addElementToWrapper(this, 'span') as HTMLSpanElement;
			span.className = "content";
			positioner = document.createElement('button') as WrappedHTMLElement;
            //a.setAttribute('href', href);

			// if(MXMLDescriptor == null)
			// {
			// 	textNode = document.createTextNode('') as Text;
			// 	a.appendChild(textNode);
			// }

            return element;
        }

		COMPILE::JS
		private var _positioner:WrappedHTMLElement;

		COMPILE::JS
		override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
            _positioner.royale_wrapper = this;
			_positioner.appendChild(element);
		}

		private var _selectable:Boolean = true;
		/**
         *  <code>true</code> if the item renderer is can be selected
         *  false otherwise. Use to configure a renderer to be non 
         *  selectable.
         *  
         *  Defaults to true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function get selectable():Boolean
		{
			return _selectable;
		}
		override public function set selectable(value:Boolean):void
		{
			_selectable = value;
			toggleClass("selectable", _selectable);	
		}

		/**
		 * @private
		 * 
		 * Styles are handled in CSS and usualy This renderer does not uses "selected" state
	 	 * at least if the drawer is closed after selection.
		 */
		override public function updateRenderer():void
		{
			// there's no selection only hover state
			if(hoverable)
            	toggleClass("hovered", hovered);
			if(selectable)
            	toggleClass("selected", selected);
		}
	}
}
