MOBILEBRIDGEVERSION = '2.0.1'

String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/g, '');
}
window.onerror = function(e) {
    if (window.AndroidJSBridge && window.AndroidJSBridge.jsException) {
        window.AndroidJSBridge.jsException(e);
    } else {
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
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.htmlError) === "function") {
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

        if (content.length > 0) {
            window.AndroidJSBridge.writeComment(content);
        } else {
            alert("请输入评论内容");
        }
    },
    storeTabIndex: function(pageName, tabIndex) {
        if (!window.AndroidJSBridge || typeof(window.AndroidJSBridge.storeTabIndex) !== "function") {
            MobileBridge.htmlError("window.AndroidJSBridge.storeTabIndex(pageName, tabIndex) not found!");
            return;
        }

        window.AndroidJSBridge.storeTabIndex(pageName, tabIndex);
    },
    restoreTabIndex: function(pageName) {
        if (!window.AndroidJSBridge || typeof(window.AndroidJSBridge.restoreTabIndex) !== "function") {
            MobileBridge.htmlError("window.AndroidJSBridge.restoreTabIndex(pageName) not found!");
            return;
        }

        $(".tab-part").addClass("hidden");
        var tabIndex = window.AndroidJSBridge.restoreTabIndex(pageName);
        var klass = ".tab-part-" + tabIndex;
        $(klass).removeClass("hidden");

        $(".day-container").removeClass("highlight");
        $(".day-container").each(function() {
            var eIndex = parseInt($(this).data("index"));
            if (eIndex === tabIndex) {
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
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSearchItems) === "function") {
            window.AndroidJSBridge.reportSearchItems(JSON.stringify(items));
        } else {
            MobileBridge.htmlError("window.AndroidJSBridge.reportSearchItems(itemsString) not found!");
        }
    },
    setSearchItemsV2: function(items) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSearchItemsV2) === "function") {
            window.AndroidJSBridge.reportSearchItemsV2(JSON.stringify(items));
        } else {
            MobileBridge.htmlError("window.AndroidJSBridge.reportSearchItemsV2(itemsString) not found!");
        }
    },
    getReportSelectedItem: function(templateCallback) {
        var selectedItem = null;
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.reportSelectedItem) === "function") {
            selectedItem = window.AndroidJSBridge.reportSelectedItem();
        } else {
            MobileBridge.htmlError("window.AndroidJSBridge.reportSelectedItem() not found!");
        }

        templateCallback(selectedItem);
    },
    setDashboardDataCount: function(tabType, dataCount) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.setDashboardDataCount) === "function") {
            window.AndroidJSBridge.setDashboardDataCount(tabType, dataCount);
        } else {
            MobileBridge.htmlError("window.AndroidJSBridge.setDashboardDataCount(tabType, dataCount) not found!");
        }
    },
    hideAd: function() {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.hideAd) === "function") {
            window.AndroidJSBridge.hideAd();
        } else {
            MobileBridge.htmlError("window.AndroidJSBridge.hideAd() not found!");
        }
    },
    /*
     * 原生弹出框
     *
     * 网页内部的 `alert` 弹出框，标题为网页所在文件夹名称，用户体验不佳。
     *
     * title  : 标题名称（暂未使用，可传空）
     * message: 弹出框内容
     */
    showAlert: function(title, message) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.showAlert) === "function") {
            window.AndroidJSBridge.showAlert(title, message);
        } else {
            alert("Error 未定义接口(Android): showAlert");
        }
    },
    /*
     * 原生弹出框，点击『确定』后跳转至其他链接
     *
     * 使用原生弹出框但继续使用网页内部的跳转方式时，跳转操作不会等弹出框的业务操作
     *
     * title       : 标题名称（暂未使用，可传空）
     * message     : 弹出框内容
     * redirectUrl : 待跳转的链接
     */
    showAlertAndRedirect: function(title, message, redirectUrl) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.showAlertAndRedirectV1) === "function") {
            window.AndroidJSBridge.showAlertAndRedirectV1(title, message, redirectUrl, 'no');
        } else {
            alert("Error 未定义接口(Android): showAlertAndRedirect");
        }
    },
    /*
     * 原生弹出框，点击『确定』后跳转至其他链接，清空链接栈
     *
     * 有些业务流程不可以返回历史链接，比如『新建』，所以跳转至该链接时，清空栈，点击标题栏中的『返回』则关闭浏览器
     *
     * title       : 标题名称（暂未使用，可传空）
     * message     : 弹出框内容
     * redirectUrl : 待跳转的链接
     */
    showAlertAndRedirectWithCleanStack: function(title, message, redirectUrl) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.showAlertAndRedirectV1) === "function") {
            window.AndroidJSBridge.showAlertAndRedirectV1(title, message, redirectUrl, 'yes');
        } else {
            alert("Error 未定义接口(Android): showAlertAndRedirect");
        }
    },
    /*
     * 控制原生标题栏的隐藏及显示
     *
     * 有些业务操作在弹出页面中已有标题栏，此时可以通过该函数控制原生标题栏的隐藏及显示
     *
     * state: 显示或隐藏（show/hidden）
     */
    toggleShowBanner: function(state) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.toggleShowBanner) === "function") {
            window.AndroidJSBridge.toggleShowBanner(state);
        } else {
            alert("Error 未定义接口(Android):  toggleShowBanner");
        }
    },
    /*
     * 首页底部页签显示 badge 数字
     *
     * type: 类型（仅支持: total）
     * num : badge 数字
     */
    appBadgeNum: function(type, num) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.appBadgeNum) === "function") {
            window.AndroidJSBridge.appBadgeNum(type, num);
        } else {
            alert("Error 未定义接口(Android): appBadgeNum");
        }
    },
    /*
     * 控制标题栏中标题内容
     *
     * title: 标题内容
     */
    setBannerTitle: function(title) {
        if (window.AndroidJSBridge && typeof(window.AndroidJSBridge.setBannerTitle) === "function") {
            window.AndroidJSBridge.setBannerTitle(title);
        } else {
            alert("Error 未定义接口(Android): setBannerTitle");
        }
    },
    toggleShowBannerMenu: function(state) {
        window.AndroidJSBridge.toggleShowBannerMenu(state);
    },
    toggleShowBannerBack: function(state) {
        window.AndroidJSBridge.toggleShowBannerBack(state);
    },
    getLocation: function(callback) {
        var location = window.AndroidJSBridge.getLocation();
        callback(location);
    },
    closeSubjectView: function() {
        window.AndroidJSBridge.closeSubjectView();
    },
    refreshBrowser: function() {
        window.AndroidJSBridge.refreshBrowser();
    }
}
window.MBV2WithinIOS = {
    platform: 'ios',
    version: MOBILEBRIDGEVERSION,
    version: function() {
        return window.MobileBridge.platform + " " + MOBILEBRIDGEVERSION;
    },
    connectWebViewJavascriptBridge: function(callback) {
        if (window.WebViewJavascriptBridge) {
            callback(WebViewJavascriptBridge)
        } else {
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

        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('iosCallback', { 'username': username, 'password': password }, function(response) {});
        })
    },
    pageLink: function(bannerName, link, objectId) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('iosCallback', { 'bannerName': bannerName, 'link': link, 'objectID': objectId }, function(response) {});
        })
    },
    writeComment: function() {
        var content = document.getElementById("content").value.trim();

        if (content.length > 0) {
            MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
                bridge.callHandler('writeComment', { 'content': content }, function(response) {});
            })
        } else {
            alert("请输入评论内容");
        }
    },
    storeTabIndex: function(pageName, tabIndex) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('pageTabIndex', { 'action': 'store', 'pageName': pageName, 'tabIndex': tabIndex }, function(response) {});
        })
    },
    restoreTabIndex: function(pageName) {
        $(".tab-part").addClass("hidden");
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            try { bridge.init(function(message, responseCallback) {}); } catch (e) {}
            bridge.callHandler('pageTabIndex', { 'action': 'restore', 'pageName': pageName }, function(response) {
                var tabIndex = response;
                var klass = ".tab-part-" + tabIndex;
                $(klass).removeClass("hidden");

                $(".day-container").removeClass("highlight");
                $(".day-container").each(function() {
                    var eIndex = parseInt($(this).data("index"));
                    if (eIndex === tabIndex) {
                        $(this).addClass("highlight");
                    }
                })
            });
        })
    },
    resetPassword: function(oldPassword, newPassword) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            try { bridge.init(function(message, responseCallback) {}); } catch (e) {}
            bridge.callHandler('ResetPassword', { 'oldPassword': oldPassword, 'newPassword': newPassword }, function(response) {});
        })
    },
    forgetPassword: function(usernum, mobile) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            try { bridge.init(function(message, responseCallback) {}); } catch (e) {}
            bridge.callHandler('ForgetPassword', { 'usernum': usernum, 'mobile': mobile }, function(response) {});
        })
    },
    setSearchItems: function(items) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            try { bridge.init(function(message, responseCallback) {}); } catch (e) {}
            bridge.callHandler('searchItems', { 'items': items }, function(response) {});
        })
    },
    setSearchItemsV2: function(items) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            try { bridge.init(function(message, responseCallback) {}); } catch (e) {}
            bridge.callHandler('setSearchItemsV2', { 'items': items }, function(response) {});
        })
    },
    getReportSelectedItem: function(templateCallback) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('selectedItem', {}, function(response) {
                templateCallback(response);
            });
        })
    },
    setDashboardDataCount: function(tabType, dataCount) {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('dashboardDataCount', { 'tabType': tabType, 'dataCount': dataCount }, function(response) {});
        })
    },
    hideAd: function() {
        MobileBridge.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('hideAd', {}, function(response) {});
        })
    },
    showAlert: function(title, message) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('showAlert', { 'title': title, 'content': message }, function(response) {});
        })
    },
    showAlertAndRedirect: function(title, message, redirectUrl) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('showAlertAndRedirect', { 'title': title, 'content': message, 'redirectUrl': redirectUrl, 'cleanStack': 'no' }, function(response) {});
        })
    },
    showAlertAndRedirectWithCleanStack: function(title, message, redirectUrl) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('showAlertAndRedirect', { 'title': title, 'content': message, 'redirectUrl': redirectUrl, 'cleanStack': 'yes' }, function(response) {});
        })
    },
    toggleShowBanner: function(state) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('toggleShowBanner', { 'state': state }, function(response) {});
        })
    },
    setBannerTitle: function(title) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('setBannerTitle', { 'title': title }, function(response) {});
        })
    },
    toggleShowBannerBack: function(state) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('toggleShowBannerBack', { 'state': state }, function(response) {});
        })
    },
    toggleShowBannerMenu: function(state) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('toggleShowBannerMenu', { 'state': state }, function(response) {});
        })
    },
    getLocation: function(templateCallback) {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('getLocation', {}, function(response) {
                templateCallback(response);
            });
        })
    },
    closeSubjectView: function() {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('closeSubjectView', function(data, responseCallback) {});
        })
    },
    refreshBrowser: function() {
        SYPWithinIOS.connectWebViewJavascriptBridge(function(bridge) {
            bridge.callHandler('refreshBrowser', function(data, responseCallback) {});
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
        console.log('当前浏览器非移动端:\n' + message);
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
    },
    showAlert: function(title, message) {
        alert(message);
    },
    showAlertAndRedirect: function(title, message, redirectUrl) {
        window.location.href = redirectUrl.split('@')[1];
    },
    showAlertAndRedirectWithCleanStack: function(title, message, redirectUrl) {
        alert(message);
        window.SYP.pageLink(redirectUrl.split('@')[1]);
    },
    toggleShowBanner: function(state) {
        console.log({ 'toggleShowBanner state': state });
    },
    appBadgeNum: function(type, num) {
        console.log({ 'type': type, 'num': num });
    },
    setBannerTitle: function(title) {
        $(document).attr("title", title);
    },
    addSubjectMenuItems: function(menuItems) {
        console.log({ 'menu_items': menuItems });
    },
    closeSubjectView: function() {
        window.AndroidJSBridge.closeSubjectView();
    },
    toggleShowBannerBack: function(state) {
        console.log({ 'toggleShowBannerBack': state });
    },
    toggleShowBannerMenu: function(state) {
        console.log({ 'toggleShowBannerMenu': state });
    },
    getLocation: function() {
        console.log('getLocation');
    },
    closeSubjectView: function() {
        console.log('closeSubjectView');
    }
}

var userAgent = navigator.userAgent,
    isAndroid = userAgent.indexOf('Android') > -1 || userAgent.indexOf('Adr') > -1,
    isiOS = !!userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
if (isiOS) {
    window.MobileBridge = window.MBV2WithinIOS;
} else if (isAndroid) {
    window.MobileBridge = window.MBV2WithinAndroid;
}
console.log(window.MobileBridge.version());