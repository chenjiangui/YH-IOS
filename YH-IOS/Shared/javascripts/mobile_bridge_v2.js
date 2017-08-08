MOBILEBRIDGEVERSION = '2.0.1'

String.prototype.trim = function() {
  return this.replace(/(^\s*)|(\s*$)/g,'');
}
window.onerror = function(e) {
  if(window.AndroidJSBridge && window.AndroidJSBridge.jsException) {
    window.AndroidJSBridge.jsException(e);
  }
  else {
    console.log(typeof(e));
    console.log(e);
  }
}

window.MBV2WithinAndroid = {
  platform: 'android',
  version: MOBILEBRIDGEVERSION,
  version: function() {
    return window.MobileBridge.platform + " " + MOBILEBRIDGEVERSION;
  },
  htmlError: function(message) {
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.htmlError) === "function") {
      window.AndroidJSBridge.htmlError(message);
    }

    console.log(message);
  },
  login: function(el) {
    el.className = el.className.replace("submit-field_pressed", "");

    var username = document.getElementById("username").value.trim();
    var password = document.getElementById("password").value.trim();
    //alert(username + " - " + password);

    window.AndroidJSBridge.login(username, password);
  },
  pageLink: function(bannerName, link, objectId) {
    //alert(bannerName);
    window.AndroidJSBridge.pageLink(bannerName, link, objectId);
  },
  writeComment: function() {
    var content = document.getElementById("content").value.trim();

    if(content.length > 0) {
      window.AndroidJSBridge.writeComment(content);
    }
    else {
      alert("请输入评论内容");
    }
  },
  storeTabIndex: function(pageName, tabIndex) {
    if(!window.AndroidJSBridge || typeof(window.AndroidJSBridge.storeTabIndex) !== "function") {
      MobileBridge.htmlError("window.AndroidJSBridge.storeTabIndex(pageName, tabIndex) not found!");
      return;
    }

    window.AndroidJSBridge.storeTabIndex(pageName, tabIndex);
  },
  restoreTabIndex: function(pageName) {
    if(!window.AndroidJSBridge || typeof(window.AndroidJSBridge.restoreTabIndex) !== "function") {
      MobileBridge.htmlError("window.AndroidJSBridge.restoreTabIndex(pageName) not found!");
      return;
    }

    $(".tab-part").addClass("hidden");
    var tabIndex = window.AndroidJSBridge.restoreTabIndex(pageName);
    var klass = ".tab-part-" + tabIndex;
    $(klass).removeClass("hidden");

    $(".day-container").removeClass("highlight");
    $(".day-container").each(function(){
      var eIndex = parseInt($(this).data("index")) ;
      if(eIndex === tabIndex) {
        $(this).addClass("highlight");
      }
    })
  },
  resetPassword: function(oldPassword, newPassword) {
    window.AndroidJSBridge.resetPassword(oldPassword, newPassword);
  },
  forgetPassword: function(usernum, mobile) {
    window.AndroidJSBridge.forgetPassword(usernum, mobile);
  },
  setSearchItems: function(items) {
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSearchItems) === "function") {
      window.AndroidJSBridge.reportSearchItems(JSON.stringify(items));
    }
    else {
      MobileBridge.htmlError("window.AndroidJSBridge.reportSearchItems(itemsString) not found!");
    }
  },
  setSearchItemsV2: function(items) {
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSearchItemsV2) === "function") {
      window.AndroidJSBridge.reportSearchItemsV2(JSON.stringify(items));
    }
    else {
      MobileBridge.htmlError("window.AndroidJSBridge.reportSearchItemsV2(itemsString) not found!");
    }
  },
  getReportSelectedItem: function(templateCallback) {
    var selectedItem = null;
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSelectedItem) === "function") {
      selectedItem = window.AndroidJSBridge.reportSelectedItem();
    }
    else {
      MobileBridge.htmlError("window.AndroidJSBridge.reportSelectedItem() not found!");
    }

    templateCallback(selectedItem);
  },
  setDashboardDataCount: function(tabType, dataCount) {
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.setDashboardDataCount) === "function") {
      window.AndroidJSBridge.setDashboardDataCount(tabType, dataCount);
    }
    else {
      MobileBridge.htmlError("window.AndroidJSBridge.setDashboardDataCount(tabType, dataCount) not found!");
    }
  },
  hideAd: function() {
    if(window.AndroidJSBridge && typeof(window.AndroidJSBridge.hideAd) === "function") {
      window.AndroidJSBridge.hideAd();
    }
    else {
      MobileBridge.htmlError("window.AndroidJSBridge.hideAd() not found!");
    }
  }
}
window.MBV2WithinIOS = {
  platform: 'ios',
  version: MOBILEBRIDGEVERSION,
  version: function() {
    return window.MobileBridge.platform + " " + MOBILEBRIDGEVERSION;
  },
  connectWebViewJavascriptBridge: function(callback) {
    if(window.WebViewJavascriptBridge) {
      callback(WebViewJavascriptBridge)
    }
    else {
      document.addEventListener('WebViewJavascriptBridgeReady', function() {
        callback(WebViewJavascriptBridge)
      }, false)
    }
  },
  mousedown: function(el) {
    el.className += " submit-field_pressed";
  },
  login: function(el) {
    el.className = el.className.replace("submit-field_pressed", "");

    var username = document.getElementById("username").value.trim();
    var password = document.getElementById("password").value.trim();
    //alert(username + " - " + password);

    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('iosCallback', {'username': username, 'password': password}, function(response) {
      });
    })
  },
  pageLink: function(bannerName, link, objectId) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('iosCallback', {'bannerName': bannerName, 'link': link, 'objectID': objectId}, function(response) {});
    })
  },
  writeComment: function() {
    var content = document.getElementById("content").value.trim();

    if(content.length > 0) {
      MobileBridge.connectWebViewJavascriptBridge(function(bridge){
        bridge.callHandler('writeComment', {'content': content}, function(response) {
        });
      })
    }
    else {
      alert("请输入评论内容");
    }
  },
  storeTabIndex: function(pageName, tabIndex) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('pageTabIndex', {'action': 'store', 'pageName': pageName, 'tabIndex': tabIndex}, function(response) {});
    })
  },
  restoreTabIndex: function(pageName) {
    $(".tab-part").addClass("hidden");
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.init(function(message, responseCallback) {
      })
      bridge.callHandler('pageTabIndex', {'action': 'restore', 'pageName': pageName}, function(response) {
        var tabIndex = response;
        var klass = ".tab-part-" + tabIndex;
        $(klass).removeClass("hidden");

        $(".day-container").removeClass("highlight");
        $(".day-container").each(function(){
          var eIndex = parseInt($(this).data("index")) ;
          if(eIndex === tabIndex) {
            $(this).addClass("highlight");
          }
        })
      });
    })
  },
  resetPassword: function(oldPassword, newPassword) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.init(function(message, responseCallback) {
      })
      bridge.callHandler('ResetPassword', {'oldPassword': oldPassword, 'newPassword': newPassword}, function(response) {
      });
    })
  },
  forgetPassword: function(usernum, mobile) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.init(function(message, responseCallback) {
      })
      bridge.callHandler('ForgetPassword', {'usernum': usernum, 'mobile': mobile}, function(response) {
      });
    })
  },
  setSearchItems: function(items) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.init(function(message, responseCallback) {})
      bridge.callHandler('searchItems', {'items': items}, function(response) {});
    })
  },
  setSearchItemsV2: function(items) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.init(function(message, responseCallback) {})
      bridge.callHandler('setSearchItemsV2', {'items': items}, function(response) {});
    })
  },
  getReportSelectedItem: function(templateCallback) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('selectedItem', {}, function(response) {
        templateCallback(response);
      });
    })
  },
  setDashboardDataCount: function(tabType, dataCount) {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('dashboardDataCount', {'tabType': tabType, 'dataCount': dataCount}, function(response) {
      });
    })
  },
  hideAd: function() {
    MobileBridge.connectWebViewJavascriptBridge(function(bridge){
      bridge.callHandler('hideAd', {}, function(response) {
      });
    })
  }
}

window.MobileBridge = {
  platform: 'default',
  version: MOBILEBRIDGEVERSION,
  version: function() {
    return window.MobileBridge.platform + " " + MOBILEBRIDGEVERSION;
  },
  alert: function(message) {
    alert('当前浏览器非移动端:\n' + message);
  },
  login: function(el) {
    MobileBridge.alert('login');
  },
  pageLink: function(bannerName, link, objectId) {
    MobileBridge.alert('pageLink');
  },
  writeComment: function() {
    MobileBridge.alert("writeComment");
  },
  storeTabIndex: function(pageName, tabIndex) {
    MobileBridge.alert('storeTabIndex');
  },
  restoreTabIndex: function(pageName) {
    MobileBridge.alert("restoreTabIndex");
  },
  setSearchItems: function(items) {
    MobileBridge.alert("setSearchItems");
  },
  setSearchItemsV2: function(items) {
    MobileBridge.alert("setSearchItemsV2");
  },
  reportSelectedItem: function() {
    MobileBridge.alert("reportSelectedItem");
  },
  setDashboardDataCount: function(tabType, dataCount) {
    MobileBridge.alert("setDashboardDataCount");
  },
  hideAd: function() {
    MobileBridge.alert("hideAd");
  },
  resetPassword: function(oldPassword, newPassword) {
    MobileBridge.alert("resetPassword");
  },
  forgetPassword: function(usernum, mobile) {
    MobileBridge.alert("forgetPassword");
  }
}

var userAgent = navigator.userAgent,
    isAndroid = userAgent.indexOf('Android') > -1 || userAgent.indexOf('Adr') > -1,
    isiOS = !!userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
if(isiOS) {
  window.MobileBridge = window.MBV2WithinIOS;
} else if(isAndroid) {
  window.MobileBridge = window.MBV2WithinAndroid;
}
console.log(window.MobileBridge.version());
