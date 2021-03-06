#!/usr/bin/env ruby
# encoding: utf-8
#
# ## 调整事项:
# 1. 应用图标、loading.zip
# 2. Info.plist应用名称
# 3. constant_private.h 服务器域名、友盟、蒲公英配置
#
# $ bundle exec ruby config/app_keeper.rb -h
# usage: config/app_keeper.rb [options]
#     -a, --app       current app
#     -p, --plist     Info.plist
#     -e, --assets    assets.xassets
#     -c, --constant  constant_private.h
#     -u, --pgyer     upload ipa to pgyer
#     -v, --version   print the version
#     -h, --help      print help info
#
require 'pp'
require 'slop'
require 'json'
require 'plist'
require 'settingslogic'
require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'active_support/core_ext/numeric'

def exit_when condition, &block
  return unless condition
  yield
  exit
end

slop_opts = Slop.parse do |o|
  o.string '-a', '--app', 'current app'
  o.bool '-p', '--plist', 'Info.plist', default: false
  o.bool '-e', '--assets', 'assets.xassets', default: false
  o.bool '-c', '--constant', 'constant_private.h', default: false
  o.bool '-u', '--pgyer', 'upload ipa to pgyer', default: false
  o.bool '-w', '--view', 'pgyer version info', default: false
  o.on '-v', '--version', 'print the version' do
    puts Slop::VERSION
    exit
  end
  o.on '-h', '--help', 'print help info' do
    puts o
    exit
  end
end

current_app = slop_opts[:app] || `cat .current-app`.strip
bundle_display_hash = {
  yonghui: '永辉生意人',
  yonghuitest: '永辉应用(测试)',
  shengyiplus: '生意+',
  qiyoutong: '企邮通'
}
bundle_display_names = bundle_display_hash.keys.map(&:to_s)
exit_when !bundle_display_names.include?(current_app) do
  puts %(Abort: app name should in #{bundle_display_names}, but #{current_app})
end

`echo '#{current_app}' > .current-app`
puts %(# current app: #{current_app}\n\n)

NAME_SPACE = current_app # TODO: namespace(variable_instance)
class Settings < Settingslogic
  source 'config/config.yaml'
  namespace NAME_SPACE
end

#
# reset bundle display name
#
if slop_opts[:plist]
  puts %(- done: bundle display name: #{bundle_display_hash[current_app.to_sym]})
  plist_path = "YH-IOS/Info.plist"
  plist_hash = Plist::parse_xml(plist_path)
  plist_hash['CFBundleDisplayName'] = bundle_display_hash[current_app.to_sym]
  plist_hash['CFBundleName'] = bundle_display_hash[current_app.to_sym]
  plist_hash['CFBundleURLTypes'][0]['CFBundleURLSchemes'][0] = Settings.umeng_weixin.ios.app_id
  File.open(plist_path, 'w:utf-8') { |file| file.puts(plist_hash.to_plist) }
end

#
# reset assets.xcassets
#
if slop_opts[:assets]
  puts %(- done: updated appiconset, imageset, loading.zip)
  `rm -fr YH-IOS/Assets.xcassets/AppIcon.appiconset && cp -rf config/Assets.xcassets/#{current_app}/AppIcon.appiconset YH-IOS/Assets.xcassets/`
  `rm -fr YH-IOS/Assets.xcassets/AppIcon.imageset && cp -rf config/Assets.xcassets/#{current_app}/AppIcon.imageset YH-IOS/Assets.xcassets/`
  `rm -fr YH-IOS/Assets.xcassets/Banner-Logo.imageset && cp -rf config/Assets.xcassets/#{current_app}/Banner-Logo.imageset YH-IOS/Assets.xcassets/`
  `rm -fr YH-IOS/Assets.xcassets/Banner-Setting.imageset && cp -rf config/Assets.xcassets/#{current_app}/Banner-Setting.imageset YH-IOS/Assets.xcassets/`
  `rm -fr YH-IOS/Assets.xcassets/background.imageset && cp -rf config/Assets.xcassets/#{current_app}/background.imageset YH-IOS/Assets.xcassets/`
  `rm -fr YH-IOS/Assets.xcassets/Login-Logo.imageset && cp -rf config/Assets.xcassets/#{current_app}/Login-Logo.imageset YH-IOS/Assets.xcassets/`
end

#
# rewrite private setting
#
if slop_opts[:constant]
  constant_path = 'YH-IOS/Macros/PrivateConstants.h'
  puts %(- done: write #{constant_path})
  File.open(constant_path, 'w:utf-8') do |file|
    file.puts <<-EOF.strip_heredoc
    //  PrivateConstants.h
    //
    //  `bundle install`
    //  `./appkeeper.sh #{current_app}`
    //
    //  Created by lijunjie on 16/04/08.
    //  Copyright © 2016年 com.intfocus. All rights reserved.
    //

    // current app: [#{current_app}]
    // automatic generated by app_keeper.rb
    #ifndef PrivateConstants_h
    #define PrivateConstants_h

    #define kAppCode          @"#{Settings.app_code}"
    #define kBaseUrl          @"#{Settings.server}"
    #define kBaseUrl1         @"http://localhost:4567"

    #define kInitPassword     @"123456"
    #define kLoginSlogan      @"#{Settings.slogan_text}"

    #define kPgyerAppId       @"#{Settings.pgyer.ios}"
    #define kPgyerUrl         @"http://www.pgyer.com/#{Settings.key_store.alias}-i"

    #define kUMAppId          @"#{Settings.umeng.ios.app_key}"
    #define kWXAppId          @"#{Settings.umeng_weixin.ios.app_id}"
    #define kWXAppSecret      @"#{Settings.umeng_weixin.ios.app_secret}"

    #define kDashboardAd      #{Settings.display_status.dashboard_ad == 1 ? 'YES' : 'NO'}

    #define kDropMenuScan     #{Settings.display_status.drop_menu_scan == 1 ? 'YES' : 'NO'}
    #define kDropMenuVoice    #{Settings.display_status.drop_menu_voice == 1 ? 'YES' : 'NO'}
    #define kDropMenuSearch   #{Settings.display_status.drop_menu_search == 1 ? 'YES' : 'NO'}
    #define kDropMenuUserInfo #{Settings.display_status.drop_menu_user_info == 1 ? 'YES' : 'NO'}

    #define kTabBar           #{Settings.display_status.tab_bar == 1 ? 'YES' : 'NO'}
    #define kTabBarKPI        #{Settings.display_status.tab_bar_kpi == 1 ? 'YES' : 'NO'}
    #define kTabBarAnalyse    #{Settings.display_status.tab_bar_analyse == 1 ? 'YES' : 'NO'}
    #define kTabBarApp        #{Settings.display_status.tab_bar_app == 1 ? 'YES' : 'NO'}
    #define kTabBarMessage    #{Settings.display_status.tab_bar_message == 1 ? 'YES' : 'NO'}

    #define kSubjectComment   #{Settings.display_status.subject_comment == 1 ? 'YES' : 'NO'}
    #define kSubjectShare     #{Settings.display_status.subject_share == 1 ? 'YES' : 'NO'}

    #endif /* PrivateConstants_h */
    EOF
  end
end

#
# upload ipa to pgyer
#
if slop_opts[:pgyer]
  def upload_ipa(ipa_path, retry_num = 0)
    command = %(curl -F "file=@#{ipa_path}" -F "uKey=#{Settings.pgyer.user_key}" -F "_api_key=#{Settings.pgyer.api_key}" https://www.pgyer.com/apiv1/app/upload)
    response = `#{command}`

    hash = JSON.parse(response).deep_symbolize_keys[:data]
    puts %(- done: upload ipa(#{hash[:appFileSize].to_i.to_s(:human_size)}) to #pgyer#\n\t#{hash[:appName]}\n\t#{hash[:appIdentifier]}\n\t#{hash[:appVersion]}(#{hash[:appVersionNo]})\n\t#{hash[:appQRCodeURL]})
  rescue => e
    puts command
    puts e.message
    puts response.inspect

    upload_ipa(ipa_path, retry_num + 1) if retry_num < 3
  end

  ipa_path = `find ~/Desktop -name "YH-IOS.ipa" | sort | tail -n 1`.strip
  exit_when !File.exist?(ipa_path) do
    puts %(Abort: ipa not found - #{ipa_path})
  end
  puts %(- done: generate apk(#{File.size(ipa_path).to_s(:human_size)}) - #{ipa_path})
  upload_ipa(ipa_path)
end


if slop_opts[:view]
  def view_pgyer_version
    api_url = 'https://www.pgyer.com/apiv1/app/getAppKeyByShortcut'
    command = format('curl --silent --data "shortcut=%s&_api_key=%s" %s', Settings.pgyer.shortcut , Settings.pgyer.api_key, api_url)
    response = `#{command}`

    hash = JSON.parse(response).deep_symbolize_keys
    data = hash.dig(:data)
    data[:appSize] = data[:appFileSize].to_i.to_s(:human_size)
    pp data.slice(:appFileName, :appSize, :appFileSize, :appName, :appVersion, :appVersionNo, :appIdentifier, :appCreated)
  rescue => e
    puts command
    puts response.inspect
    puts e.message
  end

  view_pgyer_version
end
