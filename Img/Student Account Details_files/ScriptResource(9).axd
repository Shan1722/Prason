﻿(function(){Type.registerNamespace("Telerik.Web.UI");
$telerik.findMultiPage=$find;
$telerik.toMultiPage=function(c){return c;
};
var a=$telerik.$,b=Telerik.Web.UI;
b.RadPageViewCollection=function(c){this._owner=c;
this._data=[];
};
b.RadPageViewCollection._createIframe=function(d){var c=document.createElement("iframe");
c.frameBorder="0";
c.style.width="100%";
c.style.height="100%";
if(d._contentUrl){c.src=d._contentUrl;
}d.get_element().appendChild(c);
a(d.get_element()).find("iframe").attr("src",d._contentUrl);
};
b.RadPageViewCollection.prototype={get_count:function(){return this._data.length;
},_add:function(c){this._insert(this.get_count(),c);
},_insert:function(c,d){Array.insert(this._data,c,d);
d._multiPage=this._owner;
},insert:function(c,d){this._insert(c,d);
this._owner._onPageViewInserted(c,d);
},add:function(c){this.insert(this.get_count(),c);
},getPageView:function(c){return this._data[c]||null;
},removeAt:function(c){var d=this.getPageView(c);
if(d){this.remove(d);
}},remove:function(c){this._owner._onPageViewRemoving(c);
c.unselect();
Array.remove(this._data,c);
this._owner._onPageViewRemoved(c);
}};
b.RadPageViewCollection.registerClass("Telerik.Web.UI.RadPageViewCollection");
b.RadPageView=function(c){this._element=c;
this._defaultButton="";
this._contentUrl;
};
b.RadPageView.prototype={initialize:function(){if(this.get_defaultButton()){this._onKeyPressDelegate=Function.createDelegate(this,this._onKeyPress);
$telerik.addHandler(this._element,"keypress",this._onKeyPressDelegate);
}},dispose:function(){if(this._onKeyPressDelegate){$telerik.removeHandler(this._element,"keypress",this._onKeyPressDelegate);
}},_onKeyPress:function(c){return WebForm_FireDefaultButton(c.rawEvent,this.get_defaultButton());
},_select:function(d){var c=this.get_multiPage();
if(!c){this._cachedSelected=true;
return;
}c._selectPageViewByIndex(this.get_index(),d);
},hide:function(){var c=this.get_element();
if(!c){return;
}Sys.UI.DomElement.addCssClass(c,"rmpHiddenView");
c.style.display="none";
},show:function(){var c=this.get_element();
if(!c){return;
}Sys.UI.DomElement.removeCssClass(c,"rmpHiddenView");
c.style.display="block";
if(this._repaintCalled){return;
}$telerik.repaintChildren(this);
this._repaintCalled=true;
if(this._contentUrl){var d=a("iframe",c);
if(!d.attr("src")){d.attr("src",this._contentUrl);
}}},get_element:function(){return this._element;
},get_index:function(){return Array.indexOf(this.get_multiPage().get_pageViews()._data,this);
},get_id:function(){return this._id;
},set_id:function(c){this._id=c;
if(this.get_element()){this.get_element().id=c;
}},get_multiPage:function(){return this._multiPage||null;
},get_selected:function(){return this.get_multiPage().get_selectedPageView()==this;
},set_selected:function(c){if(c){this.select();
}else{this.unselect();
}},get_defaultButton:function(){return this._defaultButton;
},set_defaultButton:function(c){this._defaultButton=c;
},select:function(){this._select();
},unselect:function(){if(this.get_selected()){this.get_multiPage().set_selectedIndex(-1);
}},get_contentUrl:function(){return this._contentUrl;
},set_contentUrl:function(e){this._contentUrl=e;
var d=this.get_element(),c=a(d).find("iframe");
if(d&&c.length==0){b.RadPageViewCollection._createIframe(this);
}c.attr("src",e);
}};
b.RadPageView.registerClass("Telerik.Web.UI.RadPageView");
b.RadMultiPage=function(c){Telerik.Web.UI.RadMultiPage.initializeBase(this,[c]);
this._pageViews=new b.RadPageViewCollection(this);
this._selectedIndex=-1;
this._pageViewData=null;
this._changeLog=[];
};
b.RadMultiPage.prototype={_logInsert:function(d){if(!this._trackingChanges){return;
}var c={};
if(d.get_id()){c.id=d.get_id();
}Array.add(this._changeLog,{type:1,index:d.get_index(),data:c});
},_logRemove:function(c){if(!this._trackingChanges){return;
}Array.add(this._changeLog,{type:2,index:c.get_index()});
},_onPageViewRemoving:function(c){this._logRemove(c);
},_onPageViewInserted:function(d,g){var c=g.get_element();
if(!c){c=g._element=document.createElement("div");
}c.style.display="none";
if(g.get_id()){c.id=g.get_id();
}if(g._contentUrl){b.RadPageViewCollection._createIframe(g);
}var f=this.get_pageViews().getPageView(d+1);
var e=$get(this.get_clientStateFieldID());
if(f){e=f.get_element();
}this.get_element().insertBefore(c,e);
if(g._cachedSelected){g._cachedSelected=false;
g.select();
}this._logInsert(g);
},_onPageViewRemoved:function(c){if(c.get_element()){this.get_element().removeChild(c.get_element());
}},_selectPageViewByIndex:function(d,f){if(this._selectedIndex==d){return;
}if(!this.get_isInitialized()){this._selectedIndex=d;
return;
}if(d<-1||d>=this.get_pageViews().get_count()){return;
}var e=this.get_selectedPageView();
this._selectedIndex=d;
var c=this.get_selectedPageView();
if(!f){if(e){e.hide();
}if(c){c.show();
}}this.updateClientState();
},trackChanges:function(){this._trackingChanges=true;
},commitChanges:function(){this.updateClientState();
this._trackingChanges=false;
},get_pageViewData:function(){return this._pageViewData;
},set_pageViewData:function(c){this._pageViewData=c;
},initialize:function(){b.RadMultiPage.callBaseMethod(this,"initialize");
var e=this.get_pageViewData();
for(var c=0;
c<e.length;
c++){var d=new b.RadPageView($get(e[c].id));
d._id=e[c].id;
d.set_defaultButton(e[c].defaultButton);
d._contentUrl=e[c].contentUrl;
this._pageViews._add(d);
d.initialize();
}},dispose:function(){b.RadMultiPage.callBaseMethod(this,"dispose");
for(var c=0;
c<this.get_pageViews().get_count();
c++){var d=this.get_pageViews().getPageView(c);
d.dispose();
}},findPageViewByID:function(d){for(var c=0;
c<this.get_pageViews().get_count();
c++){var e=this.get_pageViews().getPageView(c);
if(e.get_id()==d){return e;
}}return null;
},get_pageViews:function(){return this._pageViews;
},get_selectedIndex:function(){return this._selectedIndex;
},set_selectedIndex:function(c){this._selectPageViewByIndex(c);
},get_selectedPageView:function(){return this.get_pageViews().getPageView(this.get_selectedIndex());
},saveClientState:function(){var c={};
c.selectedIndex=this.get_selectedIndex();
c.changeLog=this._changeLog;
return Sys.Serialization.JavaScriptSerializer.serialize(c);
}};
b.RadMultiPage.registerClass("Telerik.Web.UI.RadMultiPage",Telerik.Web.UI.RadWebControl);
})();